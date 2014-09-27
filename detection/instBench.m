function [prec, rec, ap, thresh] = instBench(dt, gt, bOpts, tp, fp, sc, numInst)
% function [prec, rec, ap, thresh] = instBench(dt, gt, bOpts, tp, fp, sc, numInst)
% dt  - a struct array with a struct for each image and with following fields
%   .boxInfo - info that will be used to cpmpute the overlap with ground truths, a struct array
%   .sc - score 
% gt
%   .boxInfo - info used to compute the overlap,  a struct array
%   .diff - a logical array of size nGtx1, saying if the instance is hard or not
% bOpt
%   .minoverlap - the minimum overlap to call it a true positive
%   .overlapFn - Function to compute the overlap between ground truth and detection boxes, called like overlapFn(dt{i}, gt{i}, overlapParam);
%   .overlapParam - Parameters to compute the overlap, will be passed to the ovelapFn
%     .ovType - singleThresh, searchThresh, softIU
%     .perDetectionThreshold - use a per detection threshold for computing the overlap with the ground truth mask
%     .singleThreshold - use a single threshold to find the overlap with the ground truth mask
%     .softIU - compute a soft I/U for computing the overlap with the ground truth objects
% [tp], [fp], [sc], [numInst] 
%     Optional arguments, in case the instBenchImg is being called outside of this function
% bOpts.overlapFn = @(x,y,z) bboxOverlap(cat(1, x.boxInfo(:).bbox), cat(1, y.boxInfo(:).bbox)); 
% bOpts.minoverlap = 0.5;
% bOpts.overlapParam = [];
% [prec, rec, ap, thresh] = instBench(dt, gt, bOpts, tp, fp, sc, numInst)

% AUTORIGHTS
% ---------------------------------------------------------
% Copyright (c) 2014, Saurabh Gupta
% 
% This file is part of the Utils code and is available 
% under the terms of the Simplified BSD License provided in 
% LICENSE. Please retain this notice and LICENSE if you use 
% this file (or any portion of it) in your project.
% ---------------------------------------------------------

  if(nargin == 3)
    %% We do not have the tp, fp, sc, and numInst, so compute them from the structures gt, and out
    for i = 1:length(gt),
      %% Sort dt by the score
      [gr, ind] = sort(dt(i).sc, 'descend');
      dtI = struct('boxInfo', dt(i).boxInfo(ind), 'sc', dt(i).sc(ind));
      [tp{i} fp{i} sc{i} numInst(i)] = instBenchImg(dtI, gt(i), bOpts);
    end
  end

  tp = cat(1, tp{:});
  fp = cat(1, fp{:});
  sc = cat(1, sc{:});

  catAll = cat(2, tp, fp, sc);
  catAll = sortrows(catAll, -3);
  tp = cumsum(catAll(:,1), 1);
  fp = cumsum(catAll(:,2), 1);
  thresh = catAll(:,3);
  npos = sum(numInst);

  % Compute precision/recall
  rec = tp./npos;
  prec = tp./(fp+tp);

  ap = VOCap(rec, prec);
end
