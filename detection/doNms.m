function [boxes, sc, pick] = doNms(boxes, sc, overlap, overlapFn)
% Non-maximum suppression.
% function pick = doNms(boxes, sc, overlap, overlapFn)
% 
%   Greedily select high-scoring detections and skip detections that are 
%   significantly covered by a previously selected detection.
%
% Return value
%   pick      Indices of locally maximal detections
%
% Arguments
%   boxes       Detection bounding boxes (see pascal_test.m)
%   sc          Score for the boxes
%   overlap     Overlap threshold for suppression
%   overlapFn   Function handle to compute the overlap between the boxes

if(length(boxes) == 0)
  pick = [];
else
  iu = overlapFn(boxes);
  [vals, I] = sort(sc);
  pick = [];
  while ~isempty(I)
    last = length(I);
    i = I(last);
    pick = [pick; i];
    suppress = [last];
    for pos = 1:last-1
      j = I(pos);
      o = iu(i, j);
      if o > overlap
        suppress = [suppress; pos];
      end
    end
    I(suppress) = [];
  end
  boxes = boxes(pick);
  sc = sc(pick);
end
