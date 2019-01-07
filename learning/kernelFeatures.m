function phi_hat = kernelFeatures(param, x_query, map, option)
    % X : Query point
    % X_data : Sample points
    % Create data from binary occupancy points
    res = 1/(param.hilbertmap.resolution);
    X = [];
    Y = [];
    % Create anchorpoints
    switch param.hilbertmap.pattern
        case 'grid'
            switch param.mapping
                case 'local'
                    [X, Y] = meshgrid((-0.5*map.XWorldLimits(2) + res):res:0.5*map.XWorldLimits(2), (- 0.5 * map.YWorldLimits(2)+ res):res:0.5 * map.YWorldLimits(2));
                otherwise
                    [X, Y] = meshgrid(res:res:map.XWorldLimits(2), res:res:map.YWorldLimits(2));
            end
        case 'radial'
            switch param.mapping
                case 'local'
                    r = res:res:map.XWorldLimits(2);
                    ang_res = 2*pi() * res / map.XWorldLimits(2);
                    theta = ang_res:ang_res:2*pi();
                    origin = [0, 0];
                    [X, Y] = meshgrid(r.*cos(theta) + origin(1), r.*sin(theta) + origin(2));

                otherwise
                    r = (2*res:2*res:map.XWorldLimits(2));
                    ang_res = 0.5 *2*pi() * res / map.XWorldLimits(2);
                    theta = ang_res:ang_res:2*pi();
                    origin = [0.5*map.XWorldLimits(2), 0.5*map.YWorldLimits(2)];
                    for i = 1:size(r, 2)
                        for j = 1:size(theta,2)
                            X = [X, r(i)*cos(theta(j)) + origin(1)];
                            Y = [Y, r(i)*sin(theta(j)) + origin(2)];
                        end
                    end
            end            
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