% OPTReconstructionAstra3D: Wrapper function for the tomography
% reconstruction functionality in the ASTRA tomography toolbox. the
% function reconstruct multiple slices.

% rec = OPTReconstructionAstra3D(sino,type,Angles)
% Inputs:
%    sino - The sinogram (Height x Slice x Frame Number)asscociated with 
%           multiple slices
%    type - The type of the reconstruction algorithm to be used. Recommend
%           'fbp' for filtered backprojection.
%    Angles - The angles corresponding to the projection views in each
%           frame

% Outputs:
%    rec - the reconstructed 3D image

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

function [ rec ] = OPTReconstructionAstra3D( sino,type,Ang)

tic;
NrSlices = size(sino,2);
diago=size(sino,1);
N =  diago;% ceil(sqrt(diago^2/2));
rec=zeros(N,N,NrSlices);


GPU=isGpuAvailable;
for i=1:NrSlices
    rec(:,:,i,1) = OPTReconstructionAstra( sino(:,i,:,1),type,Ang );
    
    if mod(i,round(NrSlices/10))==0
%         disp(num2str(i));
        fprintf('.')
    end
end
 fprintf('\n')
toc
end

