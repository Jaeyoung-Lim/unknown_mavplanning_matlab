function [wt, time] = learn_hilbert_map(param, binmap, xy, y, wt_1, pose)
%% Learn Kernel function from true binary occupancy map

num_features = param.hilbertmap.resolution^2 * binmap.XWorldLimits(2) * binmap.YWorldLimits(2);

if nargin < 5 || isempty(wt_1)
    wt_1 = zeros(num_features, 1);
end

%% Update weights
switch param.mapping
    case 'local'
       [xy, y] = discardObservations(param, xy, y, pose); 
       xy = xy - pose(1:2);
end

record = [];
iter = 0;
tic;
grad = zeros(size(wt_1));
while true    
    [wt, grad] = updateWeights(param, wt_1, xy, y, binmap, grad);
    record = [record, norm(wt - wt_1)];
    if norm(wt - wt_1) < 0.5
        break;
    end
    if iter > param.hilbertmap.max_iteration
        break;
    end
    wt_1 = wt;
    iter = iter + 1;
end
time = toc;
% plot(vecnorm(record, 2, 1));
fprintf('Training Time: %d\n',time)

end