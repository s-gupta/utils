function pick = nmsOverlap(iu, sc, overlapThresh)
% Non-maximum suppression.
% function pick = nmsOverlap(iu, sc, overlapThresh)
% 
%   Greedily select high-scoring detections and skip detections that are 
%   significantly covered by a previously selected detection. IU is the 
%   matrix that defines overlap between boxes
%
% Return value
%   pick      Indices of locally maximal detections
%
% Arguments
%   iu              Symmetric matrix with overlap between boxes
%   overlapThresh   Overlap threshold for suppression
%   sc              Score for the detection

if(size(iu,1) == 0)
  pick = [];
else
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
      if o > overlapThresh
        suppress = [suppress; pos];
      end
    end
    I(suppress) = [];
  end
end
