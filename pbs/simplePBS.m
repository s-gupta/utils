function jobId = simplePBS(jobName, logDir, codeDir, nodes, ppn, mem, hh, dirName, notif, username, headNode, qName, numJobs, fnPath, fnName)
% function jobId = simplePBS(jobName, logDir, codeDir, nodes, ppn, mem, hh, dirName, notif, username, headNode, qName, numJobs, fnPath, fnName)
  
  fname = fullfile(logDir, sprintf('%s.sh',jobName));

  fid = fopen(fname,'w');
  if (fid==-1), 
    error('Could not open file %s for writing.',fname);
  end
  fprintf(fid,['#!/bin/sh \n']);
  fprintf(fid,['#PBS -N ' jobName '\n']);
  fprintf(fid,['#PBS -r n\n']);
  if (notif), fprintf(fid, '#PBS -m ae\n'); fprintf(fid,['#PBS -M ' username '@eecs.berkeley.edu\n']); end
  fprintf(fid, ['#PBS -w ' codeDir '\n']);
  fprintf(fid, ['#PBS -e ' '/dev/null' '\n']);
  fprintf(fid, ['#PBS -o ' '/dev/null' '\n']);
  fprintf(fid, ['#PBS -q ' qName ' \n']);
  fprintf(fid, ['#PBS -l nodes=' num2str(nodes) ':ppn=' num2str(ppn) '\n\n']);
  if (mem>0),
     fprintf(fid, '#PBS -l mem=%dg \n', mem);
  end
  if (hh>0),
    MM = floor((hh-floor(hh))*60);
    fprintf(fid, '#PBS -l walltime=%d:%02d:00 \n', floor(hh), MM);
    fprintf(fid, '#PBS -l cput=%d:%02d:00 \n', floor(hh), MM);
  end

  fprintf(fid, 'echo Working directory is $PBS_O_WORKDIR \n');
  fprintf(fid, 'ID=`printf %%03d $PBS_ARRAYID` \n');
  fprintf(fid, 'echo Running job number $ID \n');
 
  %fprintf(fid, '#PBS -l host=s111\n');
  fprintf(fid, 'echo Working directory is $PBS_O_WORKDIR \n');
  fprintf(fid, 'cd $PBS_O_WORKDIR \n');
  fprintf(fid, 'echo Running on host `hostname` \n');
  fprintf(fid, 'echo Time is `date` \n');
  fprintf(fid, 'echo Directory is `pwd` \n');
  %fprintf(fid, 'echo This jobs runs on the following processors: \n'); 
  %fprintf(fid, 'echo `cat $PBS_NODEFILE` \n');
  %fprintf(fid, 'NPROCS=`wc -l < $PBS_NODEFILE` \n'); 
  %fprintf(fid, 'echo This job has allocated $NPROCS cpus \n');
  %fprintf(fid, 'echo This job is the $PBS_ARRAYID th function \n');
  fprintf(fid, '\n');

  % fprintf(fid, 'PYTHONPATH=/home/eecs/sgupta/lib/mpi/lib64/ \n');
  % fprintf(fid, 'LD_PRELOAD=/lib/libgcc_s.so.1:/usr/lib/libstdc++.so.6 \n');
  % fprintf(fid, 'export LD_PRELOAD \n');
  % fprintf(fid, 'PATH=/home/eecs/sgupta/lib/mpi/bin/:$PATH \n');
  % fprintf(fid, 'LD_LIBRARY_PATH=/home/eecs/sgupta/lib/mpi/lib64/:$LD_LIBRARY_PATH \n');
  % fprintf(fid, 'export PYTHONPATH \n');
  % fprintf(fid, 'export PATH \n');
  % fprintf(fid, 'export LD_LIBRARY_PATH \n');

  matlabString = 'env LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libstdc++.so.6.0.16 /usr/sww/pkg/matlab-r2012b/bin/matlab -nodisplay -r '; 
  % matlabString = '/usr/sww/pkg/matlab-r2012b/bin/matlab -nodisplay -r '; 

  fprintf(fid, '%s "addpath %s; t = tic(); %s(''%s'', $ID, %d); toc(t); quit; " ', matlabString, fnPath, fnName, logDir, numJobs);
  fprintf(fid, '1 > %s-$ID 2>&1\n', fullfile(logDir, 'log.log'));
  
  fclose(fid);
  pause(0.01);
  
  % if(toStop), keyboard; end

  % uncomment for using ssh ing into the headNode
  cmd = sprintf('ssh %s ''qsub %s -t %d-%d'' ', headNode, fname, 1, numJobs);
  % cmd = sprintf('qsub %s -t %d-%d', fname, 1, numJobs);

  fprintf('Running %s\n', cmd);
  [~, outStr] = system(cmd);
  jobId = outStr; %str2num(outStr(1:7));
end
