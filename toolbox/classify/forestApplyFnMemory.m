function [hs, ps, leaf_ids] = forestApplyFnMemory( treeData, forest, maxDepth, minCount, best, precompute )
% Apply learned forest classifier.
%
% USAGE
%  [hs,ps] = forestApplyFnMemory( treeData, forest, [maxDepth], [minCount], [best], [precompute] )
%
% INPUTS
%  treeData - structure as generated from matrixToTreeData.m
%  forest   - learned forest classification model
%  maxDepth - [] maximum depth of tree
%  minCount - [] minimum number of data points to allow split
%  best     - [0] if true use single best prediction per tree
%  precompute [0] if true precomputes features and uses mex code to evaluate the tree,
%                 if false computes features on the fly and evaluates tree in matlab
%
% OUTPUTS
%  hs       - [Nx1] predicted output labels
%  ps       - [NxH] predicted output label probabilities
%  leaf_ids   - [NxnTrees] the leaf node at which the point ends up at in each tree
%
% EXAMPLE
%
% See also forestTrain
%
% Piotr's Image&Video Toolbox      Version 3.24
% Copyright 2013 Piotr Dollar.  [pdollar-at-caltech.edu]
% Please email me if you find bugs, or have suggestions or questions!
% Licensed under the Simplified BSD License [see external/bsd.txt]

if(nargin<3 || isempty(maxDepth)), maxDepth=0; end
if(nargin<4 || isempty(minCount)), minCount=0; end
if(nargin<5 || isempty(best)), best=0; end
if(nargin<6 || isempty(precompute)), precompute=0; end

%assert(isa(data,'single')); 

M=length(forest);
H=size(forest(1).distr,2); 

%N=size(data,1);
N = treeData.getNumPoints(treeData);
F = treeData.getFeatureDim(treeData);

if(best), hs=zeros(N,M); else ps=zeros(N,H); end
discr=iscell(forest(1).hs); if(discr), best=1; hs=cell(N,M); end
for i=1:M, 
  
  tree=forest(i);
  if(maxDepth>0), tree.child(tree.depth>=maxDepth) = 0; end
  if(minCount>0), tree.child(tree.count<=minCount) = 0; end
 
  %ids = forestInds(data, tree.thrs, tree.fids, tree.child, 4);
  
  if(precompute)
    fids = tree.fids+1;  %% fids is 0 based indexing!
    fidsUniq = unique(fids(fids > 0));
    [~, locFidsUnique] = ismember(fids, fidsUniq);
    dataAll = single(treeData.getMatrixValues(treeData, 1:N, double(fidsUniq)));
    locFidsUnique = uint32(locFidsUnique);
    assert(max(locFidsUnique) <= size(dataAll, 2), 'Something wrong with taking unique features... \n');
    ids = forestInds(dataAll, tree.thrs, locFidsUnique-1, tree.child, 4);
  else
    inds = forestIndsMatlab(treeData, tree.thrs, tree.fids+1, tree.child);
    ids = inds;
  end
  leaf_ids(:,i) = ids;
  if(best), hs(:,i)=tree.hs(ids); else ps=ps+tree.distr(ids,:); end
end

if(discr), ps=[]; return; end % output is actually {NxM} in this case
if(best), ps=histc(hs',1:H)'; end; [~,hs]=max(ps,[],2); ps=ps/M;
end
