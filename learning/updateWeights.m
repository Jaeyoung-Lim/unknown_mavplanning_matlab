function [wt, grad_nll] = updateWeights(param, wt_1, X, Y, map, prev_grad_nll)
    eta = param.hilbertmap.learningrate; % Learning rate
    A = eye(size(10));
    grad_nll = grad_negativell(param, wt_1, X, Y, map);
    % SGD with momentum
    wt = wt_1 - (param.hilbertmap.momentum * prev_grad_nll + eta * A * grad_nll); % A should be inv A
end