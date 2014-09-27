function parsave(fileName, varargin)
% function parsave(fileName, 'a', a, 'b', b, ...)

% AUTORIGHTS
% ---------------------------------------------------------
% Copyright (c) 2014, Saurabh Gupta
% 
% This file is part of the Utils code and is available 
% under the terms of the Simplified BSD License provided in 
% LICENSE. Please retain this notice and LICENSE if you use 
% this file (or any portion of it) in your project.
% ---------------------------------------------------------

	assert(mod(length(varargin), 2) == 0, 'Improper number of arguments...');
	for i = 1:length(varargin)/2,
		varName = varargin{2*i-1};
		varVal = varargin{2*i};
		assert(isstr(varName), 'Variable name not string');
		eval(sprintf('dt.%s = varVal;', varName));
	end
	save(fileName, '-STRUCT', 'dt');
end
