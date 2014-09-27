function [out ids] = generateSweep(init_pt, varargin)
% function [out ids] = generateSweep(init_pt, varargin)

% AUTORIGHTS
% ---------------------------------------------------------
% Copyright (c) 2014, Saurabh Gupta
% 
% This file is part of the Utils code and is available 
% under the terms of the Simplified BSD License provided in 
% LICENSE. Please retain this notice and LICENSE if you use 
% this file (or any portion of it) in your project.
% ---------------------------------------------------------

  assert(isequal(length(varargin), 2*length(init_pt)));
  cnt = 0;
  for i = 1:length(init_pt),
    for j = 1:length(varargin{2*i}),
      if(j == init_pt(i))
        continue;
      else
        cnt = cnt+1;
        for k = 1:length(init_pt),
          out{cnt}{2*k-1} = varargin{2*k-1};
          if(k == i)
            out{cnt}{2*k} = varargin{2*k}{j};
            ids(cnt, k) = j;
          else
            out{cnt}{2*k} = varargin{2*k}{init_pt(k)};
            ids(cnt, k) = init_pt(k);
          end
        end
      end
    end
  end
  cnt = cnt+1;
  for k = 1:length(init_pt),
    out{cnt}{2*k-1} = varargin{2*k-1};
    out{cnt}{2*k} = varargin{2*k}{init_pt(k)};
    ids(cnt, k) = init_pt(k);
  end
end
