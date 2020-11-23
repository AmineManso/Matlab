
function Valeur = delta_E_lab(im_org, im_gen)
   %initier les bande de l'espace Lab, pour mieu visualiser le code:
   L = 1;  a = 2; b = 3;
   %convertir de l'espace RGB vers Lab:
   im_org_lab = rgb2lab(im_org);
   im_gen_lab = rgb2lab(im_gen);
   %calcule de la distance chromatique:
   delta_E_mat = sqrt( (im_org_lab(:, :, L) -  im_gen_lab(:, :, L)).^2 +...
                       (im_org_lab(:, :, a) -  im_gen_lab(:, :, a)).^2 +...
                       (im_org_lab(:, :, b) -  im_gen_lab(:, :, b)).^2 );
   %sortie de la fonction
   Valeur = mean(mean(delta_E_mat));
end