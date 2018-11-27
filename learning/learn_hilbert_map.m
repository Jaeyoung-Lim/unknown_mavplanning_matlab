function [wt, time] = learn_hilbert_map(param, binmap, xy, y, wt_1, pose)
%% Learn Kernel function from true binary occupancy map

num_features = param.hilbertmap.resolution^2 * binmap.XWorldLimits(2) * binmap.YWorldLimits(2);

if nargin < 5 || isempty(wt_1)
    wt_1 = zeros(num_features, 1);
end

%% Update weights
if param.mapping ==  'local'
   xy = xy - pose(1:2);
end
record = [];
iter = 0;
tic;
while true    
    wt = updateWeights(param, wt_1, xy, y, binmap);
    record = [record, wt];
    if norm(wt - wt_1) < 1
        break;
    end
    if iter > param.hilbertmap.max_iteration
        break;
    end
    wt_1 = wt;
    iter = iter + 1;
end
time = toc;
fprintf('Training Time: %d\n',time)

end