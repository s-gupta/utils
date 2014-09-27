function ind = forestIndsMatlab(treeData, thrs, fids, child)
% function ind = forestIndsMatlab(treeData, thrs, fids, child)
% fids is 1-indexed, child is also 1-indexed

  N = treeData.getNumPoints(treeData);
  F = treeData.getFeatureDim(treeData);
  ind = zeros(N,1);
  id{1} = 1:N;
  for i = 1:length(child),
    % We want to process the ith child
    
    % Check if no data reached here
    if(length(id) < i || numel(id{i}) == 0), continue; end

    % Check if already at leaf node
    if(child(i) == 0), ind(id{i}) = i; continue; end

    % Compute the node feature and do the computation
    f = single(treeData.getMatrixValues(treeData, id{i}, double(fids(i))));
    id{child(i)} = id{i}(f < thrs(i));
    id{child(i)+1} = id{i}(f >= thrs(i));
    id{i} = [];
  end
end
