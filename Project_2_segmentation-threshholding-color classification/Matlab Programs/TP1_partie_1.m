clear all; close all; clc
%% Partie I : Initiation � Matlab pour l�image 
%%% 2/ D�claration et initialisation de variables 

% 8) Cr�ation de la matrice 10*10*3:
mx = zeros(10, 10, 3);
mx(5, 5, 1) = 10;
mx(5, 5, 2) = 50;
mx(5, 5, 3) = 150;

%%% 3/ Op�ration entre variables:

x = [1 2 3];    
y = [3 4 5];
z = x .* y; % Cette op�ration nous permet de faire un multiplication �lement par �lement (.*)

%%% 4/ Manipulation des images:
% 1) Lecture de l'image
a = imread('images/cameraman.tif'); 

% 2) Les dimensions et le type de a:
%Name        Size              Bytes   Class    Attributes
% a          256x256           65536  uint8

% 3) Lecture de l'image b:
b = imread('images/autumn.tif');

% 5) L'utilisation de la fonction size pour l'image
size(b)

% 6) Calcul d'algorithme
a2 = log(single(a));

figure, imshow(a) % l'image originale
figure, imshow(a2,[]) % l'image apr�s algorithme

% 8) Calcul de l'expo
a3 = exp(a2);
figure, imshow(a3,[]); % l'image apr�s l'expo

% 11) Le role de chaque fonction

%%% impixelinfo :  elle nous donne le niveau de gris du pixel choisis par le curseur

h = imshow(a);
hp = impixelinfo;

%%% improfile : -> c'est tracer une ligne et prendre le niveau de gris de
%%% chaque pixel qui se trouove sur cette ligne et les tracer sur un graphe
%%% x -> la position x du pixel  | y -> la valeur d niveau du gris de ce
%%% pixel

I = imread('images/cameraman.tif');
x = [19  100];
y = [100 100];

figure,improfile(I,x,y), grid on
figure, imshow(I)
hold on; plot(x, y, 'r')

%%% imdistline -> Elle nous permet de calculer la distance entre deux
%%% points dans une image par unit� de pixel

imshow('images/cameraman.tif');
h = imdistline(gca,[10 100],[10 100]);

%%% 12)

figure(10)
subplot(1, 2, 1), imshow(a)
subplot(1, 2, 2), imshow(b)

%%% 13) Tracage du carr� blanc au mileu de l'image

taille = size(b) % pour calculer la taille de l'image 
Tx = floor(taille(2)/2); % pour calculer le milieu dans l'axe des x
Ty = floor(taille(1)/2); % pour calculer le milieu dans l'axe des y

b(Ty-15:Ty+15, Tx-25:Tx+25 , :) = 255 % mattre les pixels selectionn�e a 255

figure(10)
subplot(1, 2, 1), imshow(a)
subplot(1, 2, 2), imshow(b)

%%% 14) Pour �crire l'image

imwrite(b, 'autumn_modif.tif')





%%