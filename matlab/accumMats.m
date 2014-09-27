function [v, fileName, fileNameFull] = accumMats(fileNameFn, varReturn, varLoad)
% function [v fileName fileNameFull] = accumMats(fileNameFn, varReturn, varLoad)
%   fn is either 
%     -- a regular expression to generate filenames on passing to dir.
% 		-- a struct with fileds fn and args, which generates filenames as fn(ind(i)).
%		str is a cell array of what variables you want returned...
%   var_load is a cell array of strings of the variables that you need to load to evaluate the expression in str

% AUTORIGHTS
% ---------------------------------------------------------
% Copyright (c) 2014, Saurabh Gupta
% 
% This file is part of the RGBD utils code and is available 
% under the terms of the Simplified BSD License provided in 
% LICENSE. Please retain this notice and LICENSE if you use 
% this file (or any portion of it) in your project.
% ---------------------------------------------------------

  fileName = {};
  fileNameFull = {};

  if(isstr(fileNameFn))
    regex = fileNameFn;
    clear fileNameFn;
    dirData = dir(regex);
    dirName = fileparts(regex);
    for i = 1:length(dirData),
      fName{i} = fullfile(dirName, dirData(i).name);
      fileName{i} = dirData(i).name;
    end
    fileNameFn.fn = @(x) fName{x};
    fileNameFn.args = 1:length(dirData);
  end

  for i = 1:length(fileNameFn.args)
    fileNameFull{i} = fileNameFn.fn(fileNameFn.args(i));
	  [aa, aaa, aaaa] = fileparts(fileNameFull{i});
    fprintf('%d - %s ', i, aaa);
    fileName{i} = sprintf('%s%s', aaa, aaaa); 
	  try
      if(exist('varLoad', 'var'))      
		    dt = load(fileNameFull{i}, varLoad{:});
      else
		    dt = load(fileNameFull{i});
      end

		  for j = 1:length(varReturn),
			  try
				  eval(sprintf('v{%d}{%d} = %s;', j, i, varReturn{j}));
			  catch ee
          prettyexception(ee);
          v{j}{i} = NaN;
			  end
		  end
		  fprintf('. \n');
	  catch ee
      prettyexception(ee)
      v{j}{i} = NaN;
	  end
  end
end
