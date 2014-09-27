function p = myNdgrid(name, val)
% function p = myNdgrid(name,val)

% AUTORIGHTS

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
