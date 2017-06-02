%
% Copyright 2017 Vienna University of Technology.
% Institute of Computer Graphics and Algorithms.
%

function varargout = gui_gamma_correction(varargin)
    % EVC_GAMMA_CORRECTION_GUI MATLAB code for evc_gamma_correction_gui.fig
    %      EVC_GAMMA_CORRECTION_GUI, by itself, creates a new EVC_GAMMA_CORRECTION_GUI or raises the existing
    %      singleton*.
    %
    %      H = EVC_GAMMA_CORRECTION_GUI returns the handle to a new EVC_GAMMA_CORRECTION_GUI or the handle to
    %      the existing singleton*.
    %
    %      EVC_GAMMA_CORRECTION_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
    %      function named CALLBACK in EVC_GAMMA_CORRECTION_GUI.M with the given input arguments.
    %
    %      EVC_GAMMA_CORRECTION_GUI('Property','Value',...) creates a new EVC_GAMMA_CORRECTION_GUI or raises the
    %      existing singleton*.  Starting from the left, property value pairs are
    %      applied to the GUI before evc_gamma_correction_gui_OpeningFcn gets called.  An
    %      unrecognized property name or invalid value makes property application
    %      stop.  All inputs are passed to evc_gamma_correction_gui_OpeningFcn via varargin.
    %
    %      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
    %      instance to run (singleton)".
    %
    % See also: GUIDE, GUIDATA, GUIHANDLES

    % Edit the above text to modify the response to help evc_gamma_correction_gui

    % Last Modified by GUIDE v2.5 25-Mar-2012 22:50:28

    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @gui_gamma_correction_OpeningFcn, ...
                       'gui_OutputFcn',  @gui_gamma_correction_OutputFcn, ...
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
end

% --- Executes just before evc_gamma_correction_gui is made visible.
function gui_gamma_correction_OpeningFcn(hObject, eventdata, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to evc_gamma_correction_gui (see VARARGIN)        
    RGB_CLIP = varargin{1};
    if (nargin > 4)
        handles.bins = varargin{2};
    else
        handles.bins = 256;
    end
        
    handles.input = RGB_CLIP;
    gamma = 2.2;
    set(handles.slider_gamma, 'Value', gamma);
    set(handles.edit_gamma, 'String', num2str(gamma));
    setappdata(handles.ax_picture, 'gamma', gamma);
    
    rgb_small = imresize(RGB_CLIP, 0.33, 'lanczos3');
    rgb_small(rgb_small < 0) = 0;
    handles.RGB_CLIP_small = rgb_small;
    [rgb_small,param1,param2,param3,param4] = evc_gamma_correction(rgb_small, gamma, get(handles.checkbox1, 'Value'));
    %BEGIN SUPERSECRET CLAMP FIX
    rgb_small(isinf(rgb_small)) = 100;
    rgb_small((rgb_small) > 100 ) = 100;
    rgb_small(isnan(rgb_small)) = 0;
    %END SUPERSECRET FIX
    m = max(rgb_small(:));
	%BEGIN NEXT FIX
	mnm = min(rgb_small(:));
	if mnm == m
		m = m + 0.1;
		rgb_small(1,1,1) = m;
	end
	%END NEXT FIX
    axes(handles.ax_picture);
    imshow(rgb_small ./ m);
    axes(handles.ax_hist);
    handles.minBorder = 0.02;
    handles.maxBorder = 1 + handles.minBorder;
    setappdata(handles.ax_hist, 'hist_max', gui_histshow(rgb_small, handles.bins));
    set(handles.ax_hist, 'XLim', [-handles.minBorder*m m*handles.maxBorder]);
    %set(handles.slider_gamma, 'value', 1.2);
    
    % Choose default command line output for evc_gamma_correction_gui
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);
    
    uiwait(handles.figure1);
end


% --- Outputs from this function are returned to the command line.
function varargout = gui_gamma_correction_OutputFcn(hObject, eventdata, handles) 
    % varargout  cell array for returning output args (see VARARGOUT);
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    gamma = getappdata(handles.ax_picture, 'gamma'); 
    % Get default command line output from handles structure
    [varargout{1},param1,param2,param3,param4] = evc_gamma_correction(handles.input, gamma, get(handles.checkbox1, 'Value'));
    % The figure can be deleted now
    delete(handles.figure1);    
end


% --- Executes on button press in bt_ok1.
function bt_ok1_Callback(hObject, eventdata, handles)
    % hObject    handle to bt_ok1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)   
    if isequal(get(handles.figure1, 'waitstatus'), 'waiting')
        close(handles.figure1); %Closes the window
    end
end


% --- Executes on slider movement.
function slider_gamma_Callback(hObject, eventdata, handles)
    % hObject    handle to slider_gamma (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: get(hObject,'Value') returns position of slider
    %        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
    updateGamma(hObject, handles);
end

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
    % hObject    handle to figure1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hint: delete(hObject) closes the figure
    if isequal(get(hObject, 'waitstatus'), 'waiting')
        % The GUI is still in UIWAIT, us UIRESUME
        uiresume(hObject);
    else
        % The GUI is no longer waiting, just close it
        delete(hObject);
    end
end


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
    % hObject    handle to checkbox1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hint: get(hObject,'Value') returns toggle state of checkbox1
    updateGamma(hObject, handles);
end

function updateGamma(hObject, handles)
    gamma = get(handles.slider_gamma, 'Value');
    gamma_fixed = gamma;
    if gamma <= 0.0000000001
        gamma_fixed = 0.0000000001;
    end
    setappdata(handles.ax_picture, 'gamma', gamma_fixed);
    set(handles.edit_gamma, 'String', num2str(gamma));
    axes(handles.ax_picture);
    cla;
    [RGB_small,param1,param2,param3,param4] = evc_gamma_correction(handles.RGB_CLIP_small, gamma, get(handles.checkbox1, 'Value'));
    m = max(RGB_small(:));
    imshow(RGB_small ./ m);
    axes(handles.ax_hist);
    cla;
    setappdata(handles.ax_hist, 'hist_max', gui_histshow(RGB_small, handles.bins));  
	%FIXED XLim Range is now valid
    set(handles.ax_hist, 'XLim', [-handles.minBorder*m max(m*handles.maxBorder, -handles.minBorder*m + 1)]);
    guidata(hObject, handles);
end
