% interpMask: interpolate the missing data region (defined by a mask of a image)

% Iout = interpMask(I,mask)
% Inputs:
%    I - A 2D gray scale image
%    mask - The region in which the interpolation is carried out. The
%    original data in the mask region will be neglected

% Outputs:
%    Iout - The interpolated image

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

function I = interpMask(I,mask)
ind = find(mask);
I(ind) = NaN;
I = inpaint_nans(double(I),5);

