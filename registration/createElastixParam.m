%initialAlignment   Create elastix registration paramter file
%
%   fp = createElastixParam(varargin)
%
%
% Inputs:
%    varargin - see code for more options on paramters to set or change
%
% Outputs:
%    transformation parameter file is written to the file -
%    ".\Registration\transformCustom\Paramters_Custom.txt" used by the 
%    registration function registration3DElastix.m
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

function fp = createElastixParam(varargin)
fp=0;
if numel(varargin)==1
    varargin=varargin{1};
end

%Get all paramters
p = inputParser;
paramUseDirectionCosines = 'DirectionCosines';
paramTransform = 'Transform';
paramMetric = 'Metric';
paramMultires = 'Multires';
paramIterations = 'Iterations';
paramSampling = 'Sampling';
paramResult = 'Result';
paramResampleInter = 'ResampleInterpolator';
paramInter = 'Interpolator';
paramGPU = 'UseGPU';
paramOptimizer = 'Optimizer';
paramBsplineGridSpacing = 'GridSpacing';
addOptional(p,paramUseDirectionCosines,'true',@(x) any(validatestringAA(x,{'true','false'})));
addOptional(p,paramTransform,'affine',@(x) any(validatestringAA(x,{'affine','similarity','rigid','tps','bspline'})));
addOptional(p,paramMetric,'corr',@(x) any(validatestringAA(x,{'corr','mm','sd','inv','ngc','pi','corr_rigidp','corr_bendp'})));
addOptional(p,paramMultires,[6 3 1],@(x) isnumeric(x));
addOptional(p,paramIterations,300,@(x) isnumeric(x));
addOptional(p,paramSampling,10000,@(x) isnumeric(x));
addOptional(p,paramResult,0,@(x) isnumeric(x));
addOptional(p,paramResampleInter,'bspline',@(x) any(validatestringAA(x,{'linear','bspline1','bspline2','bspline3','nearest'})));
addOptional(p,paramInter,'linear',@(x) any(validatestringAA(x,{'linear','bspline1','bspline2','bspline3','nearest'})));
addOptional(p,paramGPU,0,@(x) isnumeric(x));
addOptional(p,paramOptimizer,'adaptive',@(x) any(validatestringAA(x,{'adaptive','regular'})));
addOptional(p,paramBsplineGridSpacing,60,@(x) isnumeric(x));

parse(p,varargin{:});


Iterations=p.Results.Iterations;
if numel(Iterations)~=numel(p.Results.Multires)
    for i=1:numel(p.Results.Multires)
        Iterations(i)=300;
    end
end


UseDirectionCosines = p.Results.DirectionCosines;
TransformStrs = getTransform(p.Results.Transform,p.Results.GridSpacing);
MetricStrs = getMetric(p.Results.Metric);
MultiresStrs = getMultires(p.Results.Multires);
Iterations = strrep(num2str(Iterations),'  ',' ');
SamplingStr = getSampling(p.Results.Sampling);
ResultStr = getResult(p.Results.Result);
ResampleInterpStr = getResampleInterp(p.Results.ResampleInterpolator); 
InterpStr = getInterp(p.Results.Interpolator); 
UseGPUStr = getUseGPU(p.Results.UseGPU);
OptimizerStr = getOptimizer(p.Results.Optimizer);
 


data{1}     = '(FixedInternalImagePixelType "float")';
data{end+1} = '(MovingInternalImagePixelType "float")';
data{end+1} = '(FixedImageDimension 3)';
data{end+1} = '(MovingImageDimension 3)';
data{end+1} = ['(UseDirectionCosines "',UseDirectionCosines,'")'];

if strcmp(p.Results.Metric,'corr_rigidp') || strcmp(p.Results.Metric,'corr_bendp')
    data{end+1} = '(Registration "MultiMetricMultiResolutionRegistration")';
else
    data{end+1} = '(Registration "MultiResolutionRegistration")';
end
 

% data{end+1} = '(FixedImagePyramid "FixedRecursiveImagePyramid")'
% data{end+1} = '(MovingImagePyramid "MovingRecursiveImagePyramid")'
% data{end+1} = '(Resampler "DefaultResampler")'

for i=1:numel(UseGPUStr)
    data{end+1}= UseGPUStr{i};
end

for i=1:numel(ResampleInterpStr)
    data{end+1}= ResampleInterpStr{i};
end
for i=1:numel(InterpStr)
    data{end+1}= InterpStr{i};
end

for i=1:numel(OptimizerStr)
    data{end+1} = OptimizerStr{i};
end
for i=1:numel(TransformStrs)
    data{end+1}= TransformStrs{i};
end
if numel(TransformStrs)>1
    fp=1;
end
for i=1:numel(MetricStrs)
    data{end+1}= MetricStrs{i};
end
data{end+1} = '(AutomaticScalesEstimation "true")';
data{end+1} = '(AutomaticTransformInitialization "false")';
data{end+1} = '(AutomaticTransformInitializationMethod "GeometricalCenter")';
data{end+1} = '(HowToCombineTransforms "Compose")';
% data{end+1} = '(HowToCombineTransforms "Add")';
data{end+1} = '(ErodeMask "false")';

for i=1:numel(MultiresStrs)
    data{end+1}= MultiresStrs{i};
end
data{end+1} = ['(MaximumNumberOfIterations ',Iterations,')'];

for i=1:numel(SamplingStr)
    data{end+1}= SamplingStr{i};
end


data{end+1} = '(DefaultPixelValue 0)';


for i=1:numel(ResultStr)
    data{end+1}= ResultStr{i};
end 
 
% (UseDirectionCosines "true")
cell2txt('.\Registration\transformCustom\Paramters_Custom.txt',data);
end

function OptimizerStr = getOptimizer(optimizer)
switch optimizer
    case 'adaptive'
        OptimizerStr{1}='(Optimizer "AdaptiveStochasticGradientDescent")';
    case 'regular'
        OptimizerStr{1}='(Optimizer "RegularStepGradientDescent")';
        OptimizerStr{2}='(MinimumGradientMagnitude 0.000001)';
        OptimizerStr{3}='(MinimumStepLength 0.01)';
    otherwise
        OptimizerStr{1}='(Optimizer "AdaptiveStochasticGradientDescent")';
end
            
end

function UseGPUStr = getUseGPU(useGPU)
switch useGPU
    case 0
       UseGPUStr{1}='(FixedImagePyramid "FixedRecursiveImagePyramid")'; 
       UseGPUStr{2}='(MovingImagePyramid "MovingRecursiveImagePyramid")'; 
       UseGPUStr{3}='(Resampler "DefaultResampler")';
    case 1
       UseGPUStr{1}='(FixedImagePyramid "OpenCLFixedGenericImagePyramid")';
       UseGPUStr{2}='(OpenCLFixedGenericImagePyramidUseOpenCL "true")';
       UseGPUStr{3}='(MovingImagePyramid "OpenCLMovingGenericImagePyramid")';
       UseGPUStr{4}='(OpenCLMovingGenericImagePyramidUseOpenCL "true")';
%        UseGPUStr{5}='(Resampler "DefaultResampler")';
       UseGPUStr{5}='(Resampler "OpenCLResampler")';
       UseGPUStr{6}='(OpenCLResamplerUseOpenCL "true")';
    otherwise
       UseGPUStr{1}='(FixedImagePyramid "FixedRecursiveImagePyramid")'; 
       UseGPUStr{2}='(MovingImagePyramid "MovingRecursiveImagePyramid")'; 
       UseGPUStr{3}='(Resampler "DefaultResampler")';
end
        
end

function InterpStr = getInterp(interp)
switch interp
    case 'nearest'
        InterpStr{1}='(Interpolator "NearestNeighborInterpolator")';
    case 'linear'
        InterpStr{1}='(Interpolator "LinearInterpolator")';
    case 'bspline1'
        InterpStr{1}='(Interpolator "BSplineInterpolator")';
        InterpStr{2}= '(BSplineInterpolationOrder 1)';
    case 'bspline2'
        InterpStr{1}='(Interpolator "BSplineInterpolator")';
        InterpStr{2}= '(BSplineInterpolationOrder 2)';
    case 'bspline3'
        InterpStr{1}='(Interpolator "BSplineInterpolator")';
        InterpStr{2}= '(BSplineInterpolationOrder 3)';
    otherwise
        InterpStr{1}='(Interpolator "BSplineInterpolator")';
        InterpStr{2}= '(BSplineInterpolationOrder 1)';
end

end

function ResampleInterpStr = getResampleInterp(resampleinterp)
switch resampleinterp
    case 'nearest'
        ResampleInterpStr{1}='(ResampleInterpolator "FinalNearestNeighborInterpolator")';
    case 'linear'
        ResampleInterpStr{1}='(ResampleInterpolator "FinalLinearInterpolator")';
    case 'bspline1'
        ResampleInterpStr{1}='(ResampleInterpolator "FinalBSplineInterpolator")';
        ResampleInterpStr{2}= '(FinalBSplineInterpolationOrder 1)';
    case 'bspline2'
        ResampleInterpStr{1}='(ResampleInterpolator "FinalBSplineInterpolator")';
        ResampleInterpStr{2}= '(FinalBSplineInterpolationOrder 2)';
    case 'bspline3'
        ResampleInterpStr{1}='(ResampleInterpolator "FinalBSplineInterpolator")';
        ResampleInterpStr{2}= '(FinalBSplineInterpolationOrder 3)';
    otherwise
        ResampleInterpStr{1}='(ResampleInterpolator "FinalBSplineInterpolator")';
        ResampleInterpStr{2}= '(FinalBSplineInterpolationOrder 3)';
end

end
function ResultStr = getResult(result)
ResultStr=[];
if result
    ResultStr{end+1} = '(WriteResultImage "true" )';
    ResultStr{end+1} = '(ResultImagePixelType "float")';
    ResultStr{end+1} = '(ResultImageFormat "vtk")';
else
    ResultStr{end+1} = '(WriteResultImage "false" )';
    ResultStr{end+1} = '(ResultImagePixelType "float")';
    ResultStr{end+1} = '(ResultImageFormat "vtk")';
end
end

function SamplingStr = getSampling(sampling)
    if sampling>0
        SamplingStr{1} = ['(NumberOfSpatialSamples ',num2str(sampling),')'];
        SamplingStr{2} = '(NewSamplesEveryIteration "true")';
        SamplingStr{3} = '(ImageSampler "Random")';
    elseif sampling==0
        SamplingStr{1} = '(ImageSampler "Grid")';
        SamplingStr{2} = '(SampleGridSpacing 2)';
    else
        SamplingStr{1} = '(ImageSampler "Full")';
    end
end

function MultiresStrs = getMultires(multires)
resStr=[];
for i=1:numel(multires)
   resStr = strcat(resStr, [num2str(repmat(multires(i),[1 3]))]);
   resStr = strcat(resStr,{'  '});
end
resStr = cell2mat(resStr);
resStr = strrep(resStr,'  ',' ');
MultiresStrs{1}=['(NumberOfResolutions ',num2str(numel(multires)),')'];
MultiresStrs{2}=['(ImagePyramidSchedule ',resStr,' )'];
end

function MetricStrs = getMetric(metric)
 
switch metric
    case 'corr'
        MetricStrs{1}='(Metric "AdvancedNormalizedCorrelation")';
    case 'mm'
        MetricStrs{1}='(Metric "AdvancedMattesMutualInformation")';
    case 'sd'
        MetricStrs{1}='(Metric "AdvancedMeanSquares")';
    case 'inv'
        MetricStrs{1}='(Metric "DisplacementMagnitudePenalty")';
    case 'ngc'
        MetricStrs{1}='(Metric "NormalizedGradientCorrelation")'; 
    case 'pi'
        MetricStrs{1}='(Metric "PatternIntensity")';
    case 'corr_rigidp'
        MetricStrs{1}='(Metric "AdvancedNormalizedCorrelation" "TransformRigidityPenalty")';
        MetricStrs{2}='(LinearityConditionWeight 1000.0)';
        MetricStrs{3}='(OrthonormalityConditionWeight 2.0)';
        MetricStrs{4}='(PropernessConditionWeight 10.0)';

    case 'corr_bendp'
        MetricStrs{1}='(Metric "AdvancedNormalizedCorrelation" "TransformBendingEnergyPenalty")';
        MetricStrs{2}='(Metric0Weight 1.0)';
        MetricStrs{3}='(Metric1Weight 2.0)';
        MetricStrs{2}='(Metric0RelativeWeight 0.6)'
        MetricStrs{3}='(Metric1RelativeWeight 0.4)'
        MetricStrs{4}='(UseRelativeWeights "true")'
        
    otherwise
        MetricStrs{1}='(Metric "AdvancedNormalizedCorrelation")';
end
        
        
end

function TransformStrs = getTransform(transform,gridSize)

switch transform
    case 'affine'
        TransformStrs{1}='(Transform "AffineTransform")';
    case 'similarity'
        TransformStrs{1}='(Transform "SimilarityTransform")';
    case 'rigid'
        TransformStrs{1}='(Transform "EulerTransform")'; 
    case 'tps'
        TransformStrs{1}='(Transform "SplineKernelTransform")';
        TransformStrs{2}='(SplineKernelType "ThinPlateSpline")';
        TransformStrs{3}='(SplinePoissonRatio 0.3 )';
    case 'bspline'
        TransformStrs{1}='(Transform "BSplineTransform")';
        TransformStrs{2}=['(FinalGridSpacingInVoxels ',num2str(gridSize),')'];
        TransformStrs{3}='(BSplineTransformSplineOrder 3)';
    otherwise
        TransformStrs{1}='(Transform "AffineTransform")';
end
        
        
end

function strout=validBoolean(str,d)

strout = validatestring(str,{'true','false'});
end