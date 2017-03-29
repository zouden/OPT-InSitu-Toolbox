% Function align2PRF   Align data to a Probe reference fish as described in 
%                      paper XXXX
%
% [Iprobe_transformed transformMatrix]=align2PRF(PRF,I_probe, I_mask)
%
%
% Inputs:
%    PRF - Probe reference that the image will be aligned to. 
%    I_probe - In situ probe image that will be aligned to the PRF
%    I_mask - mask image used to mask region included in the registration
% Outputs:
%    Iprobe_transformed - Transformed probe image
%    transformMatrix - transformation matrix containing all transformations
%                      to transform the I_probe to the PRF. 
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

function [Iprobe_transformed transformMatrix]=align2PRF(PRF,I_probe, I_mask)
useGPU = 0;

% Initial alignement of I_probe to PRF
finalTransform=initialAlignment(PRF,I_probe);
transformMatrix{1,1}=finalTransform{1};
transformMatrix{1,2}=finalTransform{2};
cell2txt('param1.txt',transformMatrix{1,1});
cell2txt('param2.txt',transformMatrix{1,2});
% I_transformed = transformix(I_probe, 'param2.txt');

% Get gradient image of the PRF and the probe image
PRF_grad = single(gradmag(PRF,1));
I_probe_grad = single(gradmag(I_probe,1));

% registration with Similarity transform using the initial registratio
% transformation in "param2.txt"
registration3DElastix(PRF_grad,I_probe_grad,I_mask,'param2.txt',...
                    'Transform','similarity',...
                    'Multires',[8 4 ],...
                    'Iterations',[1500 300 ],...
                    'Sampling',-1,...
                    'ResampleInterpolator','linear',...
                    'Interpolator','linear',...
                    'Optimizer','regular',...
                    'UseGPU',useGPU);

% store transformation matrix
transformMatrix{1,3}=txt2cell('.\Registration\transformCustom\TransformParameters.0.txt');
cell2txt('param3.txt',transformMatrix{1,3});

% registration with affine transform using the initial registratio
% transformation in "param3.txt"
registration3DElastix(PRF_grad,I_probe_grad,I_mask,'param3.txt',...
                    'Transform','affine',...
                    'Multires',[6 4 2],...
                    'Iterations',[500 150 100],...
                    'Sampling',-1,...
                    'ResampleInterpolator','linear',...
                    'Interpolator','linear',...
                    'UseGPU',useGPU);

% store transformation matrix
transformMatrix{1,4}=txt2cell('.\Registration\transformCustom\TransformParameters.0.txt');
cell2txt('param4.txt',transformMatrix{1,4});

% registration with bspline using the initial registratio
% transformation in "param4.txt"
registration3DElastix(PRF_grad,I_probe_grad,I_mask,'param4.txt',...
                    'Transform','bspline',...
                    'Multires',[8 6 3 ],...
                    'Metric','corr_rigidp',...
                    'Iterations',[1000 200 100 ],...
                    'Sampling',-1,...
                    'ResampleInterpolator','linear',...
                    'Interpolator','linear',...
                    'Optimizer','regular',...
                    'UseGPU',useGPU); 

% store transformation matrix
transformMatrix{1,5}=txt2cell('.\Registration\transformCustom\TransformParameters.0.txt');

% transform the data using all transformations
Iprobe_transformed = transformix(I_probe,  {transformMatrix{1,1:5}});
end


    
 