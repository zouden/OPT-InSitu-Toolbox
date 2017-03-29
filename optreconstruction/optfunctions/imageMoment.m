%  imageMoment: Find a first moment (weighted center) of a grayscale image
%  [ x, y, z ] = imageMoment( I )

% Input:
%    I- the input 3D gray scale image
% 
% Output:
%    x,y,z-coordinates of the weighted center of the input image
 
%--------------------------------------------------------------------------
% This file is part of the OPT InSitu Toolbox
%
% Copyright: 2017,  Researchlab of electronicss,
%                   Massachusetts Institute of Technology (MIT)
%                   Cambridge, Massachusetts, USA
% License: Open Source under GPLv3
% Contact: aallalou@mit.edu
% Website: http:// 
% If you use this any part of this code in you project please use the
% reference
% XXXXXXXX
%--------------------------------------------------------------------------


function [ x y z ] = imageMoment( I )

I=double(I);
[row col z]=size(I);
[X Y Z]=meshgrid(1:col, 1:row,1:z);
M000 = sum(I(:));

MX1=X.*I;
MX1=sum(MX1(:));

MY1=Y.*I;
MY1=sum(MY1(:));

MZ1=Z.*I;
MZ1=sum(MZ1(:));

 
 
x=MX1/M000-1;
y=MY1/M000-1;
z=MZ1/M000-1;
end

