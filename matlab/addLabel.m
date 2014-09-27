function im = addLabel(im, str, h)
  % function im = addLabel(im, str, h)

% AUTORIGHTS
% ---------------------------------------------------------
% Copyright (c) 2014, Saurabh Gupta
% 
% This file is part of the RGBD utils code and is available 
% under the terms of the Simplified BSD License provided in 
% LICENSE. Please retain this notice and LICENSE if you use 
% this file (or any portion of it) in your project.
% ---------------------------------------------------------

  tt = char2img(str, h);
  tt = double(tt{1});
  im = im2double(im);
  tt = repmat(tt, [1 1 size(im,3)]);
  tt(:,end:size(im,2),:) = 1;
  tt = tt(:, 1:size(im,2),:);
  im = cat(1, im, tt); 
end
