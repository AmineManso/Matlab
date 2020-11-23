clear all; close all; clc;

im_org = imread('multi_parasites.png'); %imread('parasite_9.jpg');  %
im = imresize(im_org,  [300, 300]); %figure, imshow(im); title('image originale');
im_bw = im2bw(rgb2gray(im), .5); 
figure, imshowpair(im, 1-im_bw, 'montage');  title('image binarisé');

%% morphological transformations
se = strel('disk',3);
im_dilated = imdilate(im_bw, se);
% figure, imshow(im_dilated);
%%%%
im_eroded = 1 - imerode(im_dilated, se); 
% figure, imshowpair( im_eroded, im_dilated, 'montage');     title('image erodé puis dilaté');

%%
N = 8;
[L , NUM] = bwlabel(im_eroded, N);        % figure, imshow(L);
%%%
stats = regionprops('table',L,'Area', 'PixelList');

%% get the max and the min area + the index:
[sorted_areas , idx_m] = sort(stats.Area); [sorted_areas, idx_m];

%% get the coordinates of the largest area: wich is area 51 with 1120 pixels
[y_max, x_max ] = find(L == idx_m(length(sorted_areas)));

%% calculations in hsv space to get the mask:
im_hsv = rgb2hsv(im); 
%%%%%%
mask_1 = im_hsv(:, :, 1) > .07 & im_hsv(:, :, 1) < .1;       mask_10 = double(1 - mask_1);
mask_2 = im_hsv(:, :, 2) > .35 & im_hsv(:, :, 2) < .75;      mask_20 = double(1 - mask_2);
mask_3 = im_hsv(:, :, 3) > .45  & im_hsv(:, :, 3) < .6;      mask_30 = double(mask_3);
%%%%
mask_40 = mask_10 .* mask_20 .* mask_30;

se1 = strel('disk',1);      se2 = strel('disk',7);
im_eroded  = imerode(mask_40, se1); 
im_dilated = imdilate(im_eroded, se2);
im_filled  = imfill(im_dilated, 8, 'holes');


%% plot several infected areas:
average_surf = mean(sorted_areas(1:round(length(sorted_areas) * .5))); % make the average on the first 70% of the areas, so the average won't be affeected with the large areas
max_surf = sorted_areas(length(sorted_areas));
% ratio = average_surf / max_surf;

figure, imshow(im);
for n=1:length(sorted_areas)
    
   cond1 = (sorted_areas(n) / average_surf) >= 2;         % cond2 = (sorted_areas(n) / max_surf) <= ratio; %.5;

   if ( cond1 ) 
       founded_region = double(L == idx_m(n));
       prod_region  = founded_region .* im_filled;
       [y_max, x_max ] = find(prod_region == 1);
       
        if(max(max(prod_region)) == 1) 
          fprintf('******************\nThere is an infection, in sorted_surface with idx: %d\n',n);
          s = regionprops(prod_region, 'BoundingBox'); 
          
          hold on;
          plot_bbox(s.BoundingBox)
          plot(x_max, y_max, 'r.'); title('detection  of infected cells (malaria disease)');
          hold off;
        end
   end
end




















