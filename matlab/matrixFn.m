function B = matrixFn(A, varargin)
% function B = matrixFn(A, varargin)

% AUTORIGHTS
% ---------------------------------------------------------
% Copyright (c) 2014, Saurabh Gupta
% 
% This file is part of the RGBD utils code and is available 
% under the terms of the Simplified BSD License provided in 
% LICENSE. Please retain this notice and LICENSE if you use 
% this file (or any portion of it) in your project.
% ---------------------------------------------------------

  assert(ndims(A) == length(varargin)); 
  str = mat2str(varargin{1});
  for i = 2:length(varargin),
    str = sprintf('%s, %s', str, mat2str(varargin{i}));
  end
  str = sprintf('B = A(%s);', str);
  eval(str);
end
