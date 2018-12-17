function [dH, H] = getEntropyGradient(param, x_query, map, hilbertmap)
    epsilon = 1e-4;
    if isempty(hilbertmap.wt)
        num_features = param.hilbertmap.resolution^2 * map.XWorldLimits(2) * map.YWorldLimits(2);
        wt = zeros(num_features, 1);
    else
        wt = hilbertmap.wt;        
    end
        
    % Calculate derivative of entropy
    [dphi, phi] = diff_kernelFeatures(param, x_query, map, param.hilbertmap.kernel);
    p = 1-1/(1+exp(dot(wt, phi)));
    dp = (-1) * p*(1-p)*wt'*dphi;
    
    if p < epsilon
        p = epsilon;
    end
    if p > 1-epsilon
        p = 1-epsilon;
    end
    dHdp = log2((1-p)/p);
    dH = dHdp * dp;

    % Calculate entropy
    H = - p*log2(p) - (1-p) * log2(1 - p);

end