    clear all; close all; clc;

outputFolder = fullfile('caltech101'); 
rootFolder = fullfile(outputFolder,  '101_ObjectCategories'); % rootFolder = fullfile('Malaria_Dataset');% for another project.S


%to read 3 specific categories: airplane, ferry, laptop:
categories = {'airplanes', 'Motorbikes'};% categories = {'airplanes', 'ferry', 'laptop'};
imds = imageDatastore(fullfile(rootFolder, categories), 'LabelSource','foldernames');

%to read all the files in the dataset:
% imds = imageDatastore(rootFolder, 'IncludeSubfolders', true, 'LabelSource', 'foldernames');

tab =  countEachLabel(imds);
minSetCount = min(tab{:, 2}); 
%%%reduce all the categories to 67 (the min)
imds = splitEachLabel(imds, minSetCount, 'randomize');
countEachLabel(imds);

%%
airplanes = find(imds.Labels == 'airplanes', 1);
ferry     = find(imds.Labels == 'ferry', 1);
laptop    = find(imds.Labels == 'laptop', 1);

% figure, 
% subplot(2, 2, 1); imshow(readimage(imds, airplanes));
% subplot(2, 2, 2); imshow(readimage(imds, ferry));
% subplot(2, 2, 3); imshow(readimage(imds, laptop));
%%
net = resnet50();
% figure, plot(net);  title('Architecture of ResNet 50');
% set(gca, 'Ylim', [150 170])
%%
net.Layers(1);
net.Layers(end);
%or use:
numel(net.Layers(end).ClassNames);
%%
[trainingSet, testSet] = splitEachLabel(imds, 0.7, 'randomize');
%% get the required size to resnet
imageSize = net.Layers(1).InputSize;
%%  this function has 2 task that can implement. our usage is : to ressize the trainSet to imageSize
augmentedTrainingSet = augmentedImageDatastore(imageSize, ...
                                   trainingSet, 'ColorPreprocessing', 'gray2rgb');
augmentedTestSet = augmentedImageDatastore(imageSize, ...
                                   testSet, 'ColorPreprocessing', 'gray2rgb');

w1 = net.Layers(2).Weights;
w1 = mat2gray(w1);
% figure, montage(w1); title('First conv layer weights');
%% activation on the last layer fc50, to get the features
featureLayer = 'fc1000';
trainingFeatures = activations(net, ...
    augmentedTrainingSet, featureLayer, 'MiniBatchSize', 32, 'OutputAs', 'columns');
%% making the classifier
trainingLables = trainingSet.Labels;
%%retourne une classe entrainé , par defaut c'est des svm
classifier = fitcecoc(trainingFeatures, trainingLables, ...
             'Learner', 'Linear', 'Coding', 'onevsall' , 'ObservationsIn', 'columns');
 %% ****************** saving the model/classifier to reuse it later without retraining: **********************************************
%  save classifier
%  sprintf('saving done!!!')
 %%%% ***********************************************************************************
%% extracting the features from the testSet ----------1

testFeatures = activations(net, ...
    augmentedTestSet, featureLayer, 'MiniBatchSize', 32, 'OutputAs', 'columns');
%%
predictLabels = predict(classifier, testFeatures, 'ObservationsIn', 'columns');% predicted labels
testLables = testSet.Labels; % get the labels that we know to see the rate of the error with confusion matrix
confMat = confusionmat(testLables, predictLabels);

confMat = bsxfun(@rdivide, confMat, sum(confMat, 2)); % we have now a persentage, 1 means 100%
mean(diag(confMat)); % the percentage of accuracy
%% predicting the new sample class

newImage = imread(fullfile('caltech101_external_samples/test102.jpg')); %reading the new sample from the path
%%%preprocessing the new sample so it can fit in the classifier
newImageProcessed = augmentedImageDatastore(imageSize, ...
                                   newImage, 'ColorPreprocessing', 'gray2rgb');
%%%get the features from the new samples
newImageFeatures = activations(net, ...
    newImageProcessed, featureLayer, 'MiniBatchSize', 32, 'OutputAs', 'columns');
%%% predict the new sample outcome with the classifier:
newImagePredictLabels = predict(classifier, newImageFeatures, 'ObservationsIn', 'columns');% get the predicted labels

%% display the predicted label:
sprintf('the loaded image belongs to : %s class.', newImagePredictLabels)



