%uint8norm   Funtion to call transformix from matlab
%
% varargout = transformix(I,transform,varargin)
%
% Inputs:
%    I - Image to transform
%    transform - Can be txt file with elastix transformation or a cell
%                array with elastix transformation information
%    varagin - can be set to 'gpu' to use gpu for transformation
% Outputs:
%    Iout - transformed image
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
function Iout = transformix(I,filename,varargin)
useGPU =  any(cell2mat(strfind(varargin, 'gpu')));

if iscell(filename)
    if useGPU
        for p=1:numel(filename)
            cell2txt(['param',num2str(p),'.txt'], setGPUTransform(filename{p}));
        end
    else
        for p=1:numel(filename)
            cell2txt(['param',num2str(p),'.txt'],  filename{p});
        end
    end
    filename = ['param',num2str(p),'.txt'];
end
 
outpath = '.\Registration\transformCustom\';
imname= 'im1.vtk';

writeVTKRGB(single(I),imname); 
cmd =   ['transformix '...
        '-out ',outpath,' ',...
        '-tp ',filename,' ',...
        ]
cmd = strcat(cmd,[' -in ',imname,' '])
 
try
    system(cmd);
    Iout=readVTK([outpath,'result.vtk']);
catch
    error('Error in transformation')
end

end
 