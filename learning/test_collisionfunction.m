%%
clc; close all;

params = Param_TINYRANDOMFOREST;
num_obstacles = 1;
num_samples = 120;

beta = [6.0, 6.5, 7.0, 7.5, 8.0];
N = size(test_resolution, 2)+1;

image_mse = [];
params.hilbertmap.render_resolution = 40;

%%
figure('name', 'Prediction Results', 'NumberTitle', 'off', 'Position', [600 800 1200 400]);

occupancymap = struct('localmap', [], ... % Locally observed map
                      'incrementmap', [], ... % Global observed map
                      'truemap', []); % True binary occupancy map

hilbertmap = struct('enable', params.hilbertmap.enable, ...
                        'wt', [], ...
                        'xy', [], ...
                        'y', []);

map = create_random_map(4, 4, 10, num_obstacles, 1.0);
map = robotics.BinaryOccupancyGrid(4, 4, 10);
setOccupancy(map, [2, 2], 1);
inflate(map, 1.0);

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



ground_truth_v = ground_truth(:);

hilbertmap.xy = xy;
hilbertmap.y = y;
hilbertmap.wt = [];
params.hilbertmap.resolution = 10;
params.hilbertmap.radius = 0.4;
hilbertmap_grid = learn_hilbert_map(params, occupancymap, hilbertmap);
params.hilbertmap.pattern = 'grid';
map = render_hilbertmap(params, hilbertmap_grid.wt, binmap);
row = zeros(6, 160);
subplot(2, 2, 1);
hmap = map;
imagesc(binmap.XWorldLimits, fliplr(binmap.YWorldLimits), hmap');
colormap(gca, 'jet');
colorbar('Ticks', [0.0, 0.5, 1.0]);
title('Ground Truth');
xlabel('X [meters]'); ylabel('Y [meters]');
xticks(1:binmap.XWorldLimits(2)); yticks(1:binmap.YWorldLimits(2));
caxis([0.0 1.0])
row(1, :) = map(:, 80);



%% Sigmoid
subplot(2, 2, 2);

map_sigmoid = sigmoid(map, 7.0);
row(2, :) = map_sigmoid(:, 80);
imagesc(binmap.XWorldLimits, fliplr(binmap.YWorldLimits), flipud(map_sigmoid'));

set(gca, 'Ydir', 'normal'); hold on;

if ~isempty(xy)
    plot(xy((y > 0), 1), xy((y > 0), 2), 'xr'); hold on;
    plot(xy((y < 0), 1), xy((y < 0), 2), 'xb'); hold on;
end

colormap(gca, 'jet');
colorbar('Ticks', [0.0, 0.5, 1.0]);
caxis([0.0 1.0])
title('Sigmoid 7.0');
xlabel('X [meters]'); ylabel('Y [meters]');
xticks(1:binmap.XWorldLimits(2)); yticks(1:binmap.YWorldLimits(2));

%% Logodds
subplot(2, 2, 3);

map_sigmoid = logodds(map);

row(3, :) = map_sigmoid(:, 80);
imagesc(binmap.XWorldLimits, fliplr(binmap.YWorldLimits), flipud(map_sigmoid'));

set(gca, 'Ydir', 'normal'); hold on;

if ~isempty(xy)
    plot(xy((y > 0), 1), xy((y > 0), 2), 'xr'); hold on;
    plot(xy((y < 0), 1), xy((y < 0), 2), 'xb'); hold on;
end

colormap(gca, 'jet');
colorbar('Ticks', [0.0, 0.5, 1.0]);
caxis([0.0 1.0]);
title('Log Odds');
xlabel('X [meters]'); ylabel('Y [meters]');
xticks(1:binmap.XWorldLimits(2)); yticks(1:binmap.YWorldLimits(2));

%% Power
subplot(2, 2, 4);

map_sigmoid = powerthree(map);

row(4, :) = map_sigmoid(:, 80);
imagesc(binmap.XWorldLimits, fliplr(binmap.YWorldLimits), flipud(map_sigmoid'));

set(gca, 'Ydir', 'normal'); hold on;

if ~isempty(xy)
    plot(xy((y > 0), 1), xy((y > 0), 2), 'xr'); hold on;
    plot(xy((y < 0), 1), xy((y < 0), 2), 'xb'); hold on;
end

colormap(gca, 'jet');
colorbar('Ticks', [0.0, 0.5, 1.0]);
caxis([0.0 1.0])
title('Powers');
xlabel('X [meters]'); ylabel('Y [meters]');
xticks(1:binmap.XWorldLimits(2)); yticks(1:binmap.YWorldLimits(2));


%%

figure(100);
plot(row(1, :)); hold on;
plot(row(2, :)); hold on;
plot(row(3, :)); hold on;
plot(row(4, :)); hold on;
% ylim([0.0, 1.0]);
legend('Occupancy Prob', 'Sigmoid 6.0', 'Log Odds', 'Power');


function y = sigmoid(x, beta)
    x = x - 0.5;
    y = 1./(1 + exp(-beta * x)); % Sigmoid
%     y = 4 * x.^3 + 0.5;
end

function y = powerthree(x)
    x = x - 0.5;
    y = 4 .* x.^3 + 0.5;
end

function y = logodds(x)
    epsilon = 0.01;
    nominator = 1/(max(log(1./(epsilon)), abs(log(epsilon./(1 + epsilon)))));
    y = 0.5 .*nominator.*log((x+epsilon)./(1 - (x-epsilon)))+0.5 ;

end