% optimizeCOR: Optimize the center of rotation by maximize the variation of 
% the reconstructed image


% dy  = optimizeCOR( In,AnglesIn )
% Inputs:
%    In - The aligned tomography projection frames in one color channel 
%         (Height x Width(Slices)x Frame Number ).
%    AnglesIn - The angles corresponding to the projection views in each
%          frame

% Outputs:
%    dy - The displacement of the optimal rotation center from the center
%    line of the input image.


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


function dy  = optimizeCOR( In,AnglesIn )

disp('Generating reconstructions to estimate center of Rotation.')
global I;    
global Ang;
Ang = AnglesIn;

% Sample the slices
I=In(:,1:10:end,:);

% Define upper and lower bound for rotation axis search
lb=-7;
ub=7;

% maximize the variation of the reconstructed images as the rotation axis
% moves
OPTI = optimset('MaxIter',40,'TolX',0.1);%
[dy,~,~] = fminbnd(@COR,lb,ub,OPTI);
 
% % output the optimal rotation axis
% M = make_transformation_matrix([x 0 0]);
end  

    
    
    
    
    
function f=COR(dy)

global I;
global Ang;

% move the sinograme vertically
J = imtranslate(I,[0 -dy],'cubic');

% reconstruct the sampled slices
d1 = OPTReconstructionAstra3D(J(8:end-7,:,:),'fbp',Ang/360*2*pi);
% d1 = OPTReconstructionAstra3D(J,'fbp',Ang/360*2*pi);



IMask=Mask(d1,15);
d1=bsxfun(@times,d1,IMask); % mask out the boudary region of the reconstruction

 d1(d1<0)=0;
 f= -var(d1(:)); % Use the variation of the reconstructed image as the objective function
 disp(['x=',num2str(dy),' f(x)=',num2str(f)]);
end
