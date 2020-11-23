%% 2 demosaicage:
%%% 1) interpolation bilinéaure:

function Output_RGB = bilineaire_interpolation(Image_CFA)
% si on oublie de caster l'argument input avant de l'injecter dans la fonction au debut,
%cette etape le fait. Transformer l'image de départ en double c'est pour ne pas avoir de problème de calcule:
        Image_CFA = double(Image_CFA);
        %extraie la Longueur , Largeur et nombre de bandes/canales de couleur:
        [H, W] = size(Image_CFA);
        %créer cer variable pour ne pas ce tramper de bande dans les calcules:
        R = 1;  G=2;    B=3;
        %initier à zeros la variable qui servira d'image de stocage de
        %calcules: 
        im_resultat = zeros(size(Image_CFA));
        %boucle qui fait la transformation de CFA_2D vers  RGB_3D:
        for i=2:H-1
           for j=2:W-1
               %%%%%%%%%%%% ------------------------------------------------------partie pair:
               if(mod(i, 2) == 0)
                   if(mod(j, 2) == 0)  %%%pair/pair
                       % R7 / B7
                      im_resultat(i, j, R) = ( Image_CFA(i - 1, j)+ Image_CFA(i + 1, j)) / 2;
                      im_resultat(i, j, B) = ( Image_CFA(i , j - 1)+ Image_CFA(i , j + 1)) / 2;
                      im_resultat(i, j, G) =  Image_CFA(i, j);
                   else % G8 /R8         %%pair/impair
                      im_resultat(i, j, G) = ( Image_CFA(i - 1, j)+ Image_CFA(i + 1, j) + Image_CFA(i , j-1)+ Image_CFA(i, j+1)) / 4;
                      im_resultat(i, j, R) = ( Image_CFA(i - 1, j-1)+ Image_CFA(i - 1, j+1) + Image_CFA(i+1 , j-1)+ Image_CFA(i+1, j+1)) / 4;  
                      im_resultat(i, j, B) = Image_CFA(i, j);
                   end
               end
                   %%%%%%%%%%  --------------------------------------------------partie impair:
                if(mod(i, 2) == 1)
                  if(mod(j, 2) == 0)         %%%impair/pair
                      %G12 / B12 
                      im_resultat(i, j, G) = ( Image_CFA(i - 1, j)+ Image_CFA(i + 1, j) + Image_CFA(i , j-1)+ Image_CFA(i, j+1)) / 4;
                      im_resultat(i, j, B) = ( Image_CFA(i - 1, j-1)+ Image_CFA(i - 1, j+1) + Image_CFA(i+1 , j-1)+ Image_CFA(i+1, j+1)) / 4;
                      im_resultat(i, j, R) = Image_CFA(i, j);
                  else  % R13/B13             %%%impair/impair
                      im_resultat(i, j, B) = ( Image_CFA(i - 1, j)+ Image_CFA(i + 1, j)) / 2;
                      im_resultat(i, j, R) = ( Image_CFA(i , j - 1)+ Image_CFA(i , j + 1)) / 2;
                      im_resultat(i, j, G) = Image_CFA(i, j);
                  end   
               end
           end
        end
        
        %convertir le résultat finale en uint8 pour avoir un bon affichage de l'image :
        Output_RGB = uint8(im_resultat);
end