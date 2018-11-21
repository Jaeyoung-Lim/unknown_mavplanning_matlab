function p = occupancyProb(w, X, map)
    % Probability that y = 1
    p = 1-1/(1+exp(dot(w, kernelFeatures(X, map, 'threshold')))); 

end