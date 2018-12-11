function [hilbertmap, time] = learn_hilbert_map(param, binmap, hilbertmap, pose)
if isempty(hilbertmap.wt)
    num_features = param.hilbertmap.resolution^2 * binmap.XWorldLimits(2) * binmap.YWorldLimits(2);
    wt_1 = zeros(num_features, 1);
else
    wt_1 = hilbertmap.wt;
end


hilbertmap = discardObservations(param, hilbertmap, pose); 

xy = hilbertmap.xy;
y = hilbertmap.y;

%% Update weights
switch param.mapping
    case 'local'
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
    wt_1 = wt;
    iter = iter + 1;
    if iter > param.hilbertmap.max_iteration
        break;
    end
end
hilbertmap.wt = wt;
time = toc;
% plot(vecnorm(record, 2, 1));
fprintf('Training Time: %d\t Number of Samples: %d\t Number of Features: %d\n',time, size(y, 1), size(wt, 1))

end