% AlignHorizontal: Find the translation distance to horizontally align the 
% video frames based on the the location of the fish head tip in each frame

% dx=AlignHorizontal(I)
% Inputs:
%    I - 4D matrix(HeightxWidthx3xFrame number) of the frames to be aligned
% Outputs:
%    dx - The horizontal translation required to vertically align the frames

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

function dx=AlignHorizontal(I)
% Find the tip of the fish head in each frame of I and store the column
% indices in dx

vis = 0;
% projection the image vertically for each frame and generate the
% axial profile as a function of frame numbers
Isum=squeeze(sum(sum(I,4),1))';
% threshold the axial profile
T = trianglethreshold(Isum);
bw=keepLargestn(Isum>T);

% get the fish tip by finding the endpoint of the axial profile 
for i=1:size(bw,1)
    dx(i)=find(bw(i,:)>0, 1, 'last' ); 
end
if vis
figure;imshow(Isum,[]);
hold on;plot(dx,[1:size(bw,1)])
end
end

function value = trianglethreshold(in)
in=dip_image(in);
% A smooth histogram
border = 16;
[histogram,bins] = smoothhistogram(in,4,border);
% Find peak
[PKS,LOCS]= findpeaks(histogram);
max_value=PKS(1);
max_element=LOCS(1);
% Define: start, peak, stop positions in histogram
sz = length(histogram);
right_bin = [sz-border,histogram(sz-border)];
top_bin   = [max_element,max_value];


for i=top_bin(1):right_bin(1)
    P=[i, histogram(i)];
    distance(i) = abs(det([top_bin'-right_bin',P'-right_bin']))/norm(top_bin'-right_bin');
    
end
xv=[top_bin(1) right_bin(1) right_bin(1) top_bin(1)];
yv=[top_bin(2) right_bin(2) 0 0];
in = inpolygon([1:right_bin(1)],histogram([1:right_bin(1)]),xv,yv);
distance=distance.*in;
[~,bin] = max(distance);
value = bins(bin);


end

function [histogram,bins] = smoothhistogram(in,sigma,border,N)
if nargin<4
   N = 200;
end
if nargin<3
   border = 2*sigma;
end
min_val = min(in);
max_val = max(in);
if min_val==max_val
   error('The image is constant.')
end
 
   interval = (max_val-min_val)/(N-1);
 
max_val = max_val+border*interval;
min_val = min_val-border*interval;
[histogram,bins] = diphist(in,[min_val  max_val],N);
if sigma>0
   histogram = double(gaussf(histogram,sigma));
end
end