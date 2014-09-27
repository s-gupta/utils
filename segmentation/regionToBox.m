function box = regionToBox(label, masks, sp2reg, typ)
% function box = regionToBox(label, masks, sp2reg, typ)
% box is Nx4 matrix with [xmin ymin xmax ymax];

% AUTORIGHTS
% ---------------------------------------------------------
% Copyright (c) 2014, Saurabh Gupta
% 
% This file is part of the Utils code and is available 
% under the terms of the Simplified BSD License provided in 
% LICENSE. Please retain this notice and LICENSE if you use 
% this file (or any portion of it) in your project.
% ---------------------------------------------------------

  
  switch typ,
    case 'label',
      inst = label;
      % Compute the boxes on the gtInst and the regions!
      x = repmat([1:size(inst,2)], size(inst,1), 1);
      y = repmat([1:size(inst,1)]', 1, size(inst,2));
      xmin = accumarray(inst(inst>0), x(inst > 0), [max(inst(:)) 1], @min, inf);
      xmax = accumarray(inst(inst>0), x(inst > 0), [max(inst(:)) 1], @max, -inf);
      ymin = accumarray(inst(inst>0), y(inst > 0), [max(inst(:)) 1], @min, inf);
      ymax = accumarray(inst(inst>0), y(inst > 0), [max(inst(:)) 1], @max, -inf);
      box = [xmin, ymin, xmax, ymax];
    
    case 'masks',
      for i = 1:size(masks,3),
        box(i,:) = regionToBox(double(masks(:,:,i)), [], [], 'label');
      end

    case 'sp2reg',
      sp = sp2reg.sp;
      sp2reg = sp2reg.sp2reg;

      % Compute the boxes on the regions!
      boxSP = regionToBox(sp, [], [], 'label');
      id = [inf, inf, -inf, -inf];
      boxSP(size(boxSP,1)+1:size(sp2reg, 1), :) = repmat(id, size(sp2reg,1)-size(boxSP,1), 1);
      xmin = bsxfun(@times, boxSP(:,1), double(sp2reg)); xmin(sp2reg == 0) = Inf; xmin = min(xmin, [], 1)';
      xmax = bsxfun(@times, boxSP(:,3), double(sp2reg)); xmax(sp2reg == 0) = -Inf; xmax = max(xmax, [], 1)';
      ymin = bsxfun(@times, boxSP(:,2), double(sp2reg)); ymin(sp2reg == 0) = Inf; ymin = min(ymin, [], 1)';
      ymax = bsxfun(@times, boxSP(:,4), double(sp2reg)); ymax(sp2reg == 0) = -Inf; ymax = max(ymax, [], 1)';
      box = [xmin, ymin, xmax, ymax];
      ind = find(isinf(box(:,1))); box(ind, :) = repmat([1 1 1 1], length(ind), 1);
  end
end
