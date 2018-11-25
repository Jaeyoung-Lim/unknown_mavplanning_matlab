function p = occupancyProb(param, w, X, map)
    % Probability that y = 1
    p = 1-1/(1+exp(dot(w, kernelFeatures(param, X, map, param.hilbertmap.kernel)))); 

end