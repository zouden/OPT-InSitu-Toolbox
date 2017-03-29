% transformTube: Transform a 2D image according to the reference points

% imgw = transformTube(I,fixedp,movingp)
% Inputs:
%    I - the input 2D image
%    fixdp - the reference points in the fixed frame
%    movingp - the reference points in the moving frame

% Outputs:
%    imgw - the transformed image of the input image so that the reference 
%            points fixedp are transormed to movingp


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



function imgw = transformTube(I,fixedp,movingp)


move = movingp-fixedp;
if sum(abs(move(:)))>0
    tform = fitgeotrans(flip(movingp,2),flip(fixedp,2),'affine');
    imgw = imwarp(I(:,:,1),tform,'OutputView',imref2d(size(I(:,:,1))),'Interp','cubic');
 
else
    imgw = I;
end