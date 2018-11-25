function [map, wt] = get_hilbert_map(param, binmap, xy, y, wt_1)
%% Learn Kernel function from true binary occupancy map

num_features = param.hilbertmap.resolution^2 * binmap.XWorldLimits(2) * binmap.YWorldLimits(2);

if nargin < 5
    wt_1 = zeros(num_features, 1);
end

%% Update weights
record = [];

for i = 1:param.hilbertmap.iteration
    
    wt = updateWeights(param, wt_1, xy, y, binmap);
    record = [record, wt];
    wt_1 = wt;
end

p = render_hilbertmap(param, wt, binmap);

if param.hilbertmap.render
    plot_hilbertmap(p, record, xy, binmap);
end
map = p;

end

function p = render_hilbertmap(param, wt, map)
% Reconstruct the hilbert map
    high_res = param.hilbertmap.render_resolution;
    map_width = map.XWorldLimits(2)* high_res;
    map_height = map.YWorldLimits(2) * high_res;
    p = 0.5*ones(map_width, map_height);
    for i = 1:map_width
        for j = 1:map_height
            x = [i, j] * 1/ high_res;
            p(i, j) = occupancyProb(param, wt, x, map);
        end
    end
end

function plot_hilbertmap(p, record, xy, map)
    %% Visualization
    figure(3);
    plot(vecnorm(record, 2, 1), 'bx-');

    figure(4);
    subplot(1, 2, 2);
    imshow(flipud(p'));
    colormap jet;
    colorbar('Ticks',[]);
    title('Hilbert Map');
    xlabel('X [meters]'); ylabel('Y [meters]');
    xticks(1:4); yticks(1:4);
    subplot(1, 2, 1);
    show(map); hold on;
    plot(xy(:, 1), xy(:, 2), 'xr');

end