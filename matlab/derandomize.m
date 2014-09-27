function st = derandomize(st, seed)
% function st = derandomize(st, seed)
% Usage:
%   st = derandomize([], seed);   % To derandomize
%   derandomize(st);              % To reset state to past derandomization call

% AUTORIGHTS
% ---------------------------------------------------------
% Copyright (c) 2014, Saurabh Gupta
% 
% This file is part of the Utils code and is available 
% under the terms of the Simplified BSD License provided in 
% LICENSE. Please retain this notice and LICENSE if you use 
% this file (or any portion of it) in your project.
% ---------------------------------------------------------


	if(isempty(st))
		st = RandStream.getGlobalStream();
		s = RandStream('mt19937ar','Seed',seed);
		RandStream.setGlobalStream(s);
	else
		RandStream.setGlobalStream(st);
	end
end
