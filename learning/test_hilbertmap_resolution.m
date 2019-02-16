%%
clc; close all;

params = Param_TINYRANDOMFOREST;
num_obstacles = 5;
num_samples = 120;
N = 5;

test_resolution = [50, 10, 5, 1];
test_radius = [0.3, 0.3, 0.3, 1];

%%
figure('name', 'Navigator', 'NumberTitle', 'off', 'Position', [100 800 400 400]);
figure('name', 'Optimizer', 'NumberTitle', 'off', 'Position', [1900 800 400 400]);
figure('name', 'Hilbert Map', 'NumberTitle', 'off', 'Position', [600 800 1200 400]);

occupancymap = struct('localmap', [], ... % Locally observed map
                      'incrementmap', [], ... % Global observed map
                      'truemap', []); % True binary occupancy map

hilbertmap = struct('enable', params.hilbertmap.enable, ...
                        'wt', [], ...
                        'xy', [], ...
                        'y', []);

map = create_random_map(4, 4, 10, num_obstacles, 0.4);
occupancymap.truemap = map;
occupancymap.localmap = initlocalmap(params);
binmap = occupancymap.truemap;

X = rand(num_samples, 1) * 1.0 *map.XWorldLimits(2);
Y = rand(num_samples, 1) * 1.0 *map.YWorldLimits(2);
xy =  [X(:), Y(:)];

y = double(map.getOccupancy(xy));
zero_mask = y < 1;
y(zero_mask) = -1;

hilbertmap.xy = xy;
hilbertmap.y = y;
hilbertmap.wt = [];

params.hilbertmap.pattern = 'grid';
hilbertmap_grid = learn_hilbert_map(params, occupancymap, hilbertmap);

%%
subplot(1, N, 1);
show(occupancymap.truemap);

colorbar('Ticks',[]);
title('Grid Pattern');
xlabel('X [meters]'); ylabel('Y [meters]');
xticks(1:binmap.XWorldLimits(2)); yticks(1:binmap.YWorldLimits(2));

for j = 2:N
    
    hilbertmap.xy = xy;
    hilbertmap.y = y;
    hilbertmap.wt = [];
    params.hilbertmap.resolution = test_resolution(j-1);
    params.hilbertmap.radius = test_radius(j -1);
    hilbertmap_grid = learn_hilbert_map(params, occupancymap, hilbertmap);


    subplot(1, N, j);
    params.hilbertmap.pattern = 'grid';
    map = render_hilbertmap(params, hilbertmap_grid.wt, binmap);
    imagesc(binmap.XWorldLimits, fliplr(binmap.YWorldLimits), flipud(map'));
    set(gca, 'Ydir', 'normal'); hold on;


    if ~isempty(xy)
        plot(xy((y > 0), 1), xy((y > 0), 2), 'xr'); hold on;
        plot(xy((y < 0), 1), xy((y < 0), 2), 'xb'); hold on;
    end

    colormap(gca, 'jet');
    colorbar('Ticks',[]);
    title('Grid Pattern');
    xlabel('X [meters]'); ylabel('Y [meters]');
    xticks(1:binmap.XWorldLimits(2)); yticks(1:binmap.YWorldLimits(2));
end