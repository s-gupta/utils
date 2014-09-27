function treeData = matrixToTreeData(data)
% function treeData = matrixToTreeData(data)
%   Converts a NxF matrix (single format) into structure used by forestTrainFn.m
% INPUTS
%  data - [NxF] N (length F) feature vectors
% OUTPUTS
%  treeData
%   .getNumPoints - called as treeData.getNumPoints(treeData);
%   .getFeatureDim - called as treeData.getFeatureDim(treeData);
%   .samplePoints - called as treeData.samplePoints(treeData, dids);
%   .getMatrixValues - called as treeData.getMatrixValues(treeData, dids, fids);

  if(~isa(data, 'single')), data = single(data); end
  treeData.data = data;
  treeData.activeDataInds = 1:size(data, 1);
  treeData.getNumPoints = @(x) length(x.activeDataInds);
  treeData.getFeatureDim = @(x) size(data, 2);
  treeData.samplePoints = @(x, dids) samplePoints(x, dids);
  treeData.getMatrixValues = @(x, dids, fids) x.data(x.activeDataInds(dids), fids);
end

function treeData = samplePoints(treeData, dids)
  treeData.activeDataInds = treeData.activeDataInds(dids);
end
