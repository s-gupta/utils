function [tp, fp, sc, numInst, dupDet, instId, ov] = instBenchImg(dt, gt, bOpts, overlap)
% Assume that dt are sorted by the score
% for each detection returns whether it is a tn, fn, tp, fp

% AUTORIGHTS
% ---------------------------------------------------------
% Copyright (c) 2014, Saurabh Gupta
% 
% This file is part of the Utils code and is available 
% under the terms of the Simplified BSD License provided in 
% LICENSE. Please retain this notice and LICENSE if you use 
% this file (or any portion of it) in your project.
% ---------------------------------------------------------

  nDt = numel(dt.sc);
  nGt = numel(gt.diff);
  numInst = numel(gt.diff);

  if(~exist('overlap', 'var'))
    overlap = bOpts.overlapFn(dt, gt, bOpts.overlapParam);
  end

  assert(issorted(-dt.sc), 'Scores are not sorted.\n');
  sc = dt.sc;

  gt.det = false(nGt, 1);

  tp = false(nDt, 1);
  fp = false(nDt, 1);
  dupDet = false(nDt, 1);
  instId = zeros(nDt, 1);
  ov = zeros(nDt,1);

  % Walk through the detections in decreasing score 
  % and assign tp, fp, fn, tn labels
  for i = 1:nDt,
    % assign detection to ground truth object if any
    [maxOverlap, maxInd] = max(overlap(i, :));
    if(nGt > 0),
      instId(i) = maxInd;
      ov(i) = maxOverlap;
    else
      maxOverlap;
    end
    
    % assign detection as true positive/don't care/false positive
    if(maxOverlap >= bOpts.minoverlap)
      if(~gt.diff(maxInd))
        if(~gt.det(maxInd))
          % true positive
          tp(i) = 1;
          gt.det(maxInd) = true;
        else
          % false positive (multiple detection)
          fp(i) = 1;
          dupDet(i) = 1;
        end
      end
    else
      % false positive
      fp(i)=1;
    end
  end
end
