function x = iif(varargin)
% function x = iif(varargin)
%   x = varargin{2 * find([varargin{1:2:end}], 1, 'first')};

% AUTORIGHTS
% ---------------------------------------------------------
% Copyright (c) 2014, Saurabh Gupta
% 
% This file is part of the RGBD utils code and is available 
% under the terms of the Simplified BSD License provided in 
% LICENSE. Please retain this notice and LICENSE if you use 
% this file (or any portion of it) in your project.
% ---------------------------------------------------------

  x = varargin{2 * find([varargin{1:2:end}], 1, 'first')};
end
