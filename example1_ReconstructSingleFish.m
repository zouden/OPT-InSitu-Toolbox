% ReconstructSingleFish Script to run reconstruction for a single fish

% DIPimage toolbox (http://www.diplib.org/download) and ASTRA tomography 
% toolbox (http://www.astra-toolbox.com/)
% shoud be downloaded and installed before using this code                     
%

% Run the code and use the UI to select the video files to be reconstruced.
% The result .MAT files will be saved at the same directory of the video.
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

%%
addpath(genpath('optreconstruction'))
%% Select the OPT video file (.AVI)
FilterIndex =0;
while ~FilterIndex 
[VideoName,VideoPath,FilterIndex] = uigetfile('*.avi','Please select the AVI file to be reconstructed:');
    if ~FilterIndex
        YN = input('Are you sure to quit the reconstruction?(Y/N):','s');
        if strcmpi(YN,'y')
            return;
        end
    end
end
%% Reconstruct fish. A (.MAT) file storing the reconstruction will be saved at the same directory as the video. 
AlignInSituMacro([VideoPath,VideoName]);
