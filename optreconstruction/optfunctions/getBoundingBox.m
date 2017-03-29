% getBoundingBox: Find the bounding box of a binary image


% bbox = getBoundingBox(mask)
% Inputs:
%    mask - a 3D binary image with 1 denotes the region of interest

% Outputs:
%    bbox - the coordinates of the 8 cornerpoints (8x3) of the bounding box of 
%    the input binary image

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


function bbox = getBoundingBox(mask)

[r c z] = ind2sub(size(mask),find(mask));

rmi=min(r);
rma=max(r);
cmi=min(c);
cma=max(c);
zmi=min(z);
zma=max(z);

bbox = [rmi cmi zmi;
       rmi cmi zma;
       rmi cma zmi;
       rmi cma zma;
       rma cmi zmi;
       rma cmi zma;
       rma cma zmi;
       rma cma zma;];