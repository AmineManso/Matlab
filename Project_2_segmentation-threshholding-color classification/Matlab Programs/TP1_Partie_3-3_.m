%% PARTIE III: 
%%%%%%%%% 3/ Classification: %%%%%%%
%%
clear all; close all; clc;
%% 1)
im = (imread('images/Perroquet.tif'));    figure(1), imshow(im); 
%%%3) Pixels de référenes: [R G B]  
p1 = [250, 198, 0];     % jaune 
p2 = [225, 77, 72];     % rouge 
p3 = [87, 142, 152];    % bleu 
p4 = [80 145 41];       % vert
% p4 = [102, 93, 63];     % noir

%%Extraire la taille de l'image pour faire le parcour de la boucle
[w, h, k] = size(im);
%%boucle qui parcour toute l'image:
for n= 1:h
   for m = 1:w   
      p = [im(n, m, 1),   im(n, m, 2),    im(n, m, 3)]; %pixel couleur à la position (n, m)

      d1 =  distance_p(p1, p);  %distance entre pixel donné et le pixel de référene jaune.
      d2 =  distance_p(p2, p);  %distance entre pixel donné et le pixel de référene rouge.
      d3 =  distance_p(p3, p);  %distance entre pixel donné et le pixel de référene bleu.
      d4 =  distance_p(p4, p);  %distance entre pixel donné et le pixel de référene vert.
       
      if min([d1, d2, d3, d4]) == d1  %ou on utilise (d1 < d2 & d1 < d3 & d1 < d4).
          im(n, m, 1)=p1(1);    im(n, m, 2) = p1(2);    im(n, m, 3) = p1(3);
      elseif  min([d1, d2, d3, d4]) == d2  
         im(n, m, 1)=p2(1);    im(n, m, 2) = p2(2);    im(n, m, 3) = p2(3);    
      elseif  min([d1, d2, d3, d4]) == d4  
         im(n, m, 1)=p4(1);    im(n, m, 2) = p4(2);    im(n, m, 3) = p4(3); 
      elseif  min([d1, d2, d3, d4]) == d3  
         im(n, m, 1)=p3(1);    im(n, m, 2) = p3(2);    im(n, m, 3) = p3(3);     
      else
         im(n, m, 1)=255;    im(n, m, 2) = 255;    im(n, m, 3) = 255;
      end
   end
end
%%Affichage du résultat:
figure(2), imshow(im);



%% Même programme de classification, mais pour une image en GRAY SCALE (niveau de gris):

% clear all; close all; clc;
% 
% im = rgb2gray(imread('images/Perroquet.tif'));    figure(1), imshow(im);
% %%% R G B   X Y
% p1 = mean([250, 198, 0]); %, 75, 214];
% p2 = mean([225, 77, 72]); %, 242, 108];
% p3 = mean([87, 142, 152]); %, 122, 220];
% 
% [w, h, k] = size(im);
% for n= 1:h
%    for m = 1:w    
%       p = single(im(n, m));%[im(n, m, 1),   im(n, m, 2),    im(n, m, 3)];
% 
%       d1 =  abs(p1 - p);% distance(p1, p);
%       d2 =  abs(p2 - p); %distance(p2, p);
%       d3 =  abs(p3 - p); %distance(p3, p);
%        
%       if d1 < d2 & d1 < d3  %min([d1, d2, d3]) == d1
% %           im(n, m, 1)=p1(1);    im(n, m, 2) = p1(2);    im(n, m, 3) = p1(3);
%           im(n, m) =0;%    im(n, m, 2) = 0;    im(n, m, 3) = 0;
%       elseif d2 < d1 & d2 < d3 % min([d1, d2, d3]) == d2
% %          im(n, m, 1)=p2(1);    im(n, m, 2) = p2(2);    im(n, m, 3) = p2(3);
%           im(n, m)=100;%    im(n, m, 2) = 100;    im(n, m, 3) = 100;
%       else
% %          im(n, m, 1)=p3(1);    im(n, m, 2) = p3(2);    im(n, m, 3) = p3(3);
%          im(n, m) = 255; %   im(n, m, 2) = 200;    im(n, m, 3) = 200;
%       end
% 
%    end
% end
% 
% figure(2), imshow(im);

