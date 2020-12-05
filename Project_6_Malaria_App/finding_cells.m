%%%%%%% Author: Amine MANSOURI,  student at University of Burgundy. 
%%%%%%% LikedIn : Amine MANSOURI.
%%
clear all; close all; clc;
%% load meth 2: load only what we need
model = load('classifier.mat', 'classifier', 'net', 'imageSize', 'featureLayer');
 
%%
im = imread('malaria_external_samples/4.jpg'); 
im_bw = 1 - im2bw(rgb2gray(im), .8); 
% figure, imshowpair(im, im_bw, 'montage');  title('image binarisé');

%% morphological transformations
se = strel('disk',2);
im_eroded = imerode(im_bw, se); 

%%%%
im_dilated = imdilate(im_eroded, se);
im_filled = imfill(im_dilated);
% figure, imshowpair( im_eroded, im_filled, 'montage');     title('image erodé puis dilaté');
%%
N = 8;
[L , NUM] = bwlabel(im_filled, N);        % figure, imshow(L);
%% get the max and the min area + the index:
stats = regionprops('table',L,'Area');
[sorted_areas , idx_m] = sort(stats.Area); [sorted_areas, idx_m];
max_surf = sorted_areas(end); 
average_surf = mean(sorted_areas(1:round(length(sorted_areas) * .8))); % make the average on the first 70% of the areas, so the average won't be affeected with the large areas

%%

labels = [""];
idx = 1;
for n=1:NUM
       founded_region = double(L == n);
       s = regionprops(founded_region, 'BoundingBox', 'Area');

       cond2 = s.Area / average_surf >= .4; %        cond1 = s.Area / max_surf) >= .3;
       if(cond2)
           roi = s.BoundingBox;

          %% croping:
          im_croped = im(roi(2):(roi(2)+roi(4)-1), roi(1):(roi(1)+roi(3)-1), :); 
          figure(20), imshow(im_croped);
            %% %%%preprocessing the new sample so it can fit in the classifier
                newImageProcessed = augmentedImageDatastore(model.imageSize, ...
                                                   im_croped, 'ColorPreprocessing', 'gray2rgb');
                %%%get the features from the new samples
                newImageFeatures = activations(model.net, ...
                    newImageProcessed, model.featureLayer, 'MiniBatchSize', 32, 'OutputAs', 'columns');
            %% prediction section:
            newImagePredictLabels = predict(model.classifier, newImageFeatures, 'ObservationsIn', 'columns');% get the predicted labels
    %         if(char(newImagePredictLabels) == "Parasite" )
               labels(idx) = string(newImagePredictLabels); idx = idx + 1;
    %             'parasite found !!!'
    %             break;       
    %         end
            %% displaying the bounding boxes on the cells:
            im_res = insertShape(im, 'Rectangle', s.BoundingBox, 'LineWidth', 2);
            figure(10), imshow(im_res);
       end
end
labels'