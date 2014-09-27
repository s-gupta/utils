function runJob(jobDir, id, numJobs)
% jobParam
% .preamble
% .matlabpoolN
% .globalVars
% .fHandle
% .numOutputs

% AUTORIGHTS
% ---------------------------------------------------------
% Copyright (c) 2014, Saurabh Gupta
% 
% This file is part of the RGBD utils code and is available 
% under the terms of the Simplified BSD License provided in 
% LICENSE. Please retain this notice and LICENSE if you use 
% this file (or any portion of it) in your project.
% ---------------------------------------------------------

  dt = load(fullfile(jobDir, 'params.mat'));
  jobParam = dt.jobParam;
  
  dt = load(fullfile(jobDir, 'input.mat'));
  jobInput = dt.jobInput;

  maxNumCompThreads(jobParam.numThreads);
  
  %% Open the matlab pool if needed
  if(jobParam.matlabpoolN > 1)
    pbsOpenPool(jobParam.matlabpoolN);
  end
  
  %% Run the preamble here
  eval(jobParam.preamble);

  
  %% Set up the global variables
  for i = 1:2:length(jobParam.globalVars),
    eval(sprintf('global %s; %s = jobParam.globalVars{%d}', jobParam.globalVars{i}, jobParam.globalVars{i}, i+1));
  end

  ind = id:numJobs:length(jobInput);
  jobMine = false(1, length(jobInput));
  jobDone = false(1, length(jobInput));
  jobOutput = cell(1, length(jobInput));
  jobException = cell(1, length(jobInput));
  jobError = false(1, length(jobInput));

  for i = 1:length(ind),
    %% Run the function
    jobMine(ind(i)) = true;
    if(jobParam.numOutputs > 0)
      str = getOutStr(jobParam.numOutputs, 'out');
      str = sprintf('%s = feval(jobParam.fHandle, jobInput{%d}{:});', str, ind(i));
    else
      str = sprintf('feval(jobParam.fHandle, jobInput{%d}{:});', ind(i));
    end
    fprintf('Running %s.\n', str);

    try 
      eval(str);
      if(jobParam.numOutputs > 0)
        jobOutput{ind(i)} = out;
      else
        jobOutput{ind(i)} = {};
      end

      jobDone(ind(i)) = 1;
      clear out;
    catch ee
      jobOutput{ind(i)} = {};
      jobDone(ind(i)) = 0;
      jobException{ind(i)} = ee;
      jobError(ind(i)) = 1;
      prettyexception(ee);
      fprintf('Error while running %s.\n', str);
    end
  end

  %% Save the outputs in the file, save the 
  fileName = fullfile(jobDir, sprintf('output-%03d.mat', id));
  save(fileName, 'jobOutput', 'jobDone', 'jobMine', 'jobError', 'jobException');

  %% Close the matlab pool
  pbsClosePool();
end

function str = getOutStr(n, varName)
  str = sprintf('%s{%d} ', varName, 1);
  for i = 2:n, 
    str = sprintf('%s, %s{%d} ', str, varName, i);
  end
  str = sprintf('[%s]', str);
end


function pbsOpenPool(s)
	warning('off', 'all');
	mps = matlabpool('size');
	if(mps == s)
		return;
	elseif(mps > 0)
		pbsClosePool();
	end
	if s > 0
		while true
			try
				matlabpool('open', s);
				break;
			catch e
				pT = randi(30);
				fprintf('Ugg! Something bad happened. Trying again in %d seconds...\n', pT);
				pause(pT);
			end
		end
	end
	warning('on', 'all');
end

function s = pbsClosePool()
  try
    s = matlabpool('size');
    if s > 0
      matlabpool('close');
    end
  catch
    s = 0;
  end
end

