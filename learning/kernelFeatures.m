function phi_hat = kernelFeatures(param, x_query, map, option)
    % X : Query point
    % X_data : Sample points
    % Create data from binary occupancy points
    res = 1/(param.hilbertmap.resolution);
    switch param.mapping
        case 'local'
            [X, Y] = meshgrid((-0.5*map.XWorldLimits(2) + res):res:0.5*map.XWorldLimits(2), (- 0.5 * map.YWorldLimits(2)+ res):res:0.5 * map.YWorldLimits(2));
        otherwise
            [X, Y] = meshgrid(res:res:map.XWorldLimits(2), res:res:map.YWorldLimits(2));
    end
    X = X(:);
    Y= Y(:);
    xy = [X, Y];

   phi_hat = zeros(size(xy, 1), 1);
   
   switch option
       case 'rbf'
           phi_hat = kRadial(x_query, xy, param.hilbertmap.radius);
       case 'sparse'
           phi_hat = kSparse(x_query, xy, param.hilbertmap.radius);
       case 'threshold'
           phi_hat = kThreshold(x_query, xy, param.hilbertmap.radius);
   end

end