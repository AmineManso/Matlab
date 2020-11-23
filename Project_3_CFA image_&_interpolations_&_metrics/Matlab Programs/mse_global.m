%% global MSE (mean squared error):
function Valeur = mse_global(im_org, im_gen)
    %%%convert images from uint8 to double, to get the calculus below right
    im_org = double(im_org);
    im_gen = double(im_gen);
    %d�terminer les dimensions des images, qui sont les m�mes 
    [H, W, k] = size(im_org);
    %calculer la diff�rence mise au carr�e entre les 3 bandes des images:
    diff_squared  = (im_org - im_gen).^2;
    %sommet toutes les erreurs des pixels et diviser par les dimensions:
    Valeur = sum(sum(sum(diff_squared))) / (W * H * 3); % somme de toutes les bandes
end