% keepLargestObject: Keep the largest region in a binary image and set all
% other regions to 0.

% mask = keepLargestObject(bw)
% Inputs:
%    bw - the input 2D binary image

% Outputs:
%    mask - a binary image only keeps the largest region in bw


%--------------------------------------------------------------------------
% This file is part of the OPT InSitu Toolbox
%
% Copyright: 2017,  Researchlab of electronicss,
%                   Massachusetts Institute of Technology (MIT)
%                   Cambridge, Massachusetts, USA
% License: 
% Contact: a.allalou@gmail.com
% Website: https://github.com/aallalou/OPT-InSitu-Toolbox
%--------------------------------------------------------------------------



function [ bw ] = keepLargestObject( bw )
%KEEPLARGESTN Keep largest object in image
%   Labels an image and removes all object except the largest

% label image and get the area for all objects and sort them
bwl = bwlabeln(bw);
R = regionprops(bwl,'Area');
[val ind] = sort([R.Area],'descend');

% Find largest object and set it to 1  others are set to 0
maxind = ind(1);
inds=find(bwl==maxind);
bw(:)=0;
bw(inds)=1;

end

