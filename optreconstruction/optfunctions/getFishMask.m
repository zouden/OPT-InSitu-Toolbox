% getFishMask: Find a mask containing the fish region


% mask = getFishMask(rec)
% Inputs:
%    rec - 4D reconstructed image (Height x Width x Depth x Color Channel) 

% Outputs:
%    mask - the 3D binary image (Height x Width x Depth) containing the 
%    fish region (defined by the highly attenuated region in the blue 
%    channel with necessary adjustments)
 
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



function mask = getFishMask(rec)
Ir = (uint8(uint8norm(rec(1:2:end,1:2:end,1:2:end,3))));
[~, T]=threshold(Ir(:), 'background');
structElement = zeros(7,7,7);
structElement(4,4,4)=1;
structElement=bwdist(structElement);
structElement=structElement<=3;
mask=(bwlabeln(Ir>T));
mask =(keepLargestObject(mask));
mask = imdilate(mask,structElement);
mask=imclose(mask>0,structElement);
mask=imfill(mask,'holes');
mask = imresize3D(mask,size(mask)*2,'nearest');
end