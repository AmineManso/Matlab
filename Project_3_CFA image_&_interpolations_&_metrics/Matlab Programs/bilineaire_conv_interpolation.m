function out = bilineaire_conv_interpolation(im_CFA_uint8)
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
    %% créer les noyaux de convolutions:
    kernel_G  = [0, 1, 0;  1, 4, 1;  0, 1, 0] ./4;
    kernel_RB = [1, 2, 1;  2, 4, 2;  1, 2, 1] ./4; 
    %% boucles qui générent les 3 bandes de l'image resultante séparémment:
    for ii=2:H-1
        for jj=2:W-1
        %%%%%%%%%%%% pair:--------------------------------------------------------------------
           if(mod(ii, 2) == 0 && mod(jj, 2) == 0)         %%%pair/pair ----------------------
                   % R7 / B7
                  im_resultat_3(ii, jj, G) =  im_cfa(ii, jj);            
           elseif(mod(ii, 2) == 0 && mod(jj, 2) == 1)     %%pair/impair-----------------   
                   % G8 /R8                                  
                  im_resultat_3(ii, jj, B) = im_cfa(ii, jj);                 
        %%%%%%%%%%  impair:--------------------------------------------------------------------
           elseif(mod(ii, 2) == 1 && mod(jj, 2) == 0)     %%%impair/pair-----------------------------------
                  %G12 / B12                                               
                  im_resultat_3(ii, jj, R) = im_cfa(ii, jj);                                   
           else                                          %%%impair/impair ------------------------
                  % R13/B13            
                  im_resultat_3(ii, jj, G) =  im_cfa(ii, jj);             
           end
        end
    end  
    %% calcule de convolution aprés obtention des bandes de couleurs:
    im_resultat_3(:, :, R) = conv2(im_resultat_3(:, :, R), kernel_RB, 'same');
    im_resultat_3(:, :, G) = conv2(im_resultat_3(:, :, G), kernel_G, 'same');
    im_resultat_3(:, :, B) = conv2(im_resultat_3(:, :, B), kernel_RB, 'same');
    %% image de sortie en uint8 pour avoir le bon affichage:
    out = uint8(im_resultat_3);
end