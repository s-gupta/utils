function [allDone, anyError, jobDone, jobOutput, jobException] = collectJob(jobDir)
% function [allDone, anyError, jobDone, jobOutput, jobException] = collectJob(jobDir)

% AUTORIGHTS
% ---------------------------------------------------------
% Copyright (c) 2014, Saurabh Gupta
% 
% This file is part of the Utils code and is available 
% under the terms of the Simplified BSD License provided in 
% LICENSE. Please retain this notice and LICENSE if you use 
% this file (or any portion of it) in your project.
% ---------------------------------------------------------

  paramFile = fullfile(jobDir, 'params.mat');
  inputFile = fullfile(jobDir, 'input.mat');

  load(paramFile);
  load(inputFile);
  
  jobDone = false(1, length(jobInput));
  jobOutput = cell(1, length(jobInput));
  jobException = cell(1, length(jobInput));
  jobError = false(1, length(jobInput));

  onlyCheck = (nargout() <= 2);
  
  for i = 1:resourceParam.numJobs,
    try
      if(onlyCheck)
        dt = load(fullfile(jobDir, sprintf('output-%03d.mat', i)), 'jobDone', 'jobMine', 'jobError');
      else
        dt = load(fullfile(jobDir, sprintf('output-%03d.mat', i)));
      end
      ind = find(dt.jobMine);
      for j = 1:length(ind),
        jobDone(ind(j)) = dt.jobDone(ind(j));
        jobError(ind(j)) = dt.jobError(ind(j));
        if(~onlyCheck)
          jobOutput{ind(j)} = dt.jobOutput(ind(j));
          jobException{ind(j)} = dt.jobException(ind(j));
        end
      end
      fprintf('.');
    catch ee
      % prettyexception(ee);
      fprintf('*');
    end
  end
  allDone = all(jobDone);
  anyError = any(jobError);

  progress = round(100*[mean(double(jobDone)), mean(double(anyError))]);

  fprintf('(%03d / %03d / %03d) ', progress(1), progress(2), 100);
end
