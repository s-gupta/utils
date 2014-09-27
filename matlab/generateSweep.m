function [out ids] = generateSweep(init_pt, varargin)
% function [out ids] = generateSweep(init_pt, varargin)

% AUTORIGHTS

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
