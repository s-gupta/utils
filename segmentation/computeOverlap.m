function [iu inter instArea regArea] = computeOverlap(sp, sp2reg, instMasks, typ)
% function [iu inter instArea regArea] = computeOverlap(sp, sp2reg, instMasks, typ)
%   Compute the overlap of all ground truth regions with the regions

% AUTORIGHTS
% ---------------------------------------------------------
% Copyright (c) 2014, Saurabh Gupta
% 
% This file is part of the Utils code and is available 
% under the terms of the Simplified BSD License provided in 
% LICENSE. Please retain this notice and LICENSE if you use 
% this file (or any portion of it) in your project.
% ---------------------------------------------------------

  nInst = size(instMasks, 3);
  nSP = size(sp2reg, 1); nR = size(sp2reg, 2);

  overlapSP = zeros(nInst, nSP);
  instArea = zeros(nInst, 1);
  regArea = zeros(1, nR);

  switch typ
    case 'region',
      spArea = accumarray(sp(:), 1);
      spArea = linIt(spArea);
      for i = 1:nInst,
        overlapSP(i,:) = accumarray(sp(:), double(linIt(instMasks(:,:,i))));
        instArea(i,1) = sum(double(linIt(instMasks(:,:,i))));
      end
      overlapRegion = overlapSP*sp2reg;
      regArea = spArea'*sp2reg;
      iu = overlapRegion./max(eps, bsxfun(@plus, regArea, instArea)-overlapRegion);
      inter = overlapRegion;

    case 'bbox',
      % Compute the boxes on the gtInst and the regions!
      boxInst = regionToBox([], instMasks, [], 'masks');
      boxReg = regionToBox([], [], struct('sp2reg', sp2reg, 'sp', sp), 'sp2reg');

      [iu inter instArea regArea] = bboxOverlap(boxInst, boxReg);
  end
end
