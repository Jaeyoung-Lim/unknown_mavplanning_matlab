function dH = getEntropyGradient(param, x_query, map, hilbertmap)
    wt = hilbertmap.wt;
    p = occupancyProb(param, hilbertmap.wt, x_query, map);
    
    dphi = diff_kernelFeatures(param, x_query, map, param.hilbertmap.kernel);
    dp = p*(1-p)*wt'*dphi;

    dHdp = log((1-p)/p);
    dH = dHdp * dp;
end