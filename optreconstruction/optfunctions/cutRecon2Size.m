% cutRecon2Size: Crop the image to desired size around the center of 
% the bounding box of mask.

% out = cutRecon2Size(rec, mask,recOutSize)
% Inputs:
%    rec - the 3D image to be cropped
%    mask - the mask used to define the center of the object in the 3D
%    image
%    recOutSize - the output size of the cropped image.

% Outputs:
%    out - the cropped image

%    Note that the fish axial direction is treated differently so that the
%    space in front of the fish head is preserved 
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

function rec = cutRecon2Size(rec, mask,recOutSize)
% crop the image rec to size recOutSize around the center of the bounding box of mask.

imSize=size(rec);
if any((imSize(1:3)-recOutSize(1:3))<0)
    disp('Image size must be larger than cut size');
    return;
end
bbox = getBoundingBox(mask);
ctr=round(min(bbox,[],1)+(max(bbox,[],1)-min(bbox,[],1))/2);


%% Col 
% The axial direction of fish. 
cmin=imSize(2)-recOutSize(2)+1;
cmax=imSize(2); % The empty space in front of the fish head is preserved 

%% Row
% cut the image so that the center of mask bounding box is the center of the new
% image on this direction
rmin = ctr(1)-ceil(recOutSize(1)/2);
rmax = ctr(1)+ceil(recOutSize(1)/2)-1;
if rmin<=0
    rmin=1;
    rmax=rmin+recOutSize(1)-1;
end

if rmax>imSize(1)
    rmin=imSize(1)-recOutSize(1)+1;
    rmax=imSize(1);
end

if numel(rmin:rmax)~=recOutSize(1)
      rmax=rmin+recOutSize(1)-1;;
end

%% Z
% cut the image so that the center of mask bounding box is the center of the new
% image on this direction
zmin = ctr(3)-ceil(recOutSize(3)/2);
zmax = ctr(3)+ceil(recOutSize(3)/2)-1;

if zmin<=0
    zmin=1;
    zmax=zmin+recOutSize(3)-1;
end

if zmax>imSize(3)
    zmin=imSize(3)-recOutSize(3)+1;
    zmax=imSize(3);
end

if numel(zmin:zmax)~=recOutSize(3)
      zmax=zmin+recOutSize(3)-1;
end
%% Crop the image
[numel(rmin:rmax) numel(cmin:cmax) numel(zmin:zmax)]
rec=rec(rmin:rmax,cmin:cmax,zmin:zmax,:);