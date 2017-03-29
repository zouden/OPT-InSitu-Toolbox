% houghTAlign: Perfoem Hough transform and detect the capillary walls and get
% the position and the tilting angle of the wall.


% [x, y, ang]=houghTAlign(I)
% Inputs:
%    I - a 2D projection image

% Outputs:
%    x,y - the coordinates of the corner points of the capillary wall
%    ang - the tilting angle of the capillary wall

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



function  [x, y, ang]=houghTAlign(I)

vis = 0;

% Hough transform
[H,T,R]= hough(double(I),'RhoResolution',1,'ThetaResolution',0.01);


% Find the 2 strongest peaks
P  = houghpeaks(H,2);%

% Find Angles of the lines and show visual result
ang = zeros(size(P,1),1);
y = zeros(size(P,1),2);
if vis
    figure(1);
    imshow(I,[]);hold on;
end
for k=1:size(P,1)
    theta = -T(P(k,2));
    rho = R(P(k,1));
    x=double([1  size(I,2)]);
    
    y(k,:)=-cosd(theta)/sind(theta)*x+(rho/sind(theta))-1;
    ang(k)=atand(cosd(theta)/sind(theta));
    if vis
        plot(x,-y(k,:));
    end
    
end
if vis
    title('Detecting Capillary Walls')
end

