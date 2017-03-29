% AlignVerticalN: Find the row indices of the of the top and bottom inner 
% walls at the left/right end of the capillary in each frame. The row
% indices are used for align the frames vertically according to the
% positions of the inner walls

% InnerWallRowInd = AlignVerticalN( I,LorR )
% Inputs:
%    I - 4D matrix(HeightxWidthx3xFrame number) of the frames to be aligned
%    LOR - Left or Right flag. LOR = 1 is for left side and 2 for the right 
%          conners of the capillary walls.
% Outputs:
%    InnerWallRowInd - The row indices (Frame Number x 2) of the of the top 
%     and bottom inner walls at the left/right end of the capillary in each 
%     frame.

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



function  InnerWallRowInd = AlignVerticalN( I,LorR )
% Vertical Alignment 
% LOR =1 is for left side and 2 for the right side of the capillary.
% Return InnerWallRowInd(FrameNumber x 2) :the row indices of the 
% top and bottom inner walls at the left/right end of the capillary.

% use the first frame to estimate the positions of the two inner walls.
[bw, ~]=(threshold(255-imfilter(I(:,:,1,3),ones(5,5),'replicate'),'triangle')); % threshold and set the capillary walls to 1 and background to 0.
bw=keepFullWidthLines(bw)>0; % Remove 1's corresponding to the fish but not the walls
bw = (imfill(keepLargestObject(1-logical(bw)),'holes')); % obtain the region in between the two inner walls;

if LorR==1
    upPos=find(bw(:,1), 1 );
    downPos=find(bw(:,1), 1, 'last' );
    ColumnIdx=1:2; % The column indices that define the left end
else
    upPos=find(bw(:,end), 1 );
    downPos=find(bw(:,end), 1, 'last' );
    ColumnIdx=size(bw,2)-1:size(bw,2); % The column indices that define the right end
end

% Detect the position of the inner walls for each frame
windowsz=150; % window size to search for the walls. margin < capillary wall thickness & margin > capillary wobble distance

Ir=max(permute(I(:,ColumnIdx,:,3),[1 3 2]),[],3); % generate the sinogram of the walls on the left end

Irg=gradient(imfilter(Ir,ones(5,5),'replicate')')'; % detect edges corresponding to the walls by taking the gradient

% Bottom wall
IrgB = Irg;
IrgB(IrgB<0)=0;

% Isolate the bottom inner wall of the capillary
botLim = downPos+windowsz;
botLim(botLim>size(I,1))=size(I,1);
IrgB(1:downPos-windowsz,:)=0; % remove top walls
IrgB(botLim:end,:)=0; % remove bottom outer wall

% Top wall: The sign of the gradient is flipped due to symmetry
IrgT=Irg;
IrgT(IrgT>0)=0;
IrgT=-IrgT; 

% Isolate the top inner wall of the capillary
topLim = upPos-windowsz;
topLim(topLim<1)=1; 
IrgT(1:topLim,:)=0; % remove top outer wall
IrgT(upPos+windowsz:end,:)=0; % remove bottom walls 

% Thresholding to obtain the edges on the two inner walls. 
[~, BT]=threshold(IrgB,'volume',0.01);
[~, TT]=threshold(IrgT,'volume',0.01);

% morphological close to remove noise
IrgB=keepFullWidthLines(imclose(IrgB>BT, strel('disk',15) ));
IrgT=keepFullWidthLines(imclose(IrgT>TT, strel('disk',15) ));

% find the regions whose position is the closest to the wall postion
% estimated at the very begining
bMinVal = zeros(1,max(IrgB(:)));
for i=1:max(IrgB(:))
    bMinVal(i)=min(abs(find(IrgB(:,1)==i)-downPos));
end
tMinVal = zeros(1,max(IrgB(:)));
for i=1:max(IrgT(:))
    tMinVal(i)=min(abs(find(IrgT(:,1)==i)-upPos));
end
[ ~, bMinPos]=min(bMinVal(:));
[ ~, tMinPos]=min(tMinVal(:));
IrgB=(IrgB==bMinPos);
IrgT=(IrgT==tMinPos);

% mask the gradient image with the binary wall edge images
IrgBV=IrgB.*Irg;
IrgTV=-IrgT.*Irg;

% Detect the accurate inner wall positions by finding the gradient image maxima
bp = zeros(1,size(Irg,2));
tp = zeros(1,size(Irg,2));
for i=1:size(Irg,2)
   [~, p]=max(IrgBV(:,i),[],1);
   bp(i)=p(1);
   [~, p]=max(IrgTV(:,i),[],1);
   tp(i)=p(1);
end


InnerWallRowInd(:,1)=tp;
InnerWallRowInd(:,2)=bp;
end

function label = keepFullWidthLines(bw)
% only keep regions that expend from the leftmost end to the rightmostend
% the output images are label matrx contains labels for connected regions.
bw=single(bw)>0;
label=bwlabel(bw);
for i=1:max(label(:))
    llab = find(label(:,1)==i);
    rlab = find(label(:,end)==i);
    if numel(llab)==0  || numel(rlab)==0
        label(label==i)=0;
    end
end
label=bwlabel(label>0);
end
