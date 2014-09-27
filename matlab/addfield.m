function s = addfield(s, field_name, field_val)
% function s = addfield(s, field_name, field_val)
% Add field_name to all structures in the structure with a value of field_val

% AUTORIGHTS
% ---------------------------------------------------------
% Copyright (c) 2014, Saurabh Gupta
% 
% This file is part of the Utils code and is available 
% under the terms of the Simplified BSD License provided in 
% LICENSE. Please retain this notice and LICENSE if you use 
% this file (or any portion of it) in your project.
% ---------------------------------------------------------

  tmp = {};
  for i = 1:length(s),
    tmp{i} = field_val;
  end
  [s(:).(field_name)] = deal(tmp{:});
end
