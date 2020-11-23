%%%%% generate a green band from a CFA image input:
function out = green_gen(im_CFA_in, selection)
    im_cfa = double(im_CFA_in);

    switch selection     
        
        case 1 %pour la fonction cste_teinte_interpolation():
                [H, W] = size(im_cfa);
                R = 1;  G=2;    B=3;
                %convertir en double pour éviter des problèmes de calculss
                green_band = double(im_cfa);

                %%% de im_cfa vers un canal vert:
                for i=2:H-1
                   for j=2:W-1
                       %%%%%%%%%%%% pair:
                       if(mod(i, 2) == 0)
                           if(mod(j, 2) == 1)  %%%pair/impair
                               %G8
                              green_band(i, j) = ( im_cfa(i - 1, j)+ im_cfa(i + 1, j) + im_cfa(i , j-1)+ im_cfa(i, j+1)) / 4;
                           end
                       end
                           %%%%%%%%%%  impair:
                      if(mod(i, 2) == 1)
                          if(mod(j, 2) == 0)         %%%impair/pair
                              %G12 
                              green_band(i, j) = ( im_cfa(i - 1, j)+ im_cfa(i + 1, j) + im_cfa(i , j-1)+ im_cfa(i, j+1)) / 4;
                          end   
                      end
                   end
              end 
              %cette étape nous permet de méttre les cases de valeur 0 à 1.ça permet d'éliminer les problémes de division par 0.
                out = (green_band + 1); % double
                               
                
        case 2 %pour la fonction countour_pres_inter() avec un noyau (3x3):
                [H, W] = size(im_cfa);
                R = 1;  G=2;    B=3;
                %convertir en double pour éviter des problèmes de calculss
                green_band = double(im_cfa);

                %%% de im_cfa vers un canal vert:
                for i=2:H-1
                   for j=2:W-1
                       %%%%%%%%%%%% pair:
                       if( (mod(i, 2) == 0 && mod(j, 2) == 1) || (mod(i, 2) == 1 && mod(j, 2) == 0) )  %%% si: pair/impair OR impair/pair                         
                               %G8 ou G12
                               DH = abs(im_cfa(i , j-1) - im_cfa(i, j+1));  
                               DV = abs(im_cfa(i-1 , j) - im_cfa(i + 1, j));
                               if(DH < DV)
                                   green_band(i, j) =  (im_cfa(i , j-1) + im_cfa(i, j+1)) / 2; 
                               elseif(DH > DV)
                                   green_band(i, j) =  (im_cfa(i-1 , j) + im_cfa(i + 1, j)) / 2; 
                               else
                                   green_band(i, j) = ( im_cfa(i - 1, j)+ im_cfa(i + 1, j) + im_cfa(i , j-1)+ im_cfa(i, j+1)) / 4;
                               end
                       end
                   end
                end 
              %cette étape nous permet de méttre les cases de valeur 0 à 1.ça permet d'éliminer les problémes de division par 0.            
                out = (green_band + 1); 
                
          case 3 %pour la fonction countour_pres_inter() avec un noyau plus large (5x5):
                [H, W] = size(im_cfa);
                R = 1;  G=2;    B=3;
                %convertir en double pour éviter des problèmes de calculss
                green_band = double(im_cfa);

                %%% de im_cfa vers un canal vert:
                for i=4:H-3  %we reduce the image because the kernel is wider (5x5)
                   for j=4:W-3
                       %%%%%%%%%%%% pair:
                       if( (mod(i, 2) == 1 && mod(j, 2) == 0) || (mod(i, 2) == 0 && mod(j, 2) == 1) )  %%% si: pair/impair OR impair/pair                         
                               %G14 OR G10
                               DH = abs(im_cfa(i , j-1) - im_cfa(i, j+1)) + abs(im_cfa(i, j) - im_cfa(i, j-2) + im_cfa(i, j) - im_cfa(i, j+2));  
                               DV = abs(im_cfa(i-1 , j) - im_cfa(i+1, j)) + abs(im_cfa(i, j) - im_cfa(i-2, j) + im_cfa(i, j) - im_cfa(i+2, j));
                               if(DH < DV)
                                 green_band(i, j) =  ((im_cfa(i , j-1) + im_cfa(i, j+1)) / 2) +  ((im_cfa(i, j) - im_cfa(i, j-2) + im_cfa(i, j) - im_cfa(i, j+2)) / 4); 
                               elseif(DH > DV)
                                 green_band(i, j) =  ((im_cfa(i-1 , j) + im_cfa(i+1, j)) / 2) +  ((im_cfa(i, j) - im_cfa(i-2, j) + im_cfa(i, j) - im_cfa(i+2, j)) / 4); 
                               else
                                 green_band(i, j) = ( (im_cfa(i - 1, j)+ im_cfa(i + 1, j) + im_cfa(i , j-1)+ im_cfa(i, j+1)) / 4) + ...
                                                      (( (im_cfa(i, j) - im_cfa(i-2, j) + im_cfa(i, j) - im_cfa(i+2, j)) +  (im_cfa(i, j) - im_cfa(i, j-2) + im_cfa(i, j) - im_cfa(i, j+2)) ) / 8);
                               end
                       end
                   end
                end 
                %on ajoute le 1, pour éviter la division sur 0 et avoir des cases NaN(Not a Number)
                out = (green_band + 1); % double  
                
case 4
        [H, W] = size(im_cfa);
        %initier la bande verte:
        green_band = double(im_cfa);
        for i=3:H-2
           for j=3:W-2
               %%%%%%%%%%%% %%% si: pair/impair OR impair/pair 
               if( (mod(i, 2) == 0 && mod(j, 2) == 1) || (mod(i, 2) == 1 && mod(j, 2) == 0) )                          
                       %G8  / G12
                        %les 4 pixels de voisinage du traitement:
                        kernel = [im_cfa(i-1 , j), im_cfa(i , j-1), im_cfa(i, j+1), im_cfa(i + 1, j)];
                        m = mean(kernel);
                        H = kernel > m;
                        L = kernel < m;
                        E = kernel == m;
                        count_H = sum(double(H));
                        count_L = sum(double(L));
                        count_E = sum(double(E));

                        %Si on a 3xH ou 3xL :     %cas: contour -------------------------------------------
                        if((count_H == 3) || (count_L == 3)) 
                           green_band(i, j) = median(kernel); 

                        %Si on a 2xH ou 2xL opposés:  %cas: bande -------------------------------------------
                        elseif(( (H(1) == 1 && H(4) == 1) || (H(2) == 1 && H(3) == 1)) ||( (L(1) == 1 && L(4) == 1) || (L(2) == 1 && L(3) == 1)))                        
                            M = median(kernel); %(sum(kernel) / 4);
                            S = mean([im_cfa(i-2, j+1),  im_cfa(i-1, j+2),  im_cfa(i+1, j-2),  im_cfa(i+2, j-1), ...
                                     im_cfa(i-2, j-1),  im_cfa(i-1, j-2),  im_cfa(i+1, j+2),  im_cfa(i+2, j+1)]) ; 
                            sorted_kernel = sort(kernel, "descend");
                            green_band(i, j) = clip((2*M - S), sorted_kernel(3), sorted_kernel(2)) ;

                            if(count_E == 1 || count_E == 2)
                                green_band(i, j) = median(kernel);
                            end

                        %Si on a 2xH et 2xL :     %cas: coin  -------------------------------------------                                
                        elseif(count_H == 2 && count_L == 2)  

                            %première disposition:
                            if(   (H(3) == 1 && H(4) == 1) ||  (H(1) == 1 && H(2)) )
                                M = median(kernel);
                                S = mean([im_cfa(i-2, j+1),  im_cfa(i-1, j+2),  im_cfa(i+1, j-2),  im_cfa(i+2, j-1)]);
                                sorted_kernel = sort(kernel, "descend");
                                green_band(i, j) = clip((M - ((S - M)/4)), sorted_kernel(3), sorted_kernel(2));

                            %deuxième disposition:
                            elseif((H(1) == 1 && H(3) == 1) ||  (H(2) == 1 && H(4)) )
                                M = median(kernel);
                                S = mean([im_cfa(i-2, j-1),  im_cfa(i-1, j-2),  im_cfa(i+1, j+2),  im_cfa(i+2, j+1)]);
                                sorted_kernel = sort(kernel, "descend");
                                green_band(i, j) = clip((M - ((S - M)/4)), sorted_kernel(3), sorted_kernel(2));   
                            end

                        else %disposition par defaut:
                            green_band(i, j) =  mean([im_cfa(i - 1, j), im_cfa(i + 1, j), im_cfa(i , j-1), im_cfa(i, j+1)]); %[green_band(i, j)]    
                        end
               end
           end
        end 
   %variable de sortie:     
   out = green_band; 
%%  ------------------------------------------------------------------------------
%         case 5  %pour la fonction detection de formes: Test 2
%              
%                 [H, W] = size(im_cfa);
% %                 R = 1;  G=2;    B=3;
%                 %convertir en double pour éviter des problèmes de calculss
%                 green_band = double(im_cfa);
% 
%                 %%% de im_cfa vers un canal vert:
%                 for i=3:H-2
%                    for j=3:W-2
%                        %%%%%%%%%%%% 
%                        if( (mod(i, 2) == 0 && mod(j, 2) == 1) || (mod(i, 2) == 1 && mod(j, 2) == 0) )  %%% si: pair/impair OR impair/pair                         
%                                %G8  / R12
%                                 kernel = [im_cfa(i + 1, j), im_cfa(i , j-1), im_cfa(i, j+1), im_cfa(i-1 , j)];
% 
%                                 m = mean(kernel);
%                                 HL = kernel >= m;
%                                 count_H = sum(double(HL));
%                                 count_L = length(kernel) - count_H;
%                                 if((count_H == 3 && count_L == 1) || (count_H == 1 && count_L == 3))  %cas: contour
%                                    green_band(i, j) = median(kernel); 
% 
%                                 elseif(count_H == 4 || count_L == 4)  %cas: bande                       
%                                     M = (sum(kernel) / 4);
%                                     S = sum([im_cfa(i-2, j+1),  im_cfa(i-1, j+2),  im_cfa(i+1, j-2),  im_cfa(i+2, j-1), ...
%                                              im_cfa(i-2, j-1),  im_cfa(i-1, j-2),  im_cfa(i+1, j+2),  im_cfa(i+2, j+1)]) / 8 ;  
%                                     green_band(i, j) = clip((2*M - S), 0, 255); 
% 
%                                 elseif(count_H == 2 && count_L == 2)  %cas: coin
%                                     M = median(kernel);
%                                     S = sum([im_cfa(i-2, j+1),  im_cfa(i-1, j+2),  im_cfa(i+1, j-2),  im_cfa(i+2, j-1)]) / 4;
%                                     green_band(i, j) = clip((2*M - S), 0, 255); 
% 
%                                 end
%                        end
%                    end
%                 end 
%                 out = green_band+1; % double 
%             
%             
        otherwise
            'No arguments in called function ' 
            out = uint8(ones(size(im_cfa)));
    end
        
end