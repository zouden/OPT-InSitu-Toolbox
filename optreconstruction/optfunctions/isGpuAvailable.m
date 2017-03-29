% isGpuAvailable: test if GPU is available on the current computer

% OK = isGpuAvailable

% Outputs:
%    OK - OK = 1 if GPU is available, 0 otherwise.

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

function OK = isGpuAvailable
try
    d = gpuDevice;
    OK = d.SupportsDouble;
catch
    OK = false;
end