function phi_hat = kernelFeatures(x_query, map, option)
    % X : Query point
    % X_data : Sample points
    % Create data from binary occupancy points
    res = 1/map.Resolution;
    [X, Y] = meshgrid(res:res:map.XWorldLimits(2), res:res:map.YWorldLimits(2));
    X = X(:);
    Y= Y(:);
    xy = [X, Y];

   phi_hat = zeros(size(xy, 1), 1);
   
   switch option
       case 'sparse'
           for i = 1:size(xy, 1)     
               phi_hat(i) = kSparse(x_query, xy);
       
           end
       case 'threshold'
           phi_hat = kThreshold(x_query, xy);
   end

end

function k = kSparse(x, x_hat)
    k= 0;
    omega = eye(2); % Omega is positive semi definite
    
    r = sqrt((x-x_hat)*omega*(x-x_hat)');
    
    if r < 1
        k = 2 + cos(2*pi()*r)*(1-r)/3 + sin(2*pi()*r)/(2*pi());
        
    end
end

function k = kThreshold(x, x_hat)
    k= zeros(size(x_hat, 1), 1); 
    rth = 0.5;
    r = vecnorm(x-x_hat, 2, 2);
    
    thr_mask = r < rth;
    
    k(thr_mask) = (rth - r(thr_mask)) / rth;
        
end