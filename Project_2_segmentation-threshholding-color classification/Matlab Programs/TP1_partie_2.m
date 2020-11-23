%% %%%%%%%%    PARTIE II:    %%%%%%%%%%%%%%
%%
clear all; close all; clc;
%% 1) Conversion de l'image de l'espace couleur a l'espace niveau de gris
a = imread('images/Fleur.tif');
[w, h, l] = size(a)
b = zeros(w, h);

for n = 1:w
    for m = 1:h     
        b(n, m) = (a(n, m, 1) + a(n, m, 2) + a(n, m, 3)) / 3;
    end    
end 

figure , imshow(b, [])
imshow(a)

%% 2) Le calcul de les moyennes plus la multiplication par les coefficients
a = imread('images/Fleur.tif');
[w, h, l] = size(a)
b1 = zeros(w, h);

for n = 1:w
    for m = 1:h     
        b1(n, m) = (0.299*a(n, m, 1) + 0.587*a(n, m, 2) + 0.114*a(n, m, 3)) / 3;
    end    
end 

figure , imshow(b1, [])
figure ,imshow(a)
%% 3) Utilisation de la fonction rgb2gray

b2 = rgb2gray(a)
figure, imshow(b2)

%%%%%  on remarque que la fonction rgb2gray conbine les op?rations
%%%%%  pr?c?dents (moyenne pond?r?e)

%% Utilisation de l'espace HSV 

house = imread('images/house.tif');
houseHSV = rgb2hsv(house);
f = 0.5;
newHSV1 = houseHSV(:,:,1)*f;
newHSV2 = houseHSV(:,:,2)*f;
newHSV3 = houseHSV(:,:,3)*f;
subplot(2,2,1);  imshow(houseHSV);  xlabel('originale hsv')
subplot(2,2,2);  imshow(newHSV1);   xlabel('H');
subplot(2,2,3);  imshow(newHSV2);   xlabel('S');
subplot(2,2,4);  imshow(newHSV3);   xlabel('V');
%%
%%%% Pour faire la conversion de l'image dans l'espace LAB
cform = makecform('srgb2lab');
lab = applycform(a,cform);
figure 
imshow(lab, [])

%%
%%%% Pour faire la conversion dans l'espace XYZ
cform = makecform('srgb2xyz');
xyz = applycform(a,cform);
figure 
imshow(xyz, [])

%%
%%%% Pour faire la conversion dans l'espace CMYK
cform = makecform('srgb2cmyk');
cmyk = applycform(a,cform);
figure 
imshow(cmyk, [])









