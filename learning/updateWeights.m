function wt = updateWeights(wt_1, X, Y, map)
    eta = 0.3; % Learning rate
    A = eye(size(10));
    wt = wt_1 - eta * A * grad_negativell(wt_1, X, Y, map); % A should be inv A
end