%% clip function to maintain a value between 2 bounderies:
function out = clip(in, inf, sup)
    
    %si on oublie l'ordre des entrées inf et sup
    sorted = sort([inf, sup]);
    if(in >= sorted(2))
        out = sorted(2);
    elseif(in <= sorted(1))
        out = sorted(1);
    else
        out = in; 
    end
    
end