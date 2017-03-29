% Find360: Find the start frame of a complete rotation give the end frame
% using the correlation metod

%  ind=Find360(VideoFrames,FrameReferenceidx)
% Inputs:
%    VideoFrames - 4D image files (Height x Width x Color Channel x Frame
%      Number) with the video frames,
%    FrameReferenceidx - The index of the frame selected as a reference
%    frame

% Outputs:
%    ind - The frame index of the frame that is a complete rotation away 
%    reference frame (showing the highest correlation with the reference 
%    frame. The frames whose frame number are close to the reference frame 
%    are not considered

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

function ind=Find360(varargin)

I=varargin{1};

if length(varargin)>1
    frameReference = varargin{2};
else
    frameReference = 1;
end

I=I(1:2:end,1:2:end,:,1); % downsample the image to save computational resource
CorrCief=zeros(1,size(I,3)); % Correlation Coefficient between each frame and the frameReference
noZone=round(size(I,3)*0.2); % The frame range not considered to be the frame Reference
for i=1:size(I,3);
    if any(i==frameReference-noZone:frameReference+noZone)
        CorrCief(i) = 0;
    else
        CorrCief(i)= corr2(I(:,:,i,1), I(:,:,frameReference,1));  
    end

end

[~, ind]=max(CorrCief);
