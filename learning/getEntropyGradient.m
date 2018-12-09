function dH = getEntropyGradient(param, x_query, map, hilbertmap)
    epsilon = 1e-4;
    wt = hilbertmap.wt;
    p = occupancyProb(param, hilbertmap.wt, x_query, map);
    
    dphi = diff_kernelFeatures(param, x_query, map, param.hilbertmap.kernel);
    dp = p*(1-p)*wt'*dphi;
    if p < epsilon
        p = epsilon;
    end
    if p > 1-epsilon
        p = 1-epsilon;
    end
    dHdp = log2((1-p)/p);
    dH = dHdp * dp;
    if isnan(dH)
        disp('wtf');
    end
end