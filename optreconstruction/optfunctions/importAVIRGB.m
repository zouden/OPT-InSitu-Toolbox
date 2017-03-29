% importAVIRGB: Input all the frames from a video file

% I = importAVIRGB(VideoName)
% Inputs:
%    VideoName - the full directory of the video file

% Outputs:
%    I - 4D images (Height x Width x Frame Number x Color) containing 
%    all the frames.

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


function I = importAVIRGB(VideoName)
%IMPORTAVIRGB Import RGB *.avi file from OPT acquisition
% RGB images are stored as f(x,y,z,color)

readerobj = VideoReader(VideoName);
I = read(readerobj);
I=permute(I,[ 1 2 4 3]);

end

