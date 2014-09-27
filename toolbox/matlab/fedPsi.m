function [out,res] = fedPsi( funNm, jobs, pLaunch)
  % Run jobs on the psi cluster
  
  % jobParam = struct('numThreads', 1, 'codeDir', '/home/eecs/sgupta/Projects/pbs2/test', 'preamble', '', 'matlabpoolN', 1, 'globalVars', {{}}, 'fHandle', @empty, 'numOutputs', 0);
  % resourceParam = struct('mem', 1, 'hh', 1, 'numJobs', 1, 'ppn', 1, 'nodes', 1, 'logDir', '/home/eecs/sgupta/Projects/pbs2/logs', 'queue', 'zen', 'notif', true, 'username', 'sgupta');
  
  jobParam = pLaunch.jobParam;
  eval(sprintf('jobParam.fHandle = @%s;', funNm));
  resourceParam = pLaunch.resourceParam;

  [jobId, jobDir] = jobParallel(funNm, resourceParam, jobParam, jobs);
  fprintf('%s, %s\n', jobId, jobDir);
  
  while(1)
    [allDone, anyError] = collectJob(jobDir);
    if(allDone)
      [allDone, anyError, jobDone, jobOutput] = collectJob(jobDir);
      res = jobOutput;
      out = ~anyError;
      break;
    end
    fprintf('!!');
    pause(120);
  end
end
