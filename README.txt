%--------------------------------------------------------------------------
% This file is part of the OPT InSitu Toolbox
%
% Copyright: 2017   High-Throughput Neurotechnology Group 
%                   Research Laboratory of Electronics
%                   Massachusetts Institute of Technology (MIT)
%                   Cambridge, Massachusetts, USA
%
% License: GNU General Public License v3.0
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

This code shows the basic workflow of the Optical Projection Tomography (OPT) 
reconstruction and the registration workflow presented in the paper "Automated
deep-phenotyping of the vertebrate brain". This not an exact implemention of 
the paper but is more intended to be as an initial starting point for 
getting started to work with OPT and in situ analysis. 

In order to reduce the data size need to be hosted and also for simplicity, 
when demonstrating the registration procedure in "example2_runRegistration.m",
 we only included the green channel data and use it both for the 
iterative shape averaging (ISA) of the WISH signal the and the registration
 between probe reference fish (PRF) and unstained reference fish (URF). 
To replicate the procedure described in the paper, one can apply minor 
modifications to the functions and, change the the input of the functions
includes both the green channel and blue channel images.

There are two parts of the code Optical Projection Tomography (OPT) and 
in situ registration. All data to run the examples can be downloaded from 
[publicationWebSite]

System requirements
-------------------
The code has been tested under Windows, 2.6ghz and 16GB RAM. 

License
-------
All code except the 3rd party code is coverd by the LICENSE.txt file. 
Files and folders covered by the LICENSE.txt file. 
example2_runRegistration.m
example1_ReconstructSingleFish.m
\optreconstruction
\registration
\tools



3rd Party
---------
All 3rd party code is placed in a separate folder and is not covered by the LICENSE.txt file.
All 3rd party code is covered by their respective license. 

*******ASTRA Toolbox*********************************************
This file is part of the ASTRA Toolbox
Copyright: 2010-2015, iMinds-Vision Lab, University of Antwerp
           2014-2015, CWI, Amsterdam
           http://visielab.uantwerpen.be/ and http://www.cwi.nl/
License: Open Source under GPLv3
Contact: astra@uantwerpen.be
Website: http://sf.net/projects/astra-toolbox
*******************************************************************

*******Inpaint_nans************************************************
Author: John D'Errico
e-mail address: woodchips@rochester.rr.com
Release: 2
Release date: 4/15/06
*******************************************************************

*******readVTK and writeVTKRGB ************************************
Both functions are modified version of code written by Erik Vidholm
Center for Image Analysis, Uppsala University, Sweden
Erik Vidholm 2005
Erik Vidholm 2006
*******************************************************************

References:
------------

If you use any part of the OPT InSitu Toolbox code for your research, we 
would appreciate it if you would refer to the following paper:

Add Reference
