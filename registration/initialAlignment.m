%initialAlignment   perform rough initial alignment of an image to a 
%                   referece image.
%   [transformParameterRigid, finalTransform]= initialAlignment(Ifixed,Imoving) 
%
%
% Inputs:
%    Ifixed - fixed image in the registation
%    Imoving - moving image in the registration
%
% Outputs:
%    initialTransform - transformation of initial rough registration
%
%--------------------------------------------------------------------------
% This file is part of the OPT InSitu Toolbox
%
% Copyright: 2017,  Researchlab of electronicss,
%                   Massachusetts Institute of Technology (MIT)
%                   Cambridge, Massachusetts, USA
% License: Open Source under GPLv3
% Contact: aallalou@mit.edu
% Website: http:// 
%--------------------------------------------------------------------------

function [finalTransform]= initialAlignment(ref,float)


initialRotations = [0:45:359];
ss=8;
refss = ref(1:ss:end,1:ss:end,1:ss:end);
floatss = float(1:ss:end,1:ss:end,1:ss:end);
transformParameterRigid = txt2cell('.\registration\transformCustom\transformParameterRigid.txt');
transformParameterRigid{find(ismember(transformParameterRigid,'(Size)')),:}=...
    ['(Size ',num2str(size(refss)),')'];

transformParameterRigid{find(ismember(transformParameterRigid,'(CenterOfRotationPoint)')),:}=...
    ['(CenterOfRotationPoint ',num2str(size(refss)/2),')'];

for i=1:numel(initialRotations)
    transformParameterRigidRot = transformParameterRigid;
    transformParameterRigidRot{find(ismember(transformParameterRigidRot,'(TransformParameters 0 0 0 0 0 0)')),:}=...
        ['(TransformParameters 0 ',num2str(initialRotations(i)/360*2*pi),' 0 0 0 0)'];
    cell2txt('initRot.txt',transformParameterRigidRot);
    Igf = registration3DElastix(refss,floatss,ones(size(refss))>0,'initRot.txt',...
        'Transform','rigid',...
        'Multires',[1 ],...
        'Iterations',[ 300 ],...
        'Sampling',-1,...
        'ResampleInterpolator','linear',...
        'Interpolator','linear',...
        'Optimizer','regular',...
        'UseGPU',0);
%      finalTransform{i,1}=txt2cell('.\Registration\transformCustom\TransformParameters.0.txt');
    iterationResult = txt2cell('.\registration\transformCustom\IterationInfo.0.R0.txt');
    S =sscanf(iterationResult{end},'%i %f %f %f %f');
    corrValue(i)=S(2);
end
[~,pos]=min(corrValue);

transformParameterRigid = txt2cell('.\registration\transformCustom\transformParameterRigid.txt');

transformParameterRigid{find(ismember(transformParameterRigid,'(Size)')),:}=...
    ['(Size ',num2str(size(ref)),')'];

transformParameterRigid{find(ismember(transformParameterRigid,'(CenterOfRotationPoint)')),:}=...
    ['(CenterOfRotationPoint ',num2str(size(ref)/2),')'];

transformParameterRigid{find(ismember(transformParameterRigid,'(TransformParameters 0 0 0 0 0 0)')),:}=...
    ['(TransformParameters 0 ',num2str(initialRotations(pos)/360*2*pi),' 0 0 0 0)'];

cell2txt('param1.txt',transformParameterRigid);
registration3DElastix(ref,float,ones(size(ref))>0,'param1.txt',...
'Transform','rigid',...
'Multires',[8 ],...
'Iterations',[ 300 ],...
'Sampling',-1,...
'ResampleInterpolator','linear',...
'Interpolator','linear',...
'Optimizer','regular',...
'UseGPU',0);
finalTransform{1}=transformParameterRigid;
finalTransform{2}=txt2cell('.\Registration\transformCustom\TransformParameters.0.txt');

end