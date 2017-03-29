% KeepLargest2: Label the lagest regions in a binary images 

% mask = KeepLargest2(I,nlar)
% Inputs:
%    I - A 2D binary image
%    nlar - a vector whose element is the rank of the region area sizes
% Outputs:
%    mask - a label image gives labels the regions according the the area
%    size.

% e.g. if nlar = 0; return the largest region
%      if nlar = 1; reture the 2nd largest region
%      if nlar = [1 0 2], the 2nd largest region in I will be labeled 1 in
%      mask, the largest labeled 2, and the 3rd largest labeled 3.


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


function [mask] = KeepLargest2(I,nrlab)

L = bwlabel(I,8);

stats = regionprops(L,'area');
[~, ind] = sort([stats.Area]);
mask=zeros(size(I));
for k=1:numel(nrlab)
    mask(L==ind(end-nrlab(k)))=k;
end



