In this project we use the Deep Learning model ResNet-50 for features extraction and SVM classifier to classify these features, 
in other words, classify the input image.

The programme has 2 modes: 
	-mode 1: to predict if 1 cell is infected(parasite) or not
	-mode 2: apply the same model but for mutliple cells. In this mode we need first to detect the cells individually then we predict their class.
		 The detection of each cell is done by a basic image segmentation (manually).
		 The prediction is done by resnet50 and svm.
		 We have the option to make the program slowwer in order to see the detection of the cells happening.


After downloading the files from my github repository, you need to download the model below.
This is the link to download the model from my google drive:
https://drive.google.com/file/d/14_2UIKfHC1cZugkyKp_4a4RUcMBRFADo/view?usp=sharing