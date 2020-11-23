%%% methode d'interpolation sous reconnaissance de formes:
function out = rec_form_inter(im_CFA_uint8, selecteur)
% si on oublie de caster l'argument input avant de l'injecter dans la fonction au debut,
%cette etape le fait. Transformer l'image de départ en double c'est pour ne pas avoir de problème de calcule:
    im_cfa = double(im_CFA_uint8);
    %extraie la Longueur , Largeur et nombre de bandes/canales de couleur:
    [H, W, k] = size(im_CFA_uint8);
    %créer cer variable pour ne pas ce tramper de bande dans les calcules:
    R = 1;  G=2;    B=3;
    %initier à zeros la variable qui servira d'image de stocage de
    %calcules:
    im_resultat_3 = zeros(H, W, k);
    %selecteur = 4: pour le seleceur afin de  choisir le case 4 du switch de green_ge()   
    green_band = green_gen(im_cfa, selecteur);  
    %%
    for i=2:H-1
       for j=2:W-1

    %%%%%%%%%%%% pair:
           if(mod(i, 2) == 0 && mod(j, 2) == 0)  %%%pair/pair -----------------------------
                   % R7 / B7        
                  im_resultat_3(i, j, R) = ( im_cfa(i - 1, j)+ im_cfa(i + 1, j)) / 2;
                  im_resultat_3(i, j, B) = ( im_cfa(i , j - 1)+ im_cfa(i , j + 1)) / 2;
                  im_resultat_3(i, j, G) =  im_cfa(i, j);
           elseif(mod(i, 2) == 0 && mod(j, 2) == 1) %%pair/impair---   
                   % G8 /R8                                  
                  im_resultat_3(i, j, R) = ( im_cfa(i - 1, j-1)+ im_cfa(i - 1, j+1) + im_cfa(i+1 , j-1)+ im_cfa(i+1, j+1)) / 4;  
                  im_resultat_3(i, j, B) = im_cfa(i , j);
                  im_resultat_3(i, j, G) = green_band(i, j);

    %%%%%%%%%%  impair:
           elseif(mod(i, 2) == 1 && mod(j, 2) == 0)     %%%impair/pair-------------------------------------
                  %G12 / B12                             
                  im_resultat_3(i, j, B) = ( im_cfa(i - 1, j-1)+ im_cfa(i - 1, j+1) + im_cfa(i+1 , j-1)+ im_cfa(i+1, j+1)) / 4;
                  im_resultat_3(i, j, R) = im_cfa(i , j);
                  im_resultat_3(i, j, G) = green_band(i, j);
           else                                          %%%impair/impair -------------------------Pb B: reglé
                  % R13/B13            
                  im_resultat_3(i, j, B) = ( im_cfa(i - 1, j)+ im_cfa(i + 1, j)) / 2;
                  im_resultat_3(i, j, R) = ( im_cfa(i , j - 1)+ im_cfa(i , j + 1)) / 2;
                  im_resultat_3(i, j, G) =  im_cfa(i, j);              

           end
       end
    end  
        out = uint8(im_resultat_3);
end
