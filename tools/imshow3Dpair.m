%imshow3Dpair   shows 2 3D images overlayed
%
% imshow3Dpair(I1,I2)
%
%
% Inputs:
%    I1 - first image
%    I2 - second image (must be the same size as I1)
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
function varargout = imshow3Dpair(varargin)
% IMSHOW3DPAIR MATLAB code for imshow3Dpair.fig
%      IMSHOW3DPAIR, by itself, creates a new IMSHOW3DPAIR or raises the existing
%      singleton*.
%
%      H = IMSHOW3DPAIR returns the handle to a new IMSHOW3DPAIR or the handle to
%      the existing singleton*.
%
%      IMSHOW3DPAIR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMSHOW3DPAIR.M with the given input arguments.
%
%      IMSHOW3DPAIR('Property','Value',...) creates a new IMSHOW3DPAIR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before imshow3Dpair_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to imshow3Dpair_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help imshow3Dpair

% Last Modified by GUIDE v2.5 14-Feb-2017 10:37:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @imshow3Dpair_OpeningFcn, ...
                   'gui_OutputFcn',  @imshow3Dpair_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before imshow3Dpair is made visible.
function imshow3Dpair_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to imshow3Dpair (see VARARGIN)

% Choose default command line output for imshow3Dpair
handles.output = hObject;

handles.I1 = uint8(uint8norm((varargin{1})));
handles.I2 = uint8(uint8norm((varargin{2})));
if numel(varargin)>2
    if varargin{3}==0
        handles.viewMode=1;
    elseif varargin{3}>0
        handles.viewMode=2;
    end
else
    handles.viewMode=1;
end
handles.zpos=1;
handles = setupImageAxes(hObject,handles);
handles.volumeSize=size(handles.I1);

 
 
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes imshow3Dpair wait for user response (see UIRESUME)
% uiwait(handles.figure1);


function handles = setupImageAxes(hObject,handles)

axes(handles.axes1);
handles.xyData = (squeeze(cat(3,handles.I2(:,:,handles.zpos),handles.I1(:,:,handles.zpos),handles.I2(:,:,handles.zpos))));
if handles.viewMode==1
    handles.xyHandle = imshow(handles.xyData,[0 255]);
elseif handles.viewMode==2
    handles.xyHandle = imagesc(handles.xyData);
end
colormap(gray);
% handles.xyText = text(10,10,['z = ',num2str(handles.zpos)],'Color',[1 1 1]);
handles.xyClim = get(handles.axes1,'CLim');
axis equal;
set(gca,'color',[0,0,0]);
set(gca, 'XTick', []);set(gca, 'YTick', []);
 
function updateImage(hObject,handles)
% handles.xyData = squeeze(handles.I(:,:,handles.zpos));
handles.xyData = (squeeze(cat(3,handles.I2(:,:,handles.zpos),handles.I1(:,:,handles.zpos),handles.I2(:,:,handles.zpos))));
set(handles.xyHandle, 'CData', handles.xyData);
set(handles.textZpos,'string',['Z position: ',num2str(handles.zpos)])
drawnow;

% --- Outputs from this function are returned to the command line.
function varargout = imshow3Dpair_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on scroll wheel click while the figure is in focus.
function figure1_WindowScrollWheelFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	VerticalScrollCount: signed integer indicating direction and number of clicks
%	VerticalScrollAmount: number of lines scrolled for each click
% handles    structure with handles and user data (see GUIDATA)


if eventdata.VerticalScrollCount > 0
    increment = -1;
else
    increment = +1;
end


handles.zpos = handles.zpos+increment;
if handles.zpos <1
    handles.zpos=1;
elseif handles.zpos>handles.volumeSize(3)
    handles.zpos=handles.volumeSize(3);
end

guidata(hObject, handles);
updateImage(hObject,handles);


% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
switch eventdata.Key
    case 'uparrow'
        %if eventdata.Key == 'uparrow'
        handles.zpos = handles.zpos+1;
        if handles.zpos <1
            handles.zpos=1;
        elseif handles.zpos>handles.volumeSize(3)
            handles.zpos=handles.volumeSize(3);
        end
        
        guidata(hObject, handles);
        updateImage(hObject,handles);
        %          guidata(hObject, handles);
        %end
    case 'p'
        %if eventdata.Key == 'downarrow'
        handles.zpos = handles.zpos-1;
        if handles.zpos <1
            handles.zpos=1;
        elseif handles.zpos>handles.volumeSize(3)
            handles.zpos=handles.volumeSize(3);
        end
        
        guidata(hObject, handles);
        updateImage(hObject,handles);
        
     case 'n'
        %if eventdata.Key == 'uparrow'
        handles.zpos = handles.zpos+1;
        if handles.zpos <1
            handles.zpos=1;
        elseif handles.zpos>handles.volumeSize(3)
            handles.zpos=handles.volumeSize(3);
        end
        
        guidata(hObject, handles);
        updateImage(hObject,handles);
        %          guidata(hObject, handles);
        %end
    case 'downarrow'
        %if eventdata.Key == 'downarrow'
        handles.zpos = handles.zpos-1;
        if handles.zpos <1
            handles.zpos=1;
        elseif handles.zpos>handles.volumeSize(3)
            handles.zpos=handles.volumeSize(3);
        end
        
        guidata(hObject, handles);
        updateImage(hObject,handles);
 
    
        %end
end
