function [nldepth, faceid] = RenderMex(K, imw, imh, vmat, fmat);
% function [nldepth, faceid] = RenderMex(double(K), int32(imw), int32(imh), double(vmat), uint32(fmat));
% Input: 
%   K is the camera matrix
%   imw is the width of the output
%   imh is the height of the output
%   vmat is a 3xv double matrix containing the vertices, 
%   fmat is a 4xf uint32 matrix contianing the face triangles, 0 indexed vertices
%   K = [fx 0 cx; 0 fy imh-cy; 0 0 1]; Note that its not cy but imh-cy at K(2,3), weirdness with RenderMex
%
% Output:
%   Do the following to get in the familiar kinect format
%   nldepth = nldepth';
%   faceid = faceid'; faceid = faceid(end:-1:1,:); faceid = swapbytes(faceid); faceid = faceid./(256);
%   depthFull = p.z_near./(1-double(nldepth)/2^32);
