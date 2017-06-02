%
% Copyright 2017 Vienna University of Technology.
% Institute of Computer Graphics and Algorithms.
%

function varargout = gui_white_balance(varargin)
    % gui_white_balance MATLAB code for gui_white_balance.fig
    %      gui_white_balance, by itself, creates a new gui_white_balance or raises the existing
    %      singleton*.
    %
    %      H = gui_white_balance returns the handle to a new gui_white_balance or the handle to
    %      the existing singleton*.
    %
    %      gui_white_balance('CALLBACK',hObject,eventData,handles,...) calls the local
    %      function named CALLBACK in gui_white_balance.M with the given input arguments.
    %
    %      gui_white_balance('Property','Value',...) creates a new gui_white_balance or raises the
    %      existing singleton*.  Starting from the left, property value pairs are
    %      applied to the GUI before gui_white_balance_OpeningFcn gets called.  An
    %      unrecognized property name or invalid value makes property application
    %      stop.  All inputs are passed to gui_white_balance_OpeningFcn via varargin.
    %
    %      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
    %      instance to run (singleton)".
    %
    % See also: GUIDE, GUIDATA, GUIHANDLES

    % Edit the above text to modify the response to help gui_white_balance

    % Last Modified by GUIDE v2.5 25-Mar-2012 21:22:45

    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @gui_white_balance_OpeningFcn, ...
                       'gui_OutputFcn',  @gui_white_balance_OutputFcn, ...
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

% --- Executes just before gui_white_balance is made visible.
function gui_white_balance_OpeningFcn(hObject, eventdata, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to gui_white_balance (see VARARGIN)

    handles.input = varargin{1};
    handles.result = varargin{1};
    m = max(handles.input(:));
    imshow(handles.input ./ m);

    % Choose default command line output for gui_white_balance
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);

    % UIWAIT makes gui_white_balance wait for user response (see UIRESUME)
    uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = gui_white_balance_OutputFcn(hObject, eventdata, handles) 
    % varargout  cell array for returning output args (see VARARGOUT);
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    varargout{1} = handles.result;
    % The figure can be deleted now
    delete(handles.figure1);
end

% --- Executes on button press in bt_OK.
function bt_OK_Callback(hObject, eventdata, handles)
    % hObject    handle to bt_OK (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    close(handles.figure1);
end

% --- Executes on button press in bt_new.
function bt_new_Callback(hObject, eventdata, handles)
    % hObject    handle to bt_new (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    m = max(handles.input(:));
    imshow(handles.input ./ m);
    [x y p] = gui_pick_point(handles.input);
    if (p)
        white = max(handles.input(y, x, :), 1/65535);
        result = evc_white_balance(handles.input, white);
        %m = max(result(:));
        %imshow(result ./ m);
        imshow(result);
        handles.result = result;
        guidata(hObject, handles);
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
