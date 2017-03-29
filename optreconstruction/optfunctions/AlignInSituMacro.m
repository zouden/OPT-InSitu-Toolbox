% AlignInSituMacro Align the frames and perform the reconstruction for a 
% single video file

% AlignInSituMacro(VideoName)
% Inputs:
%    VideoName- The full path of the video file to be reconstructed
% Outputs:
%    Reconstructions for 4 channels stored in 3 separate .MAT files will be
%    saved at the same directory as the orignial video. A random projection
%    view will also be samed in .PNG file for quick examination.

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

function AlignInSituMacro(VideoName)
close all;

% Load sensor calibration data
CalibrationFileName = [pwd,filesep,'calibrationImage.mat'];
try
    load(CalibrationFileName)
    IcalIm = single(IcalIm);
catch
    display(['Fail to find the sensor calibration data at:',CalibrationFileName]);
    YN = input('Quit reconstruction (Y/N) or continue without sensor calibration?:','s');
    if strcmpi(YN,'y')
        return;
    else
        IcalIm = [];
    end
end


% Import RGB *.avi file from OPT acquisition
% RGB images are stored as f(x,y,z,color)
fprintf('Reading input image. ')
I = single(importAVIRGB(VideoName));
fprintf( 'Done. \n');

% Compensate for unequal pixel sensetivity
if ~isempty(IcalIm)
I(:,:,:,1) = bsxfun(@rdivide,I(:,:,:,1),IcalIm(:,:,1));
I(:,:,:,2) = bsxfun(@rdivide,I(:,:,:,2),IcalIm(:,:,2));
I(:,:,:,3) = bsxfun(@rdivide,I(:,:,:,3),IcalIm(:,:,3));
end

% Rotate the capillary to be in a horizontal position
I=rot90(I);


% This is done with the hough transform finding lines
IHoughTransform=I(:,:,1,1); % Take out one frame for Hough transform
BW = edge(IHoughTransform,'log');
[~, ~, ang]=houghTAlign(BW); % find the tilting angle of the capillary

% Rotate the image based on the mean angle from the hough transform
alpha=mean(ang);
disp('Rotating data.')
if alpha~=0
    for ch=1:size(I,4)
        I(:,:,:,ch)= imrotate(I(:,:,:,ch),alpha,'bicubic','crop');
        fprintf('.');
    end
end
fprintf('\n');

% Crop the image to remove blank regions from rotation
rcrop=ceil(abs(size(BW,2)*alpha/180*pi))+2;
ccrop=ceil(abs(size(BW,1)*alpha/180*pi))+2;
I=I(rcrop:end-rcrop,ccrop:end-ccrop,:,:);


% Vertical Alignment according to the inner capillary walls
InnerWallRowIndL= AlignVerticalN(I,1); % row indices of the inner walls at the left end
InnerWallRowIndR= AlignVerticalN(I,2); % row indices of the inner walls at the right end
% smooth the data

InnerWallRowIndLsm(:,1) =  single(smooth(InnerWallRowIndL(:,1)));
InnerWallRowIndLsm(:,2) =  single(smooth(InnerWallRowIndL(:,2)));
InnerWallRowIndRsm(:,1) =  single(smooth(InnerWallRowIndR(:,1)));
InnerWallRowIndRsm(:,2) =  single(smooth(InnerWallRowIndR(:,2)));

% Set the corner points of the capillary to make them the same in all
% frames. Also set a fixed capillary width of 680 pixels

fixedCapDiameter = 680;
fixedp =    [InnerWallRowIndLsm(1,1) 1;...
            (InnerWallRowIndLsm(1,1)+fixedCapDiameter) 1;...
            InnerWallRowIndLsm(1,1) size(I,2);...
            (InnerWallRowIndLsm(1,1)+fixedCapDiameter) size(I,2)];


% Transform the images so that the capillary corner points in different frames are at the same position 
Ialigned=single(zeros(size(I)));
for i=1:size(I,3)
    for ch=1:size(I,4)
        Ialigned(:,:,i,ch) = single(transformTube(I(:,:,i,ch),fixedp,[InnerWallRowIndLsm(i,1) 1;InnerWallRowIndLsm(i,2) 1;InnerWallRowIndRsm(i,1) size(I,2); InnerWallRowIndRsm(i,2) size(I,2)]));
    end
end


% Get the center and the radius of the tube
ctr = round(InnerWallRowIndLsm(1,1) +(InnerWallRowIndLsm(1,2)-InnerWallRowIndLsm(1,1))/2);
TubR=(InnerWallRowIndLsm(1,2)-InnerWallRowIndLsm(1,1))/2;

% Clear input image to release memory
clear I;
Ialigned=single(Ialigned(ctr-TubR:ctr+TubR,:,:,:));


% Mask out the fish by taking the maximum of all frames followed by a threshold. 
% Interpolate the masked out region to get a background image. 
mask=uint8(uint8norm(max(Ialigned(:,:,100:end,3),[],3)));
mask=255-mask;
[~, t]=(threshold(mask(100:end-100,:),'triangle'));
mask=(mask>t);
mask(1:100,:)=0;
mask(end-100:end,:)=0;
mask=imdilate(keepLargestObject(mask), strel('disk',25) );

% Interpolate and smooth the image
Ibackground = Ialigned(:,:,1,:);
for ch=1:size(Ialigned,4)
    Ibackground(:,:,1,ch) = max(Ialigned(:,:,:,ch),[],3);
    Ibn = interpMask(Ibackground(:,:,1,ch),mask);
    Ibackground(:,:,1,ch)=imfilter(Ibn,ones(15,15),'replicate');
end

% Divide the background image
for ch=1:size(Ialigned,4)
    Ialigned(:,:,:,ch) = bsxfun(@rdivide,Ialigned(:,:,:,ch),Ibackground(:,:,1,ch));
end
clear Ibackground;

% the attenuation image: logarithm of the background corrected image
Iattenuation=-log(Ialigned);
Iattenuation(isinf(Iattenuation))=min(Iattenuation(:));
clear Ialigned;


% Get the fish direction (left or right) and rotate if necessary
direction = nan(size(Iattenuation,3),1);
for i=1:10:size(Iattenuation,3)
    It = Iattenuation(:,:,i,3);
    It(isinf(It))=0;
    It(isnan(It))=0;
    shape = (sum(keepLargestObject(single(imerode(logical(thresholdDIP(It,'triangle')),ones(25,25)))).*Iattenuation(:,:,i,3),1));
    imm = imageMoment(shape);
    if abs(imm-find(shape, 1 ))<abs(imm-find(shape, 1, 'last' ))
        direction(i)=1;
    else
        direction(i)=0;
    end
end
direction = mode(direction(~isnan(direction)));

if direction==1
    Iattenuation = rot90(rot90(Iattenuation));
end


% Find column index of the end tip of the fish head
% % % % % dx=AlignHorizontal(Iattenuation(100:end-99,round(size(Iattenuation,2)/2):end,1:2,3))+round(size(Iattenuation,2)/2)-1;
% % % % % dx(:)=dx(1);
[row cols]=find(single(threshold(max(Iattenuation(:,:,:,2),[],3),'otsu')));
headPos = max(cols);

headLength=656; % The length of a box supposedly to enclose the whole fish head
headEmptySpace = 50; % The breath space left around the fish head

% define the colume index range of the fish head region (detemine the slices to be reconstructed) 
headCols=[headPos-headLength+headEmptySpace+1:headPos+headEmptySpace];
if headCols(end)>size(Iattenuation,2)
    headCols=(size(Iattenuation,2)-headLength+1:size(Iattenuation,2));
end
if headCols(1)<1
    headCols=headCols+abs(headCols(1))+1;    
end

% Find the start and the end frame of a whole rotation
ind360Revolution=Find360(Iattenuation(:,:,:,1),size(Iattenuation,3)); % the end frame is set to the last frame of the video

% Crop the attenuation image
Iattenuation =Iattenuation(:,headCols,ind360Revolution:end,:);

% Angles of the projection views. Assume uniform view sampling.
Angles=[1:size(Iattenuation,3)];
Angles=Angles-Angles(1);
Angles=Angles/Angles(end)*360;
Angles=-Angles;
if direction
    Angles=-Angles;
end


% optimize the center of rotation
dy = optimizeCOR(double(Iattenuation(:,:,:,2)),Angles);

for ch=1:size(Iattenuation,4)
channelMin(ch) = min(min(min(Iattenuation(:,:,:,ch))));
end
% vertically move the sinogram so that the rotational axis is at the center
Isino=zeros(size(Iattenuation));
if abs(dy)<0.5
    Isino=Iattenuation;
else
    for z=1:size(Iattenuation,3)
        for ch=1:size(Iattenuation,4)
            Isino(:,:,z,ch)=imtranslate(single(Iattenuation(:,:,z,ch)),[0 dy],'cubic','FillValues',channelMin(ch));
        end
    end
end
clear Iattenuation;
Isino=single(Isino);
Isino(Isino<0)=0;


% start reconstruction
for c=1:size(Isino,4)
    disp(['Reconstructing channel ',num2str(c),'.'])
    rec(:,:,:,c)  = single(OPTReconstructionAstra3D(Isino(:,:,:,c )-channelMin(ch),'fbp',Angles/360*2*pi));
    rec(:,:,:,c) =bsxfun(@times,rec(:,:,:,c) ,Mask(rec(:,:,:,c),15));
end
rec(rec<0)=0;

% crop the reconstruction according to the center of the bounding box of the
% reconstruction
rec = permute(rec,[1 3 2 4]) ;
OutSize=[512 512 512  size(rec,4)];
mask = getFishMask(rec);
rec = cutRecon2Size(rec, mask,OutSize);

% save the reconstruction to the MAT file
for c=1:3
    I=rec(:,:,:,c);
    save([VideoName(1:end-4),'_Recon_ch',num2str(c),'.mat'],'I','-v7.3');
end

% save a snapshot (Maximumprojection)
recIm = uint8(uint8norm(squeeze(max(rec,[],3))));
imshow(recIm,[]);
title('snapshot of reconstruction')
imwrite(recIm,[VideoName(1:end-4),'_reconSlice.png']);
end


