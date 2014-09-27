function str = serializeStruct(s, names)

% AUTORIGHTS
% ---------------------------------------------------------
% Copyright (c) 2014, Saurabh Gupta
% 
% This file is part of the Utils code and is available 
% under the terms of the Simplified BSD License provided in 
% LICENSE. Please retain this notice and LICENSE if you use 
% this file (or any portion of it) in your project.
% ---------------------------------------------------------

  if(~exist('names', 'var'))
    names = fieldnames(s);
  end
  
  i = 1;
  str = sprintf('%s_%s', names{i}, num2str(s.(names{i})));
  for i = 2:length(names),
    str = sprintf('%s,%s_%s', str, names{i}, num2str(s.(names{i})));
  end
end
