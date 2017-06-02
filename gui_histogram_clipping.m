%
% Copyright 2017 Vienna University of Technology.
% Institute of Computer Graphics and Algorithms.
%

function varargout = gui_histogram_clipping(varargin)
    % gui_histogram_clipping MATLAB code for gui_histogram_clipping.fig
    %      gui_histogram_clipping, by itself, creates a new gui_histogram_clipping or raises the existing
    %      singleton*.
    %
    %      H = gui_histogram_clipping returns the handle to a new gui_histogram_clipping or the handle to
    %      the existing singleton*.
    %
    %      gui_histogram_clipping('CALLBACK',hObject,eventData,handles,...) calls the local
    %      function named CALLBACK in gui_histogram_clipping.M with the given input arguments.
    %
    %      gui_histogram_clipping('Property','Value',...) creates a new gui_histogram_clipping or raises the
    %      existing singleton*.  Starting from the left, property value pairs are
    %      applied to the GUI before gui_histogram_clipping_OpeningFcn gets called.  An
    %      unrecognized property name or invalid value makes property application
    %      stop.  All inputs are passed to gui_histogram_clipping_OpeningFcn via varargin.
    %
    %      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
    %      instance to run (singleton)".
    %
    % See also: GUIDE, GUIDATA, GUIHANDLES

    % Edit the above text to modify the response to help gui_histogram_clipping

    % Last Modified by GUIDE v2.5 25-Mar-2012 19:23:52

    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @gui_histogram_clipping_OpeningFcn, ...
                       'gui_OutputFcn',  @gui_histogram_clipping_OutputFcn, ...
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

% --- Executes just before gui_histogram_clipping is made visible.
function gui_histogram_clipping_OpeningFcn(hObject, eventdata, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to gui_histogram_clipping (see VARARGIN)
    RGB_WB = varargin{1};
    if (nargin > 4)
        handles.bins = varargin{2};
    else
        handles.bins = 256; 
    end
    
    handles.RGB_WB_small = imresize(RGB_WB, 0.2, 'lanczos3');
    setappdata(handles.bt_okClip, 'clickNr', -1);
    handles.input = RGB_WB;

    axes(handles.ax_pictureClip);
    handles.maxVal = max(RGB_WB(:));
    imshow(RGB_WB ./ handles.maxVal);
    axes(handles.ax_pictureClipBinary);    
    imshow(handles.RGB_WB_small, [0 max(0.0000001,handles.maxVal)]);%FIXED: maxVal clamped to 1
    cla;
    axes(handles.ax_histoClip);
    setappdata(handles.ax_pictureClip, 'hist_max', gui_histshow(RGB_WB, handles.bins));
    setappdata(handles.edit_x1, 'xval', 0);
    setappdata(handles.edit_x2, 'xval', handles.maxVal);
    set(handles.edit_x1, 'String', '0');
    set(handles.edit_x2, 'String', sprintf('%5.3f', handles.maxVal));

    handles.minBorder = 0.02;
    handles.maxBorder = 1 + handles.minBorder;
    
    set(handles.ax_histoClip, 'XLimMode', 'manual');
    set(handles.ax_histoClip, 'XLim', [-handles.minBorder*handles.maxVal handles.maxVal*handles.maxBorder ]);
    
    set(hObject, 'WindowButtonDownFcn',{@ax_histoClip_ButtonDownFcn, handles});  
    %set(handles.ax_histoClip, 'ButtonDownFcn',{@ax_histoClip_ButtonDownFcn, handles}); 
    %set(hObject, 'ButtonDownFcn', {@ax_histoClip_ButtonDownFcn, handles});

    % Choose default command line output for gui_histogram_clipping
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);
    
    uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = gui_histogram_clipping_OutputFcn(hObject, eventdata, handles) 
    % varargout  cell array for returning output args (see VARARGOUT);
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    x1 = getappdata(handles.edit_x1, 'xval');
    x2 = getappdata(handles.edit_x2, 'xval');    
    
    % Get default command line output from handles structure
    [varargout{1},param1,param2,param3] = evc_histogram_clipping(handles.input, x1, x2);
    % The figure can be deleted now
    delete(handles.figure1);    
end

% --- Executes on button press in bt_okClip.
function bt_okClip_Callback(hObject, eventdata, handles)
    % hObject    handle to bt_okClip (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)    
    if isequal(get(handles.figure1, 'waitstatus'), 'waiting')
        close(handles.figure1);
    end
end

% --- Executes on button press in bt_newClip.
function bt_newClip_Callback(hObject, eventdata, handles)
    % hObject    handle to bt_newClip (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    setappdata(handles.bt_okClip, 'clickNr', 0);

    axes(handles.ax_pictureClip);
    imshow(handles.input ./ handles.maxVal);
    axes(handles.ax_pictureClipBinary);
    cla;
    axes(handles.ax_histoClip);
    cla;
    
    setappdata(handles.ax_pictureClip, 'hist_max', gui_histshow(handles.input, handles.bins));
    set(handles.ax_histoClip, 'XLim', [-handles.minBorder*handles.maxVal handles.maxVal*handles.maxBorder]);
    setappdata(handles.edit_x1, 'xval', 0);
    set(handles.edit_x1, 'BackgroundColor', [1 1 0.7]);
    set(handles.edit_x2, 'BackgroundColor', [1 1 1]);
    setappdata(handles.edit_x2, 'xval', handles.maxVal);    
    set(handles.ax_histoClip, 'ButtonDownFcn',{@ax_histoClip_ButtonDownFcn, handles}); 
end

% --- Executes on mouse motion over figure - except title and menu.
function figure1_WindowButtonMotionFcn(hObject, eventdata, handles)
    % hObject    handle to figure1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)      
    if isappdata(handles.ax_pictureClip, 'hist_max') %wait until everything is initialized
        coords = get(handles.ax_histoClip,'CurrentPoint');
        hm = getappdata(handles.ax_pictureClip, 'hist_max');
        click = getappdata(handles.bt_okClip, 'clickNr');
        xlim = get(handles.ax_histoClip, 'XLim');
                
        if  ((click >= 0) && (coords(1,1) >= xlim(1)) && (coords(1,1) <= xlim(2)) && (coords(1,2) >= -0.1) && (coords(1,2) <= hm))
            binary = evc_compute_binary(handles.RGB_WB_small, coords(1,1), click);
            axes(handles.ax_pictureClipBinary);
            m = max(handles.RGB_WB_small(:));
            imshow(binary, [0 m]);
            if (click == 0)
                set(handles.edit_x1, 'String', sprintf('%5.3f', coords(1,1)));
            else
                set(handles.edit_x2, 'String', sprintf('%5.3f', coords(1,1)));
            end            
        else
            axes(handles.ax_pictureClipBinary);
            cla;
        end        
    end
end

% --- Executes on mouse press over axes background.
function ax_histoClip_ButtonDownFcn(hObject, eventdata, handles) 
    % hObject    handle to ax_histoClip (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    if isappdata(handles.ax_pictureClip, 'hist_max') %wait until everything is initialized
        coords = get(handles.ax_histoClip, 'CurrentPoint');
        hm = getappdata(handles.ax_pictureClip, 'hist_max');
        xlim = get(handles.ax_histoClip, 'XLim');
        if  ((coords(1,1) >= xlim(1)) && (coords(1,1) <= xlim(2)) && (coords(1,2) >= -0.1) && (coords(1,2) <= hm))
            if (getappdata(handles.bt_okClip, 'clickNr') == 1)
                x = coords(1,1);
                x1 = getappdata(handles.edit_x1, 'xval');
                if ((abs(x - x1) > 0.001)&&(x1 < x))
                    set(handles.edit_x1, 'BackgroundColor', [1 1 1]);
                    set(handles.edit_x2, 'BackgroundColor', [1 1 1]);
                    set(handles.edit_x2, 'String', sprintf('%5.3f', x));
                    setappdata(handles.bt_okClip, 'clickNr', -1);
                    [RGB_CLIP,param1,param2,param3] = evc_histogram_clipping(handles.input, x1, x);
                    axes(handles.ax_pictureClip);
                    imshow(RGB_CLIP);
                    axes(handles.ax_pictureClipBinary);
                    cla;
                    axes(handles.ax_histoClip);
                    cla;
                    setappdata(handles.ax_pictureClip, 'hist_max', gui_histshow(RGB_CLIP, handles.bins));                    
                    m = max(RGB_CLIP(:));
                    set(handles.ax_histoClip, 'XLim', [-handles.minBorder*m  m*handles.maxBorder]);
                    setappdata(handles.edit_x2, 'xval', x);
                end
            end

            if (getappdata(handles.bt_okClip, 'clickNr') == 0)        
                set(handles.edit_x1, 'BackgroundColor', [1 1 1]);
                set(handles.edit_x2, 'BackgroundColor', [1 1 0.7]);        
                x = max(coords(1,1), 0);
                set(handles.edit_x1, 'String', sprintf('%5.3f', x));
                axes(handles.ax_histoClip);       
                setappdata(handles.bt_okClip, 'clickNr', 1);
                setappdata(handles.edit_x1, 'xval', x);
            end
        end
    end
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