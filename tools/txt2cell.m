%txt2cell   reads txt file int cell array
%
% data = txt2cell( file )
%
%
% Inputs:
%    file - text file to read
% Outputs:
%    data - output cell array
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
function data = txt2cell( file )
%Import txt file to matlab cell

fid = fopen(file);
data = textscan(fid,'%s','Delimiter','\n');
data=data{1};
fclose(fid);
end

