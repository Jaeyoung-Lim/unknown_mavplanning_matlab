function [hilbertmap, time] = learn_hilbert_map(param, binmap, hilbertmap, pose)
if isempty(hilbertmap.wt)
    num_features = param.hilbertmap.resolution^2 * binmap.XWorldLimits(2) * binmap.YWorldLimits(2);
    wt_1 = zeros(num_features, 1);
else
    wt_1 = hilbertmap.wt;
end


if isempty(hilbertmap.xy)
    hilbertmap.wt = wt_1;
    time = 0;
    return;
end


%% Update weights
switch param.mapping
    case 'local'
        hilbertmap = discardObservations(param, hilbertmap, pose); 

        xy = hilbertmap.xy;
        y = hilbertmap.y;
        xy = xy - pose(1:2);
    otherwise
        xy = hilbertmap.xy;
        y = hilbertmap.y;

end

record = [];
iter = 0;
tic;
grad = zeros(size(wt_1));
while true
    [sample_xy, sample_y] = drawObservation(xy, y, param.hilbertmap.num_samples);
    [wt, grad] = updateWeights(param, wt_1, sample_xy, sample_y, binmap, grad);
    record = [record, norm(wt - wt_1)];

    wt_1 = wt;
    iter = iter + 1;
    if iter > param.hilbertmap.max_iteration
        break;
    end
end
hilbertmap.wt = wt;
time = toc;
% plot(vecnorm(record, 2, 1));
fprintf('Training Time: %d\t Number of Samples: %d\t Number of Features: %d\n',time, size(sample_xy, 1), size(wt, 1))

end

function [sample_xy, sample_y] = drawObservation(xy, y, num_samples)
    idx = randi(size(xy, 1), num_samples, 1);
    sample_xy = xy(idx, :);
    sample_y = y(idx);
end