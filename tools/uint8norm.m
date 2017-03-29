%uint8norm   normalize data to 8bit
%
% I=uint8norm(I)
%
% Inputs:
%    I - Image before normalization
% Outputs:
%    I - Image normalized to 8bit
%
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
function I=uint8norm(I)
I=single(I);
Imax=max(I(:));
Imin=min(I(:));

I=(I-Imin)/(Imax-Imin)*255;

