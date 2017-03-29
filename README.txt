%--------------------------------------------------------------------------
% This file is part of the OPT InSitu Toolbox
%
% Copyright: 2017   High-Throughput Neurotechnology Group 
%                   Research Laboratory of Electronics
%                   Massachusetts Institute of Technology (MIT)
%                   Cambridge, Massachusetts, USA
%
% License: 
% Contact: a.allalou@gmail.com
% Website: https://github.com/aallalou/OPT-InSitu-Toolbox
% If you use the OPT InSitu Toolbox for your research, we would appreciate 
% if you would refer to the following paper:
% xxxxxxxxxxxxxxTBDyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy
% xxxxxxxxxxxxxxTBDyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy
% xxxxxxxxxxxxxxTBDyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy
%--------------------------------------------------------------------------

The major part of the code is written in MATLAB. The open source registration
toolbox elastix (http://elastix.isi.uu.nl/) is used for registration and 
must be installed before running the code. Other required toolboxes that 
need to be downloaded and installed are the ASTRA Tomography Toolbox 
(http://www.astra-toolbox.com/) and DIPimage (http://www.diplib.org/). For 
more information and full descriptoin of the OPT in situ workflow se the 
reference. 

There are two parts of the code Optical Projection Tomography (OPT) and 
in situ registration. All data to run the examples can be downloaded from 
....
To run the OPT example 

In order to reduce the data size need to be hosted and also for simplicity, 
when demonstrating the registration procedure in "example2_runRegistration.m",
 we only included the green channel data and use it both for the 
iterative shape averaging (ISA) of the WISH signal the and the registration
 between probe reference fish (PRF) and unstained reference fish (URF). 
To replicate the procedure described in the paper, one can apply minor 
modifications to the function "iterativeShapeAveraging.m", so that the input
 of the function includes both the green channel and blue channel image, 
and uses the blue channel image for the "% initial alignment of all data to
 the I_reference" section.


References:
------------

If you use any part of the OPT InSitu Toolbox code for your research, we 
would appreciate it if you would refer to the following paper:

Add Reference
