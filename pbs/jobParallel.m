function [jobId jobDir] = jobParallel(jobName, resourceParam, jobParam, jobInput)
  % function [jobId jobDir] = jobParallel(jobName, resourceParam, jobParam, jobInput)
  % resourceParam
  %   .mem      - Memory in GB
  %   .hh       - The number of hours
  %   .numJobs  - Number of jobs to launch
  %   .ppn      - Processors per node
  %   .nodes    - The number of nodes
  %   .logDir   - The directory where to create the logs
  %   .queue
  %   .notif
  %   .username 
  %   .headNode 
  % jobParam
  %   .numThreads
  %   .codeDir
  %   .preamble
  %   .matlabpoolN
  %   .globalVars
  %   .fHandle
  %   .numOutputs
  % jobInput
  %jobParam = struct('numThreads', 1, 'codeDir', pwd(), 'preamble', '', 'matlabpoolN', 1, 'globalVars', {{}}, 'fHandle', @empty, 'numOutputs', 1);
  %resourceParam = struct('mem', 1, 'hh', 5, 'numJobs', 30, 'ppn', 1, 'nodes', 1, 'logDir', '/work4/sgupta/pbsBatchDir/', 'queue', 'psi', 'notif', false, 'username', 'sgupta', 'headNode', 'psi');
  %[jobId jobDir] = jobParallel(jobName, resourceParam, jobParam, jobInput)


% AUTORIGHTS
% ---------------------------------------------------------
% Copyright (c) 2014, Saurabh Gupta
% 
% This file is part of the RGBD utils code and is available 
% under the terms of the Simplified BSD License provided in 
% LICENSE. Please retain this notice and LICENSE if you use 
% this file (or any portion of it) in your project.
% ---------------------------------------------------------

  fnName = 'runJob';
  fnPath = mfilename('fullpath'); 
  fnPath = fileparts(fnPath);

  if(resourceParam.numJobs == -1), resourceParam.numJobs = length(jobInput); end
  resourceParam.numJobs = min(resourceParam.numJobs, length(jobInput));

  %% Make the directory for the job, basically the output files 
  date = now();
  dirName = sprintf('%04d-%02d-%02d-%02d:%02d:%02d-%s', year(date), month(date), day(date), hour(date), minute(date), round(second(date)), jobName);
  dirName = fullfile(resourceParam.logDir, dirName);
  if(exist(dirName, 'dir')), fprintf('%s already exists, will be removed befpre proceeding! ', dirName); keyboard; end
  if(exist(dirName, 'dir')), rmdir(dirName, 's'); end
  mkdir(dirName);
  
  jobDir = dirName;
  paramFile = fullfile(jobDir, 'params.mat');
  inputFile = fullfile(jobDir, 'input.mat');
  
  save(paramFile, 'jobParam', 'resourceParam');
  
  %% Write the job arguments in another file
  save(inputFile, 'jobInput');

  %% Call pbsRunFunction to generate the shell script
  jobId = simplePBS(jobName, dirName, jobParam.codeDir, resourceParam.nodes, resourceParam.ppn, resourceParam.mem, resourceParam.hh, dirName, resourceParam.notif, resourceParam.username, resourceParam.headNode, resourceParam.queue, resourceParam.numJobs, fnPath, fnName);
end
