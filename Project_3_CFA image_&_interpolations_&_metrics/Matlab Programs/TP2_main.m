%% *****************   TP 2: imagerie spéctrale:   ***********************
%%************************************************* Fait par: MANSORUI et %MOKHTARI.
 
clear all; close all; clc;
%%
%%% Partie 1 Mosaicage:

im = imread('Demosaic5.tif'); 
im_res = bayer(im);
figure, imshowpair(im, im_res, 'montage');title('image originale RGB.                 Image CFA générée');

%% %%%%%%%%%%%%%%%%%   2 demosaicage:    %%%%%%%%%%%%%%%%%%%%%
 %% 1) interpolation bilinéaire:
 
%lire l'image originale:
im_RGB = imread('Demosaic5.tif'); % figure, imshow(im);
%appliqueer l'interpolation bilinéaire sur une image CFA.
im_OUT = bilineaire_interpolation(bayer(im_RGB)); 
%affichage des résultats:
figure, imshowpair(im_RGB, im_OUT, 'montage');  title('image originale RGB.                      image générée par interpolation bilinéaire');
figure, imshowpair(im_RGB(444:544, 317:417, :), im_OUT(444:544, 317:417, :), 'montage'); title('artefacts'); 

%% 2)  fonction interpolation sous constante de teinte:
%lecture de l'image:
im_RGB = imread('Demosaic5.tif'); 
%choisir selecteur = 1, pour avoir la premier 'case' du switch de la fonction green_gen():
selecteur = 1 ;
im_OUT = cste_teinte_interpolation(bayer(im_RGB) , selecteur); 
%affichage des résultats:
figure, imshowpair(im_RGB,im_OUT, 'montage');
title('image originale RGB.                               image générée par interpolation cste de teinte');

%% % 3) partie 1:
%%Interpolation sous preservation de contours avec un noyau (3x3):

%lecture de l'image:
im_RGB = imread('Demosaic5.tif');
% %choisir selecteur = 2, pour avoir le deuxième 'case' du switch de la fonction green_gen():
selecteur = 2 ;
im_OUT = contour_pres_inter(bayer(im_RGB) , selecteur); 
%affichage des résultats:
figure, imshowpair(im_RGB,im_OUT, 'montage');title('image originale RGB.                             image générée par interpolation préservation contour');
figure, imshowpair(im_RGB(444:544, 317:417, :), im_OUT(444:544, 317:417, :), 'montage'); title('artefacts: Aliasing'); 

%% % 3) partie 2:
%%Interpolation sous preservation de contours avec un noyau (5x5):

%lecture de l'image:
im_RGB = imread('Demosaic5.tif');
% %choisir selecteur = 2, pour avoir le deuxième 'case' du switch de la fonction green_gen():
selecteur = 3 ;
im_OUT = contour_pres_inter(bayer(im_RGB) , selecteur); 
%affichage des résultats:
figure, imshowpair(im_RGB,im_OUT, 'montage');title('image originale RGB.                             image générée par interpolation préservation contour kernel 5x5');
figure, imshowpair(im_RGB(444:544, 317:417, :), im_OUT(444:544, 317:417, :), 'montage'); title('artefacts: Aliasing'); 

%% 4) interpolation bi-lineaire avec un masque:    

%lecture de l'image:
im_RGB = imread('Demosaic5.tif');
%générer l'image CFA:
im_CFA = bayer(im_RGB);
%obtention de l'image interpollée:
im_OUT = bilineaire_conv_interpolation(im_CFA); % l'image qui entre en argument pour la fonction bi_inter , il faut un type double;
%affichage des résultats:
figure, imshowpair(im_RGB,im_OUT, 'montage');title('image originale RGB. / image générée par interpolation bilinéaire avec convolution');
figure, imshowpair(im_RGB(444:544, 317:417, :), im_OUT(444:544, 317:417, :), 'montage'); title('artefacts: Aliasing'); 

%% 5) interpolation par reconnaissance de formes:

%lecture de l'image:
im_RGB = imread('Demosaic5.tif'); 
im_CFA = bayer(im_RGB);
%choisir selecteur = 2, pour avoir le deuxième 'case' du switch de la fonction green_gen():
selecteur = 4;
%appel de la fonction d'interpolation:
im_OUT = rec_form_inter(im_CFA , selecteur); 
%affichage résusltat:
figure, imshowpair(im_RGB,im_OUT, 'montage');title('image originale RGB.        /          interpolation avec reconnaissance de formes');
figure, imshowpair(im_RGB(444:544, 317:417, :), im_OUT(444:544, 317:417, :), 'montage'); title('artefacts: Aliasing'); 


%% PARTIE III: affichage de toutes les images du répértoire

%lecture de l'image:
im_RGB_1 = imread('Demosaic_1.bmp'); 
im_RGB_2 = imread('Demosaic_2.bmp'); 
im_RGB_3 = imread('Demosaic_3.bmp'); 
im_RGB_4 = imread('Demosaic_4.bmp'); 
im_RGB_5 = imread('Demosaic5.tif'); 
%transformer les image rgb en cfa:
im_CFA_1 = bayer(im_RGB_1);
im_CFA_2 = bayer(im_RGB_2);
im_CFA_3 = bayer(im_RGB_3);
im_CFA_4 = bayer(im_RGB_4);
im_CFA_5 = bayer(im_RGB_5);

% %interpolation bilinéaire:
im_OUT_1 = bilineaire_interpolation(im_CFA_1);
im_OUT_2 = bilineaire_interpolation(im_CFA_2);
im_OUT_3 = bilineaire_interpolation(im_CFA_3);
im_OUT_4 = bilineaire_interpolation(im_CFA_4);
im_OUT_5 = bilineaire_interpolation(im_CFA_5);
%affichage:
figure, montage({im_OUT_1, im_OUT_2, im_OUT_3,im_OUT_4 ,im_OUT_5 }); title('interpolation bilinéaire');

%%  interpolation sous constante de teinte:

selecteur = 1 ;
im_OUT_1 = cste_teinte_interpolation(im_CFA_1, selecteur);
im_OUT_2 = cste_teinte_interpolation(im_CFA_2, selecteur);
im_OUT_3 = cste_teinte_interpolation(im_CFA_3, selecteur);
im_OUT_4 = cste_teinte_interpolation(im_CFA_4, selecteur);
im_OUT_5 = cste_teinte_interpolation(im_CFA_5, selecteur);

figure, montage({im_OUT_1, im_OUT_2, im_OUT_3,im_OUT_4 ,im_OUT_5 }); title('interpolation sous constante de teinte');

%% interpolation sous contrainte de préservation des contours: méthode 1 avec noyau 3x3

selecteur = 2 ;
im_OUT_1 = cste_teinte_interpolation(im_CFA_1, selecteur);
im_OUT_2 = cste_teinte_interpolation(im_CFA_2, selecteur);
im_OUT_3 = cste_teinte_interpolation(im_CFA_3, selecteur);
im_OUT_4 = cste_teinte_interpolation(im_CFA_4, selecteur);
im_OUT_5 = cste_teinte_interpolation(im_CFA_5, selecteur);

figure, montage({im_OUT_1, im_OUT_2, im_OUT_3,im_OUT_4 ,im_OUT_5 }); title('interpolation sous contrainte de préservation des contours kernel 3x3');

%%  interpolation sous contrainte de préservation des contours: méthode 2 avec noyau 5x5

selecteur = 3 ;
im_OUT_1 = cste_teinte_interpolation(im_CFA_1, selecteur);
im_OUT_2 = cste_teinte_interpolation(im_CFA_2, selecteur);
im_OUT_3 = cste_teinte_interpolation(im_CFA_3, selecteur);
im_OUT_4 = cste_teinte_interpolation(im_CFA_4, selecteur);
im_OUT_5 = cste_teinte_interpolation(im_CFA_5, selecteur);

figure, montage({im_OUT_1, im_OUT_2, im_OUT_3,im_OUT_4 ,im_OUT_5 }); title('nterpolation sous contrainte de préservation des contours kernel 5x5');

%%  interpolation bilinéaire avec nayau de convolution

im_OUT_1 = bilineaire_conv_interpolation(im_CFA_1);
im_OUT_2 = bilineaire_conv_interpolation(im_CFA_2);
im_OUT_3 = bilineaire_conv_interpolation(im_CFA_3);
im_OUT_4 = bilineaire_conv_interpolation(im_CFA_4);
im_OUT_5 = bilineaire_conv_interpolation(im_CFA_5);

figure, montage({im_OUT_1, im_OUT_2, im_OUT_3,im_OUT_4 ,im_OUT_5 }); title('interpolation bilinéaire avec nayau de convolution');

%%  interpolation sous reconnaissance de formes:

selecteur = 4 ;
im_OUT_1 = rec_form_inter(im_CFA_1, selecteur);
im_OUT_2 = rec_form_inter(im_CFA_2, selecteur);
im_OUT_3 = rec_form_inter(im_CFA_3, selecteur);
im_OUT_4 = rec_form_inter(im_CFA_4, selecteur);
im_OUT_5 = rec_form_inter(im_CFA_5, selecteur);

figure, montage({im_OUT_1, im_OUT_2, im_OUT_3,im_OUT_4 ,im_OUT_5 }); title('interpolation sous reconnaissance de formes');



%% %%%  PARTIE IV: Evaluation Quantitative:
clear all; close all; clc;
%lire image:
im = imread('Demosaic5.tif');  % imread('rgb.png'); % figure, imshow(im);
im_CFA = bayer(im);

%% calcule des temps des méthodes:

tic; out = bilineaire_interpolation(im_CFA);      toc;
tic; out = contour_pres_inter(im_CFA, 3);         toc;
tic; out = cste_teinte_interpolation(im_CFA, 1);  toc;
tic; out = contour_pres_inter(im_CFA, 2);         toc;
tic; out = contour_pres_inter(im_CFA, 3);         toc;
tic; out = bilineaire_conv_interpolation(im_CFA); toc;
tic; out = rec_form_inter(im_CFA, 4);             toc 


%%
% calcule des erreur:
err_glob = mse_global(im, out); %home made function.
err_glob2 = immse(im, out);     %matlab function
err_DE = delta_E_lab(im, out);  
err_local  = mse_local(im, out, [317, 444, 100, 100], false);
%affichage des résultats:
sprintf(' MSE globale: %.2f \nMSE globale methode matlab: %.2f ,\ndelta E: %.2f \nMSE locale: %.2f ', err_glob,  err_glob2,  err_DE, err_local)























