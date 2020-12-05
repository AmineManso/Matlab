function varargout = malaria_app(varargin)
% MALARIA_APP MATLAB code for malaria_app.fig
%      MALARIA_APP, by itself, creates a new MALARIA_APP or raises the existing
%      singleton*.
%
%      H = MALARIA_APP returns the handle to a new MALARIA_APP or the handle to
%      the existing singleton*.
%
%      MALARIA_APP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MALARIA_APP.M with the given input arguments.
%
%      MALARIA_APP('Property','Value',...) creates a new MALARIA_APP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before malaria_app_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to malaria_app_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help malaria_app

% Last Modified by GUIDE v2.5 30-Nov-2020 21:53:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @malaria_app_OpeningFcn, ...
                   'gui_OutputFcn',  @malaria_app_OutputFcn, ...
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


% --- Executes just before malaria_app is made visible.
function malaria_app_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to malaria_app (see VARARGIN)

% Choose default command line output for malaria_app
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes malaria_app wait for user response (see UIRESUME)
% uiwait(handles.figure1);
%% trying to load the model only once:
%%my customized init:
global model
global img img2 im_filled im_res
global slider_threshold
model = load('classifier.mat', 'classifier', 'net', 'imageSize', 'featureLayer');
warning off
set(handles.edit1, 'String', 'Waiting ...');
slider_threshold = .8;  set(handles.slider1, 'Value', .8);
set(handles.slider_frame, 'Value', 0);
img = zeros(300, 300, 3);
img2 = zeros(300, 300, 3);
im_res = zeros(300, 300, 3);
im_filled = zeros(300, 300);

set(handles.uitable1,'RowName','Cells:', 'ColumnName',{'Parasite', 'Uninfected'}, 'Data', [0, 0]);
sprintf('initialisation complete !')
%--------------------------------------------------------------------------------------------


% --- Outputs from this function are returned to the command line.
function varargout = malaria_app_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
%--------------------------------------------------------------------------------------------



% --- Executes on button press in Cell.
function Cell_Callback(hObject, eventdata, handles)
% set(findall(handles.panel1, '~property', 'enable'), 'enable', 'on');
% set(findall(handles.panel2, '~property', 'enable'), 'enable', 'off');
set(handles.uipanel1, 'visible', 'on');
set(handles.uipanel2, 'visible', 'off');
%--------------------------------------------------------------------------------------------



% --- Executes on button press in Multi_Cell.
function Multi_Cell_Callback(hObject, eventdata, handles)
% set(findall(handles.panel1, '~property', 'enable'), 'enable', 'off');
% set(findall(handles.panel2, '~property', 'enable'), 'enable', 'on');
set(handles.uipanel1, 'visible', 'off');
set(handles.uipanel2, 'visible', 'on');
%--------------------------------------------------------------------------------------------


% --- Executes on button press in Load_image_multiCell.
function Load_image_multiCell_Callback(hObject, eventdata, handles)
global filename_2 
global img2 im_res im_filled

[filename_2, pathname_2] = uigetfile({'*.jpg;*.png;*.jpeg;*.bmp;*.tif', ...
    '(*.jpg,*jpeg,*.png,*.bmp,*.tif)'}, ...
    'Browse Image');
if filename_2 == 0
    handles.rgb_img = 0;
    handles.rgb_img_set = 0;
    display('no image selected');
else
    img2 = imread(strcat(pathname_2, filename_2));
    dimension = numel(size(img2));
      if(dimension == 3)
          handles.rgb_img = img2;
          handles.rgb_img_set = 1;
          handles.gray_img = rgb2gray(handles.rgb_img);
          handles.gray_img_set = 1;
          imshow(img2, 'Parent', handles.axes2);  %figure(handles.output), imshow(img);
      elseif(dimension == 2)
          handles.rgb_img_set = 0;
          handles.gray_img = img2;
          handles.gray_img_set = 1;
          figure(handles.output), imshow(img2);
      else
          errordlg('Image dimension invalid');
      end
end

guidata(handles.output, handles);

%--------------------------------------------------------------------------------------------


% --- Executes on button press in Predictions.
function Predictions_Callback(hObject, eventdata, handles)
% hObject    handle to Predictions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%
global model
global im_filled
global img2 im_res
set(handles.uitable1, 'Data', [0 0]);
N = 8;
[L , NUM] = bwlabel(im_filled, N);       
%% get the max and the min area + the index:
stats = regionprops('table',L,'Area');
[sorted_areas , idx_m] = sort(stats.Area); [sorted_areas, idx_m];
max_surf = sorted_areas(end); 
average_surf = mean(sorted_areas(1:round(length(sorted_areas) * .8))); % make the average on the first 70% of the areas, so the average won't be affeected with the large areas
%%
ii = 0; jj = 0;
im_res = img2;
for n=1:NUM
       founded_region = double(L == n);
       s = regionprops(founded_region, 'BoundingBox', 'Area');
       cond2 = s.Area / average_surf >= .5; %        cond1 = s.Area / max_surf) >= .3;
       if(cond2)
           roi = s.BoundingBox;
          %% croping:
          im_croped = img2(roi(2):(roi(2)+roi(4)-1), roi(1):(roi(1)+roi(3)-1), :); 
          imshow(im_croped, 'Parent', handles.axes3);
            %% %%%preprocessing the new sample so it can fit in the classifier
                newImageProcessed = augmentedImageDatastore(model.imageSize, ...
                                                   im_croped, 'ColorPreprocessing', 'gray2rgb');
                %%%get the features from the new samples
                newImageFeatures = activations(model.net, ...
                    newImageProcessed, model.featureLayer, 'MiniBatchSize', 32, 'OutputAs', 'columns');
                %% prediction section:
                newImagePredictLabels = predict(model.classifier, newImageFeatures, 'ObservationsIn', 'columns');% get the predicted labels
                %% display the predicted label:
                if(newImagePredictLabels == "Parasite")
                    set(handles.edit_im_croped, 'ForegroundColor', 'r');
                    set(handles.edit_im_croped, 'String', newImagePredictLabels )
                else 
                    set(handles.edit_im_croped, 'ForegroundColor', 'g');
                    set(handles.edit_im_croped, 'String', newImagePredictLabels )
                end
                %%
               pred_label = string(newImagePredictLabels);
                %% display the predicted label on the EditTextBox2:
                if(pred_label  == "Parasite")
                    ii = ii + 1;
                else 
                    jj = jj + 1;
                end

            %% displaying the bounding boxes on the cells:
            im_res = insertShape(im_res, 'Rectangle', s.BoundingBox, 'LineWidth', 2);
            imshow(im_res, 'Parent', handles.axes2);
            %% frame control:
            if(get(handles.slider_frame, 'Value') > 0) 
                pause(get(handles.slider_frame, 'Value'));% sprintf('%d', get(handles.slider_frame, 'Value'))
            end
       end
end

labels = [ii, jj];
set(handles.uitable1,'RowName','Cells:', 'ColumnName',{'Parasite', 'Uninfected'}, 'Data', labels)
% clear img2 im_res im_filled

%--------------------------------------------------------------------------------------------



% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global img2 im_filled
global  slider_threshold
slider_threshold = get(handles.slider1, 'Value');
im_bw = 1 - im2bw(rgb2gray(img2), slider_threshold ); 
%% morphological transformations
se = strel('disk',2);
im_eroded = imerode(im_bw, se); 

% figure, imshow(im_dilated);
%%%%
im_dilated = imdilate(im_eroded, se);
im_filled = imfill(im_dilated);
imshow(im_filled, 'Parent', handles.axes3); 
%--------------------------------------------------------------------------------------------

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



% --- Executes on button press in Load_image.
function Load_image_Callback(hObject, eventdata, handles)
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
%--------------------------------------------------------------------




% --- Executes on button press in Predict.
function Predict_Callback(hObject, eventdata, handles)
global model
global filename

%%displaying message till the process is finished
set(handles.edit1, 'String', 'Processing ...')
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

if(newImagePredictLabels == "Parasite")
    set(handles.edit1, 'ForegroundColor', 'r');
    set(handles.edit1, 'String', newImagePredictLabels )
else 
    set(handles.edit1, 'ForegroundColor', 'g');
    set(handles.edit1, 'String', newImagePredictLabels )
end
%-----------------------------------------------------------------------------------------------------

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


%--------------------------------------------------------------------




% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when entered data in editable cell(s) in uitable1.
function uitable1_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function slider_frame_Callback(hObject, eventdata, handles)
% hObject    handle to slider_frame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider_frame_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_frame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit_im_croped_Callback(hObject, eventdata, handles)
% hObject    handle to edit_im_croped (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_im_croped as text
%        str2double(get(hObject,'String')) returns contents of edit_im_croped as a double


% --- Executes during object creation, after setting all properties.
function edit_im_croped_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_im_croped (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
