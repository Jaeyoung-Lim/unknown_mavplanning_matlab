function [wt, time, hilbertmap] = learn_hilbert_map(param, binmap, hilbertmap, pose)
if isempty(hilbertmap.wt)
    num_features = param.hilbertmap.resolution^2 * binmap.XWorldLimits(2) * binmap.YWorldLimits(2);
    wt_1 = zeros(num_features, 1);
else
    wt_1 = hilbertmap.wt;
end

if isempty(hilbertmap.xy)
    time = 0;
    wt = wt_1;
    return;
end
%% Learn Kernel function from true binary occupancy map
xy = hilbertmap.xy;
y = hilbertmap.y;


%% Update weights
switch param.mapping
    case 'local'
       hilbertmap = discardObservations(param, hilbertmap, pose); 
       xy = xy - pose(1:2);
end

record = [];
iter = 0;
tic;
grad = zeros(size(wt_1));
while true
    % Sample a subset of samples
    [sample_xy, sample_y] = drawSamples(xy, y, param.hilbertmap.num_samples);
    [wt, grad] = updateWeights(param, wt_1, sample_xy, sample_y, binmap, grad);
    record = [record, norm(wt - wt_1)];
%     if norm(wt - wt_1) < 0.5
%         break;
%     end
    wt_1 = wt;
    iter = iter + 1;
    if iter > param.hilbertmap.max_iteration
        break;
    end
end
time = toc;
figure(4);
plot(vecnorm(record, 2, 1));
fprintf('Training Time: %d\t Number of Features: %d\t Number of Samples: %d\n',time, size(wt, 1), size(xy, 1));

end

function [samples_xy, samples_y] = drawSamples(xy, y, num_samples)
    idx = randi(size(xy, 1), num_samples, 1);
    samples_xy = xy(idx, :);
    samples_y = y(idx);

end