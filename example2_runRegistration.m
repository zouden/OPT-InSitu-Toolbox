%runRegistration   Script to run a basic version of the registration 
%                  workflow presented in paper
%                       
%
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
addpath(genpath('registration'))
addpath(genpath('tools'))
addpath(genpath('data'))


% Load reference fish and brain atlas
disp('Load reference fish and brain atlas for 2dpf');
load('.\data\registration\referenceFish\2dpf\I_reference.mat')
load('.\data\registration\referenceFish\2dpf\I_atlas.mat')
load('.\data\registration\referenceFish\2dpf\I_brainmask.mat')

%% Load wildtype data
disp('Loading all wildtype fish.')
for i=1:8
    load(['.\data\registration\TestData_th_2dpf\wt\wt',num2str(i),'_Irecon_2.mat']);
    I_wt(:,:,:,i)=I;
    disp(['Loading wt fish ',num2str(i),'.'])
end

%% run the iterative shape averaging on all wildtype fish
[I_isa transformMatrix]=iterativeShapeAveraging( I_wt, I_reference,I_brainmask );

I_isaBspline=I_isa(:,:,:,end);

% Select as PRF the fish that matches best with the average or the 
% I_isaBspline can be used as PRF (PRF = I_isaBspline)
for i=1:size(I_wt,4) 
    I_transformed=transformix(I_wt(:,:,:,i),{transformMatrix{i,1:end}},'gpu');
    corrValue(i)=corr2(I_transformed(find(I_brainmask)),I_isaBspline(find(I_brainmask)));
end

% Pick PRF
[~,PRF_ind]=max(corrValue);
PRF = transformix(I_wt(:,:,:,PRF_ind),{transformMatrix{PRF_ind,1:end}},'gpu');


%% Align all fish to PRF

% Align wildtype
for i=1:size(I_wt,4)
    [I_wt_transformed(:,:,:,i) transformMatrix_wt]=align2PRF(PRF,I_wt(:,:,:,i), I_brainmask);
end
I_ave_wt = mean(I_wt_transformed,4);
clear I_wt_transformed;
clear I_wt;

% load mutant data
disp('Loading all wildtype fish.')
for i=1:8
    load(['.\data\registration\TestData_th_2dpf\mt\mt',num2str(i),'_Irecon_2.mat']);
    I_mt(:,:,:,i)=I;
    disp(['Loading mt fish ',num2str(i),'.'])
end

% Align all mutant fish to the PRF
for i=1:size(I_mt,4)
   [I_mt_transformed(:,:,:,i) transformMatrix_wt]=align2PRF(PRF,I_mt(:,:,:,i), I_brainmask);
end
    


I_ave_mt = mean(I_mt_transformed,4);
figure;imshow(cat(2,squeeze(max(I_ave_wt,[],3))',squeeze(max(I_ave_mt,[],3))'),[])
    

    
