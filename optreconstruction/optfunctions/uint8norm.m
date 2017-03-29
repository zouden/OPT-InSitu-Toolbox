% uint8norm: Normalize a image so that the minimal value is 0 and the
% maximum value is 255.

% out=uint8norm(I)
% Inputs:
%    I - original image
% Outputs:
%    out - the output image with its element values normalized to 0~255


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



function I=uint8norm(I)
I=double(I);
Imax=max(I(:));
Imin=min(I(:));

I=(I-Imin)/(Imax-Imin)*255;

