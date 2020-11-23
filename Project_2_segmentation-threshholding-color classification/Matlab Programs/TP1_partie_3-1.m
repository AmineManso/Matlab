%%  PARTIE III : 
%%%%% 1/ on désire isoler la façade de la maison:
%%
clear all; close all; clc
%% 1 
im = imread('images/house.tif');
figure(1)
subplot(1,4,1); imshow(im)
subplot(1,4,2); imshow(im(:, :, 1))
subplot(1,4,3); imshow(im(:, :, 2))
subplot(1,4,4); imshow(im(:, :, 3))

%% 2
im = imread('images/house.tif');
figure(1)
subplot(2,4,1); imshow(im)
subplot(2,4,2); imshow(im(:, :, 1))
subplot(2,4,3); imshow(im(:, :, 2))
subplot(2,4,4); imshow(im(:, :, 3))

%% 3
subplot(2,4,5); imhist(im)
subplot(2,4,6); imhist(im(:, :, 1))
subplot(2,4,7); imhist(im(:, :, 2))
subplot(2,4,8); imhist(im(:, :, 3))

%% 4
masque =im(:,:,1)> 150  & im(:,:,1)<190 & im(:, :,3) < 200 ;
figure, imshow(im)
facade_rouge = uint8(masque).*im;
imshow(facade_rouge)
%% 5
facade_bleue = facade_rouge;
facade_bleue(:, :, 1)= 0;  
facade_bleue(:, :, 2)= 0;   
facade_bleue(:, :, 3) = facade_bleue(:, :, 3); 

figure
imshow(facade_bleue)

%%% l'inverse du premier masque

masque_inverse = 1-masque;
imshow(masque_inverse)

%%% l'image avec la façade bleue

image_sans_facade = uint8(masque_inverse).*im;
figure
imshow(image_sans_facade)

image_avec_facade_bleue = image_sans_facade + facade_bleue;
imshow(image_avec_facade_bleue)

%% 6)  hsv
im = imread('images/house.tif');
im_hsv = rgb2hsv(im);      % figure(1), imshow(im_hsv);
figure,
subplot(1, 2, 1); imshow(im);        title('image RGB');
subplot(1, 2, 2); imshow(im_hsv);    title('image HSV');
%% 7) affichage de l'image couleur + les trois images composantes de HSV:
figure,
subplot(2, 4, 1); imshow(im_hsv);   title('image originale HSV');
subplot(2, 4, 2); imshow(im_hsv(:, :, 1)); title('composante H')
subplot(2, 4, 3); imshow(im_hsv(:, :, 2)); title('composante S')
subplot(2, 4, 4); imshow(im_hsv(:, :, 3)); title('composante V')
%% 8) histogrammes:
subplot(2, 4, 6); imhist(im_hsv(:, : , 1)); title('histogramme de H')
subplot(2, 4, 7); imhist(im_hsv(:, : , 2)); title('histogramme de S')
subplot(2, 4, 8); imhist(im_hsv(:, : , 3)); title('histogramme de V')
%% 11) utiliser la bande H pour un seuillage:
%%% mask 1
im_mask1 = im_hsv(:, :, 1) < 0.075;
im_mask1_1 = double(im_mask1); %nous aide dans les calcules qui suivent. 
figure, imshow(double(im_mask1)); title('seuillage sur bande H');
%% morphological operators
%%%%  erosion:
se = strel('square',2);        
eroded_mask = imerode(im_mask1_1, se);
%%%% dilatation:
se = strel('square',3);        
dilated_mask = imdilate(eroded_mask, se);
figure, imshowpair(eroded_mask, dilated_mask, 'montage'); title('eroded ............  dilated')
%% 13) ----Applying the mask1_1 on hsv image:
im_hsv(:, :, 1) = im_hsv(:, :, 1).* im_mask1_1;
im_hsv(:, :, 2) = im_hsv(:, :, 2).* im_mask1_1;
im_hsv(:, :, 3) = im_hsv(:, :, 3).* im_mask1_1;
figure, imshowpair(im_hsv, hsv2rgb(im_hsv), 'montage'); title('HSV ................. RGB');

%% 14) inclure les hombres et la couleur bleu:
%%% mask 2
im_hsv = rgb2hsv(imread('images/house.tif'));
im_mask2 = im_hsv(:, :, 2) < .32;
im_mask2_1 = double(255 - im_mask2);
figure, imshowpair(double(im_mask2), im_mask2_1, 'montage');
%%%%% mask 3
im_mask3 = im_hsv(:, :, 3) > .75 & im_hsv(:, :, 3) < .9  ;
im_mask3_1 = 255 - im_mask3;
% figure, imshowpair(double(im_mask3), im_mask3_1, 'montage');








