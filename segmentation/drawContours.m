function J = drawContours(Iin,c)
%function J = drawContours(I,c)
%	I is the image, c is the contour to draw on I with value between 0 and 1.

% AUTORIGHTS
% ---------------------------------------------------------
% Copyright (c) 2014, Saurabh Gupta
% 
% This file is part of the Utils code and is available 
% under the terms of the Simplified BSD License provided in 
% LICENSE. Please retain this notice and LICENSE if you use 
% this file (or any portion of it) in your project.
% ---------------------------------------------------------

	if(ndims(Iin) == 2)
		Iin = rapmat(Iin,[1 1 3]);
	end
	for i = 1:3,
		I{i} = Iin(:,:,i);
	end
    for i = 1:size(c,3),
		for j = 1:3,
			I{j}(find(c(:,:,i))) = 0;
		end
		I{i}(find(c(:,:,i))) = 1;
    end
	for j = 1:3,
		J(:,:,j) = I{j};
	end
end
