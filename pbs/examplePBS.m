
% AUTORIGHTS
% ---------------------------------------------------------
% Copyright (c) 2014, Saurabh Gupta
% 
% This file is part of the RGBD utils code and is available 
% under the terms of the Simplified BSD License provided in 
% LICENSE. Please retain this notice and LICENSE if you use 
% this file (or any portion of it) in your project.
% ---------------------------------------------------------

% Everyone gotta have one!
username = 'sgupta';

% You need to have your ssh keys set up for this to work. 
% It ssh's from the current node to the headNode to launch jobs
% Check out sshkey-gen to generate keys.
headNode = 'psi';

% The script launches in the directory codeDir, 
% and hopefully there is a startup.m in
% that directory which does all the path set up.
codeDir = pwd();

% Directory which will store all the log files, 
% input and output structures parameters for the job etc
logDir = '/work4/sgupta/pbsBatchDir/';


jobParam = struct('numThreads', 1, 'codeDir', pwd(), 'preamble', '', 'matlabpoolN', 1, 'globalVars', {{}}, 'fHandle', @sum, 'numOutputs', 1);
resourceParam = struct('mem', 2, 'hh', 5, 'numJobs', 30, 'ppn', 1, 'nodes', 1, 'logDir', logDir, 'queue', 'psi', 'notif', false, 'username', username, 'headNode', headNode);

% Name that you will be able to see on psi/zen for your job, on doing 
% psi: qstat -an1
% zen: qstat -an1t, showq
jobName = 'sum';

% Arguments that you want to run the function on
% jobInput{1}{:} is the set of arguments for the first function that you want to run, and so on
jobInput{1}{1} = ones(100,100); jobInput{1}{2} = 1;
jobInput{2}{1} = 10*ones(100,100); jobInput{2}{2} = 1;

% Actually generates the file and launches the jobs
[jobId jobDir] = jobParallel(jobName, resourceParam, jobParam, jobInput);

% Use this to collect the jobs. 
%   allDone is a boolean variable indicating how many jobs got completed
%   jobOutput contains the arguments that you requested.
%   The while waits for the jobs to finish
while(~collectJob(jobDir)), pause(60); end
[allDone, anyError, jobDone, jobOutput] = collectJob(jobDir);
