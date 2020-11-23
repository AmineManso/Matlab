%% MSE local: cette fonction fait appel � la fonction mse_global/
function Valeur =  mse_local(im_org, im_out, roi, show_fig)
    %Si nargin(Number of Arguments) est �gale a 3, donc sans affichage:
    if(nargin == 3)
        %choisir la region qui nous interesse(ROI):
        croped_org = im_org(roi(2):(roi(2)+roi(4)), roi(1):(roi(1)+roi(3)), :); 
        croped_gen = im_out(roi(2):(roi(2)+roi(4)), roi(1):(roi(1)+roi(3)), :); 
        %utiliser la fonction calcul�e pr�c�demment:
        Valeur = mse_global(croped_org , croped_gen);
   %Si on veut affich� l'image coup�e, on met show_fig = true:
    elseif(nargin == 4)
        %choisir la region qui nous interesse(ROI):
        croped_org = im_org(roi(2):(roi(2)+roi(4)), roi(1):(roi(1)+roi(3)), :); 
        croped_gen = im_out(roi(2):(roi(2)+roi(4)), roi(1):(roi(1)+roi(3)), :); 
        %utiliser la fonction calcul�e pr�c�demment:
        Valeur = mse_global(croped_org , croped_gen);
        
        if(show_fig == true)
            figure, imshowpair(croped_org, croped_gen, 'montage');        
        end            
    end
end