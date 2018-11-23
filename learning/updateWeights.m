function wt = updateWeights(param, wt_1, X, Y, map)
    eta = param.hilbertmap.learningrate; % Learning rate
    A = eye(size(10));
    wt = wt_1 - eta * A * grad_negativell(wt_1, X, Y, map, param.hilbertmap.kernel); % A should be inv A
end