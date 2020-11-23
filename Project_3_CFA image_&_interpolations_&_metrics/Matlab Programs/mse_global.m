%% global MSE (mean squared error):
function Valeur = mse_global(im_org, im_gen)
    %%%convert images from uint8 to double, to get the calculus below right
    im_org = double(im_org);
    im_gen = double(im_gen);
    %déterminer les dimensions des images, qui sont les mêmes 
    [H, W, k] = size(im_org);
    %calculer la différence mise au carrée entre les 3 bandes des images:
    diff_squared  = (im_org - im_gen).^2;
    %sommet toutes les erreurs des pixels et diviser par les dimensions:
    Valeur = sum(sum(sum(diff_squared))) / (W * H * 3); % somme de toutes les bandes
end