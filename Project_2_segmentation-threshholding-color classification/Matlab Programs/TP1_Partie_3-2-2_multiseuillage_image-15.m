%%%  PARTIE III:
%%%%%% 2/  multi-seuillage -> image 15.jpg
%%
clear all; close all; clc;
%%  1)
im_org = imread('images/15.jpg'); figure, imshow(im_org);
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
%% 5)  affichage avec scatter:
%%Transformer les matrices en vecteurs:
reshaped_R = reshape(R, [], 1);     reshaped_G = reshape(G, [], 1);     reshaped_B = reshape(B, [], 1); 
%%Affichage 
subplot(1, 3, 1); scatter(reshaped_R, reshaped_G); xlabel('R');    ylabel('G'); title('R / G');grid on;
subplot(1, 3, 2); scatter(reshaped_R, reshaped_B); xlabel('R');    ylabel('B'); title('R / B');grid on;
subplot(1, 3, 3); scatter(reshaped_G, reshaped_B); xlabel('G');    ylabel('B'); title('G / B');grid on;
%% 7) Equations des droites:
%%Extraction manuelle des points du graph:
X = [29, 7;  201, 187] ;       Y = [17, 8;  136, 201];
figure, scatter(reshaped_R, reshaped_B); xlabel('X');    ylabel('Y'); title('R / B'); hold on ; grid on;

%%Affichage direct, sont passer par les équations:
plot( [X(1,1), X(2,1)], [Y(1,1), Y(2,1)] , 'm-', 'LineWidth', 3);
plot( [X(1,2), X(2,2)], [Y(1,2), Y(2,2)] , 'g-', 'LineWidth', 3); 

%%% les equations des droites :
%%droite superieur:
poly_1 = polyfit( X(:, 1), Y(:, 1), 1);  x = linspace(0, 255);  y = polyval(poly_1, x);  plot(x, y, 'm', 'LineWidth', 3);
%%droite du milieu:
poly_2 = polyfit( X(:, 2), Y(:, 2), 1);  x = linspace(0, 255);  y = polyval(poly_2, x);  plot(x, y, 'g', 'LineWidth', 3);
hold off;
%% 8) 
%%On essaye toutes les combinaisons pour trouver la meilleure segmentation.

figure, 
cond_11 = B > (poly_1(1) * R + poly_1(2));     subplot(3, 3, 1); imshow((cond_11 )); title('cond-11')
cond_21 = B > (poly_2(1) * R + poly_2(2));     subplot(3, 3, 2); imshow((cond_21 )); title('cond-21')
%%%
cond_12 = G > (poly_1(1) * R + poly_1(2));     subplot(3, 3, 4); imshow((cond_12 )); title('cond-12')
cond_22 = G > (poly_2(1) * R + poly_2(2));     subplot(3, 3, 5); imshow((cond_22 )); title('cond-22')
%%%
cond_13 = B > (poly_1(1) * G + poly_1(2));     subplot(3, 3, 7); imshow((cond_13 )); title('cond-13')
cond_23 = B > (poly_2(1) * G + poly_2(2));     subplot(3, 3, 8); imshow((cond_23 )); title('cond-23')

%%%% utiliser la masque cond_11:
im2 = im;
im2(:, :, 1) = double(im(:, :, 1)) .* cond_21;
im2(:, :, 2) = double(im(:, :, 2)) .* cond_21;
im2(:, :, 3) = double(im(:, :, 3)) .* cond_21;
%%%% utiliser la masque cond_31:
im3 = im;
im3(:, :, 1) = double(im(:, :, 1)) .* cond_12;
im3(:, :, 2) = double(im(:, :, 2)) .* cond_12;
im3(:, :, 3) = double(im(:, :, 3)) .* cond_12;
%%%% affichage des resultats des 2 masques:
figure, imshowpair(im2, im3, 'montage'); title('cond-21..........................cond-12');












