function p = myNdgrid(name, val)
% function p = myNdgrid(name,val)

% AUTORIGHTS
% ---------------------------------------------------------
% Copyright (c) 2014, Saurabh Gupta
% 
% This file is part of the Utils code and is available 
% under the terms of the Simplified BSD License provided in 
% LICENSE. Please retain this notice and LICENSE if you use 
% this file (or any portion of it) in your project.
% ---------------------------------------------------------

  nVar= length(name);
  N = 1;
  s = zeros(1,nVar);
  for i = 1:nVar,
    s(i) = length(val{i});
  end
  N = prod(s);

  %nd grid
  inp = [num2str(1:nVar-1,'val{%d},') num2str(nVar,'val{%d}')];
  outp = [num2str(1:nVar-1,'out{%d},') num2str(nVar,'out{%d}')];
  str = ['[' outp '] = ndgrid(' inp ');'];
  eval(str);
  %Put into array
  for i = 1:N,
    for j = 1:nVar,
      p(i).(name{j}) = out{j}(i);
    end
  end
end
