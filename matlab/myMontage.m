function I = myMontage(IMG)
% function I = myMontage(IMG)
% Input: IMG is a N x N x 3 x k set of images and this function simply tiles them

% AUTORIGHTS
% ---------------------------------------------------------
% Copyright (c) 2014, Saurabh Gupta
% 
% This file is part of the RGBD utils code and is available 
% under the terms of the Simplified BSD License provided in 
% LICENSE. Please retain this notice and LICENSE if you use 
% this file (or any portion of it) in your project.
% ---------------------------------------------------------

	k = size(IMG,4);
	kk = ceil(sqrt(k));
	if(kk*kk > k)
		IMG(:,:,:,kk*kk) = 0;
	end
	for i = 1:kk*kk,
		I{ceil((i)/kk), mod(i-1, kk)+1} = IMG(:,:,:,i);
	end
	I = cell2mat(I);
end
