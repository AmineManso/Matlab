%%% PARTIE III :
%%%%%%% 2/ multi-seuillage   -> image hand.jpg
clear all; close all; clc;
%%  1)
im_org = imread('images/hand.jpg'); figure, imshow(im_org);
im = imresize(im_org, [200, 200]);  %figure, imshow(im);
R = double(im(:, :, 1));        G =  double(im(:, :, 2));        B =  double(im(:, :, 3));        

%% 2) coefficients de  correlations: 
[r1, p1] = corrcoef(R, G)
[r2, p2] = corrcoef(R, B) % less correlated
[r3, p3] = corrcoef(G, B) % most correlated
%% 3) histogram 2D
subplot(1, 3, 1); histogram2(R, G); xlabel('X');    ylabel('Y'); title('R / G');
subplot(1, 3, 2); histogram2(R, B); xlabel('X');    ylabel('Y'); title('R / B');
subplot(1, 3, 3); histogram2(G, B); xlabel('X');    ylabel('Y'); title('G / B');
%% 4) 
%%%%  remarque : la relation entre l'histogramme et les coeff ==> mentionné
%%%%  dans le rapport.
%% 5)  affichage avec scatter:
%%Transformer les matrices en vecteurs:
reshaped_R = reshape(R, [], 1);     reshaped_G = reshape(G, [], 1);     reshaped_B = reshape(B, [], 1); 
%%Affichage 
subplot(1, 3, 1); scatter(reshaped_R, reshaped_G); xlabel('R');    ylabel('G'); title('R / G');grid on;
subplot(1, 3, 2); scatter(reshaped_R, reshaped_B); xlabel('R');    ylabel('B'); title('R / B');grid on;
subplot(1, 3, 3); scatter(reshaped_G, reshaped_B); xlabel('G');    ylabel('B'); title('G / B');grid on;

%% 6) 
%%%% on peut discerner 3 classe distinctes

%% 7) Equations des droites:
%%%du graph R/B, on a les points (Xij, Yij):
%%% X[x11 , x12, x13; x21 , x22, x33]  ; Y[y11 , y12, y13; y21 , y22, y23]

%%Extraction manuelle des points du graph:
X = [6, 18, 18;  99, 128, 187 ] ;       Y = [44, 6, 6;  170, 112, 91];
figure, scatter(reshaped_R, reshaped_B); xlabel('X');    ylabel('Y'); title('R / B'); hold on ; grid on;

%%Affichage direct, sont passer par les équations:
% plot( [X(1,1), X(2,1)], [Y(1,1), Y(2,1)] , 'm-');   
% plot( [X(1,2), X(2,2)], [Y(1,2), Y(2,2)] , 'g-'); 
% plot( [X(1,3), X(2,3)], [Y(1,3), Y(2,3)] , 'c-');% hold off; 

%%% les equations des droites :
%%droite superieur:
poly_1 = polyfit( X(:, 1), Y(:, 1), 1);  x = linspace(0, 255);  y = polyval(poly_1, x);  plot(x, y, 'm');
%%droite du milieu:
poly_2 = polyfit( X(:, 2), Y(:, 2), 1);  x = linspace(0, 255);  y = polyval(poly_2, x);  plot(x, y, 'g');
%%droite inférieur:
poly_3 = polyfit( X(:, 3), Y(:, 3), 1);  x = linspace(0, 255);  y = polyval(poly_3, x);  plot(x, y, 'c');
hold off;
%% 8) 
%%On essaye toutes les combinaisons pour trouver la meilleure segmentation.

figure, 
cond_11 = B > (poly_1(1) * R + poly_1(2));     subplot(3, 3, 1); imshow((cond_11 )); title('cond-11')
cond_21 = B > (poly_2(1) * R + poly_2(2));     subplot(3, 3, 2); imshow((cond_21 )); title('cond-21')
cond_31 = B > (poly_3(1) * R + poly_3(2));     subplot(3, 3, 3); imshow((cond_31 )); title('cond-31')
%%%
cond_12 = G > (poly_1(1) * R + poly_1(2));     subplot(3, 3, 4); imshow((cond_12 )); title('cond-12')
cond_22 = G > (poly_2(1) * R + poly_2(2));     subplot(3, 3, 5); imshow((cond_22 )); title('cond-22')
cond_32 = G > (poly_3(1) * R + poly_3(2));     subplot(3, 3, 6); imshow((cond_32 )); title('cond-32')
%%%
cond_13 = B > (poly_1(1) * G + poly_1(2));     subplot(3, 3, 7); imshow((cond_13 )); title('cond-13')
cond_23 = B > (poly_2(1) * G + poly_2(2));     subplot(3, 3, 8); imshow((cond_23 )); title('cond-23')
cond_33 = B > (poly_3(1) * G + poly_3(2));     subplot(3, 3, 9); imshow((cond_33 )); title('cond-33')

%%% scatter the upper half of the line:
% R2 = reshape((cond_11 .* R), [], 1);     B2 = reshape((cond_11 .* B), [], 1);
% figure, scatter(R2, B2);grid on;

%%%% utiliser la masque cond_11:
im2 = im;
im2(:, :, 1) = double(im(:, :, 1)) .* cond_11;
im2(:, :, 2) = double(im(:, :, 2)) .* cond_11;
im2(:, :, 3) = double(im(:, :, 3)) .* cond_11;
figure, imshow(im2)
%%%% utiliser la masque cond_31:
im3 = im;
im3(:, :, 1) = double(im(:, :, 1)) .* (1-cond_31);
im3(:, :, 2) = double(im(:, :, 2)) .* (1-cond_31);
im3(:, :, 3) = double(im(:, :, 3)) .* (1-cond_31);
figure, imshow(im3)




