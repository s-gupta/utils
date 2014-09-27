function jobId = pbsRunFunctions(jobName, batchDir, workDir, nodes, ppn, mem, HH, matF, notif, minJobs, maxJobs, username, offSet, pTime, compiledCode, fName, qName, parallel, toStop)
%function pbsRunFunctions(jobName, batchDir, workDir, nodes, ppn, mem, HH, matF, notif, minJobs, maxJobs, username, offSet, pTime, compiledCode, fName, qName, parallel)
if(~exist('compiledCode','var'))
	compiledCode = false;
end
if(~exist('pTime','var'))
	pTime = 60;
end
if(~exist('offSet','var'))
	offSet = 0;
end
if(~exist('qName','var'))
	qName = 'psi';
end
if(~exist('toStop', 'var'))
	toStop = true;
end

fname = fullfile(batchDir, sprintf('%s.sh',jobName));
paramFile = fullfile(batchDir, sprintf('%s_param.mat',jobName));
save(paramFile,'pTime','minJobs','maxJobs');

fid = fopen(fname,'w');
if (fid==-1), 
	error('Could not open file %s for writing.',fname);
end
fprintf(fid,['#!/bin/sh \n']);
fprintf(fid,['#PBS -N ' jobName '\n']);
fprintf(fid,['#PBS -r n\n']);
if (notif),
   fprintf(fid, '#PBS -m ae\n');
   fprintf(fid,['#PBS -M ' username '@eecs.berkeley.edu\n']);
end
fprintf(fid, ['#PBS -w ' workDir '\n']);
%fprintf(fid, ['#PBS -e ' fullfile(batchDir,sprintf('%s.err',jobName)) '\n']);
%fprintf(fid, ['#PBS -o ' fullfile(batchDir,sprintf('%s.log',jobName)) '\n']);
fprintf(fid, ['#PBS -e ' '/dev/null' '\n']);
fprintf(fid, ['#PBS -o ' '/dev/null' '\n']);
fprintf(fid, ['#PBS -q ' qName ' \n']);
fprintf(fid, ['#PBS -l nodes=' num2str(nodes) ':ppn=' num2str(ppn) '\n\n']);
if (mem>0),
   fprintf(fid, ['#PBS -l mem=' num2str(mem) 'g \n']);
end
if (HH>0),
	MM = floor((HH-floor(HH))*60);
   fprintf(fid, ['#PBS -l walltime=' num2str(floor(HH)) ':' num2str(MM,'%02d') ':00 \n']);
   fprintf(fid, ['#PBS -l cput=' num2str(floor(HH)) ':' num2str(MM,'%02d') ':00 \n']);
end
%fprintf(fid, '#PBS -l host=s111\n');
fprintf(fid, ['echo Working directory is $PBS_O_WORKDIR \n']);
fprintf(fid, ['cd $PBS_O_WORKDIR \n']);
fprintf(fid, 'echo Running on host `hostname` \n');
fprintf(fid, 'echo Time is `date` \n');
fprintf(fid, 'echo Directory is `pwd` \n');
fprintf(fid, 'echo This jobs runs on the following processors: \n'); 
fprintf(fid, 'echo `cat $PBS_NODEFILE` \n');
fprintf(fid, 'NPROCS=`wc -l < $PBS_NODEFILE` \n'); 
fprintf(fid, 'echo This job has allocated $NPROCS cpus \n');
fprintf(fid, 'echo This job is the $PBS_ARRAYID th function \n');
fprintf(fid, '\n');

fprintf(fid, 'PYTHONPATH=/home/eecs/sgupta/lib/mpi/lib64/ \n');
% fprintf(fid, 'LD_PRELOAD=/lib/libgcc_s.so.1:/usr/lib/libstdc++.so.6 \n');
% fprintf(fid, 'export LD_PRELOAD \n');
fprintf(fid, 'PATH=/home/eecs/sgupta/lib/mpi/bin/:$PATH \n');
fprintf(fid, 'LD_LIBRARY_PATH=/home/eecs/sgupta/lib/mpi/lib64/:$LD_LIBRARY_PATH \n');
fprintf(fid, 'export PYTHONPATH \n');
fprintf(fid, 'export PATH \n');
fprintf(fid, 'export LD_LIBRARY_PATH \n');

%matlabpoolStr = @(x) sprintf('matlabpool open local %d; ', x);
matlabpoolStr = @(x) sprintf('openPool(%d); ', x);

if(compiledCode)
	matlabString = '/usr/sww/pkg/matlab-r2012b/'; 
	if(length(matF) > 0)
		fprintf(fid,'if [ $PBS_ARRAYID = %d ]; then \n',offSet+1);
		fprintf(fid, ['\t' fName ' ' matlabString ' ' matF{1} '\n']);
		for i = 2:length(matF)
			fprintf(fid, 'elif [ $PBS_ARRAYID = %d ]; then \n',offSet+i);
			fprintf(fid, ['\t' fName ' ' matlabString ' ' matF{i} '\n']);
		end
		fprintf(fid,'fi \n');
	end
else
	if(true), %ppn > 0 & parallel == 0)
		matlabString = 'env LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libstdc++.so.6.0.16 /usr/sww/pkg/matlab-r2012b/bin/matlab -nodisplay -r ' 
		% matlabString = '/usr/sww/pkg/matlab-r2012b/bin/matlab -nodisplay -r ' 
	else
		matlabString = '/usr/sww/pkg/matlab-r2012b/bin/matlab -singleCompThread -nodisplay -r ' 
	end
	%matlabString = '/usr/sww/pkg/matlab-r2008a/bin/matlab -nodisplay -r ' 
	if(length(matF) > 0)
		fprintf(fid,'if [ $PBS_ARRAYID = %d ]; then \n',offSet+1);
		if(parallel > 0)
			fprintf(fid, ['\t' matlabString '" t = tic(); ' matlabpoolStr(round(ppn*parallel)), matF{1} '; matlabpool close; toc(t); quit;" ']);
		elseif (ppn > 1),
			fprintf(fid, ['\t' matlabString '" t = tic(); ', sprintf('maxNumCompThreads(%d); ', 2*ppn),  matF{1} '; toc(t); quit;" ']);
		else
			fprintf(fid, ['\t' matlabString '" t = tic();', sprintf('maxNumCompThreads(%d); ', ppn), matF{1} '; toc(t); quit;" ']);
		end
		%fprintf(fid, '2 > %s.err-%d ', fullfile(batchDir,sprintf('%s',jobName)), offSet+1);
		fprintf(fid, '1 > %s.log-%03d 2>&1\n', fullfile(batchDir,sprintf('%s',jobName)), offSet+1);
		for i = 2:length(matF)
			fprintf(fid, 'elif [ $PBS_ARRAYID = %d ]; then \n',offSet+i);
			if(parallel > 0)
				fprintf(fid, ['\t' matlabString '" t = tic(); ' matlabpoolStr(round(ppn*parallel)), matF{i} '; matlabpool close; toc(t); quit;" ']);
			elseif (ppn > 1),
				fprintf(fid, ['\t' matlabString '" t = tic(); ', sprintf('maxNumCompThreads(%d); ', 2*ppn),  matF{i} '; toc(t); quit;" ']);
			else
				fprintf(fid, ['\t' matlabString '" t = tic();', sprintf('maxNumCompThreads(%d); ', ppn),  matF{i} '; toc(t); quit;" ']);
			end
			fprintf(fid, '1 > %s.log-%03d 2>&1\n', fullfile(batchDir,sprintf('%s',jobName)), offSet+i);
		end
		fprintf(fid,'fi \n');
	end
end

fclose(fid);
pause(0.01);
if(toStop)
	keyboard;
end

nJobs = length(matF);
launched = 0;
jobId = {};
while launched < nJobs,
	%Check how many are running..
	load(paramFile);
	cmd = ['qstat -a| grep ' username ' | grep ''' jobName ''' | wc -l'];
	[gr a] = system(cmd);
	runningNow =  str2num(a(regexp(a,'[0-9]')));
	tm = fix(clock());
	fprintf('%d:%d:%d: %s, launched: %d/%d jobs already, runningNow: str: %s, goodStr: %s, lenStr: %d, parsedStr: %d.\n', tm(4), tm(5), tm(6), cmd, launched, nJobs, a, a(regexp(a,'[0-9]')), length(a), runningNow);
	%canLaunch = min(maxJobs-runningNow, maxJobs-minJobs);
	cL = 30;
	% if(parallel) cL = 1; end
	canLaunch = min(maxJobs-runningNow, cL);
	%If running less than minJobs, launch new jobs..
	if(runningNow < minJobs)
		cmd = sprintf('qsub %s -t %d-%d',fname,offSet+launched+1,offSet+min(launched+canLaunch,nJobs));
		fprintf('%d:%d:%d: %s, launching: %d new jobs. %d-%d.\n',tm(4),tm(5),tm(6),cmd,canLaunch,offSet+launched+1,offSet+min(launched+canLaunch,nJobs));
		[~, outStr] = system(cmd);
		qId = str2num(outStr(1:7));
		for i = (offSet+launched+1):(offSet+min(launched+canLaunch,nJobs));
			jobId{end+1} = sprintf('%d-%d', qId, i);
		end
		launched = min(launched+canLaunch,nJobs);
	end
	%Pause for some time
	pause(pTime);
end
end
