function [map, wt] = get_hilbert_map(binmap, xy, y, wt_1)
%% Learn Kernel function from true binary occupancy map

if nargin < 4
    wt_1 = zeros(1600, 1);
end

%% Update weights
record = [];
% xy = xy / 10;
for i = 1:100
    
    wt = updateWeights(wt_1, xy, y, binmap);
    record = [record, wt];
    wt_1 = wt;
end

p = render_hilbertmap(wt, binmap);

% plot_hilbertmap(p, record, xy, binmap);
map = p;

end

function p = render_hilbertmap(wt, map)
% Reconstruct the hilbert map
    high_res = 4;
    map_width = map.XWorldLimits(2)*map.Resolution * high_res;
    map_height = map.YWorldLimits(2)*map.Resolution * high_res;
    p = 0.5*ones(map_width, map_height);
    for i = 1:map_width
        for j = 1:map_height
            x = [i, j] * 1/(map.Resolution * high_res);
            p(i, j) = occupancyProb(wt, x, map);
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