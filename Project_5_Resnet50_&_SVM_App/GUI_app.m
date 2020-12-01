function varargout = GUI_app(varargin)
% GUI_APP MATLAB code for GUI_app.fig
%      GUI_APP, by itself, creates a new GUI_APP or raises the existing
%      singleton*.
%
%      H = GUI_APP returns the handle to a new GUI_APP or the handle to
%      the existing singleton*.
%
%      GUI_APP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_APP.M with the given input arguments.
%
%      GUI_APP('Property','Value',...) creates a new GUI_APP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_app_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_app_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_app

% Last Modified by GUIDE v2.5 28-Nov-2020 20:45:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_app_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_app_OutputFcn, ...
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


% --- Executes just before GUI_app is made visible.
function GUI_app_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_app (see VARARGIN)

% Choose default command line output for GUI_app
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_app wait for user response (see UIRESUME)
% uiwait(handles.figure1);
%% trying to load the model only once:
global model
model = load('classifier.mat', 'classifier', 'net', 'imageSize', 'featureLayer');
warning off

% --- Outputs from this function are returned to the command line.
function varargout = GUI_app_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
global filename

[filename, pathname] = uigetfile({'*.jpg;*.png;*.jpeg;*.bmp;*.tif', ...
    '(*.jpg,*jpeg,*.png,*.bmp,*.tif)'}, ...
    'Browse Image');
if filename == 0
    handles.rgb_img = 0;
    handles.rgb_img_set = 0;
    display('no image selected');
else
    img = imread(strcat(pathname, filename));
    dimension = numel(size(img));
      if(dimension == 3)
          handles.rgb_img = img;
          handles.rgb_img_set = 1;
          handles.gray_img = rgb2gray(handles.rgb_img);
          handles.gray_img_set = 1;
          imshow(img, 'Parent', handles.axes1);  %figure(handles.output), imshow(img);
      elseif(dimension == 2)
          handles.rgb_img_set = 0;
          handles.gray_img = img;
          handles.gray_img_set = 1;
          figure(handles.output), imshow(img);
      else
          errordlg('Image dimension invalid');
      end
  end
guidata(handles.output, handles);




% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)

global model
global filename
%%displaying message till the process is finished
set(handles.text_edit, 'String', 'Processing ...')
%%loading the classifier
model = load('classifier.mat', 'classifier', 'net', 'imageSize', 'featureLayer');
%% sample: process and get the features of the new sample
newImage = imread(fullfile(filename)); %reading the new sample from the path
%%%preprocessing the new sample so it can fit in the classifier
newImageProcessed = augmentedImageDatastore(model.imageSize, ...
                                   newImage, 'ColorPreprocessing', 'gray2rgb');
%%%get the features from the new samples
newImageFeatures = activations(model.net, ...
    newImageProcessed, model.featureLayer, 'MiniBatchSize', 32, 'OutputAs', 'columns');

newImagePredictLabels = predict(model.classifier, newImageFeatures, 'ObservationsIn', 'columns');% get the predicted labels
%% display the predicted label:
 % set(handles.text_edit, 'String', strcat({'image belongs to class: '},   {char(newImagePredictLabels)}) )
set(handles.text_edit, 'String', newImagePredictLabels )

% strcat({'image belongs to class: ', newImagePredictLabels}))
% sprintf('the loaded image belongs to : %s class.', newImagePredictLabels)
% global newImagePredictLabels



function text_edit_Callback(hObject, eventdata, handles)
% hObject    handle to text_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of text_edit as text
%        str2double(get(hObject,'String')) returns contents of text_edit as a double
set(handles.text_edit, 'String', 'testing')

% --- Executes during object creation, after setting all properties.
function text_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
