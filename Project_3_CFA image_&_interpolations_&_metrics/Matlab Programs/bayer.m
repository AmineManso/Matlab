
function Image_CFA = bayer(Input_RGB)
%transformer l'image de départ en double pour ne pas avoir de problème de calcule:
    Input_RGB = double(Input_RGB);
    %extraie la Longueur , Largeur et nombre de bandes/canales de couleur:
    [H, W, k] = size(Input_RGB);
    %créer cer variable pour ne pas ce tramper de bande dans les calcules:
    R = 1;  G=2;    B=3;
    %initier à zeros la variable qui servira d'image de stocage de
    %calcules:
    im_resultat = zeros(H, W); 
    %boucle qui fait la transformation de RGB_3D vers CFA_2D:
    for i=1:H
       for j=1:W        
             %%------------------------------------------------partie: pair
           if(mod(i, 2) == 0)
               if(mod(j, 2) == 0) %%pair / pair
                  im_resultat(i, j) = Input_RGB(i, j, G);%G7
               else               %%pair / impair
                  im_resultat(i, j) = Input_RGB(i, j, B);%B8              
               end
           end
               %%--------------------------------------------- partie impaire:
            if(mod(i, 2) == 1)
              if(mod(j, 2) == 0) %%impair / pair
                  im_resultat(i, j) = Input_RGB(i, j, R); %R12
              else              %%impair / impair
                  im_resultat(i, j) = Input_RGB(i, j, G); %G13               
              end   
           end
       end
    end
%convertir le résultat finale en uint8 pour avoir un bon affichage de l'image :
    Image_CFA = uint8(im_resultat);  
end