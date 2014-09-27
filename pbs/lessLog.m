function lessLog(jobDir, id)
% function lessLog(jobDir, id)
% lessLog(jobDir, 1);

% AUTORIGHTS
% ---------------------------------------------------------
% Copyright (c) 2014, Saurabh Gupta
% 
% This file is part of the RGBD utils code and is available 
% under the terms of the Simplified BSD License provided in 
% LICENSE. Please retain this notice and LICENSE if you use 
% this file (or any portion of it) in your project.
% ---------------------------------------------------------

  if(nargin() < 2), id = 1; end
  unix(sprintf('tail -f %s/log.log-%03d', jobDir, id));
end
