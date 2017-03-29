% OPTReconstructionAstra: Wrapper function for the tomography
% reconstruction functionality in the ASTRA tomography toolbox. the
% function reconstruct only a single slice.


% rec = OPTReconstructionAstra(sino,type,Angles)
% Inputs:
%    sino - The sinogram (Height x Frame Number) asscociated with one slice
%    type - The type of the reconstruction algorithm to be used. Recommend
%    'fbp' for filtered backprojection.
%    Angles - The angles corresponding to the projection views in each
%          frame

% Outputs:
%    rec - the reconstructed 2D image

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



function  rec = OPTReconstructionAstra( sino,type,Angles )

sino=squeeze(sino);
diago=size(sino,1);
proj_geom = astra_create_proj_geom('parallel', 1.0, diago, Angles);
% store sino
N =  diago;% ceil(sqrt(diago^2/2));
 
vol_geom = astra_create_vol_geom(N, N);
% Create a data object for the reconstruction
rec_id = astra_mex_data2d('create', '-vol', vol_geom);
sinogram_id = astra_mex_data2d('create','-sino', proj_geom, 0);
% sino = astra_mex_data2d('get',sino_id);
astra_mex_data2d('set',sinogram_id,permute(sino,[2 1]));
% type='fbp';
% type='sirt'


 GPU=isGpuAvailable;

% create configuration 
if strcmp(type,'fbp')
    
    if ~GPU
        proj_id = astra_create_projector('strip', proj_geom, vol_geom);
        cfg = astra_struct('FBP');
        cfg.ProjectorId = proj_id;
    else
        cfg = astra_struct('FBP_CUDA');
    end
    cfg.FilterType = 'Ram-Lak';
    cfg.FilterType = 'shepp-logan';
%      cfg.FilterType = 'hamming';
%      cfg.option.PixelSuperSampling=4;
elseif strcmp(type,'cgls')
    cfg = astra_struct('CGLS_CUDA');
    cfg.option.MinConstraint =0;
elseif strcmp(type,'sirt')
    cfg = astra_struct('SIRT_CUDA');
%     cfg.option.MinConstraint =0;
     
end
cfg.ReconstructionDataId = rec_id;
cfg.ProjectionDataId = sinogram_id;
% Create and run the algorithm object from the configuration structure
alg_id = astra_mex_algorithm('create', cfg);
if strcmp(type,'cgls')
    astra_mex_algorithm('iterate', alg_id, 50);
elseif strcmp(type,'sirt')
    astra_mex_algorithm('iterate', alg_id, 300);
elseif strcmp(type,'fbp')
   astra_mex_algorithm('run', alg_id);
end


% Get the result
rec = astra_mex_data2d('get', rec_id);
% figure; imshow(rec, []);

astra_mex_algorithm('delete', alg_id);
astra_mex_data2d('delete', rec_id);
astra_mex_data2d('delete', sinogram_id);
end

