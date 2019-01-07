%% Test Hilbert map generation
clc; clear all;

%% Generate a map
params = Param_TINYRANDOMFOREST;
num_samples = 81;
map = create_random_map(4, 4, 10, 10, 0.4);
% load map;

%% 
% 
% % res = 0.5;
% % [X, Y] = meshgrid(res:res:(map.XWorldLimits(2)-res), res:res:(map.YWorldLimits(2)-res));
% % X = X(:);
% % Y= Y(:);
% % xy = [X, Y];
% 
% X = rand(num_samples, 1) * 2 + 1;
% Y = rand(num_samples, 1) * 2 + 1;
% xy = [X(:), Y(:)];
% 
% y = double(map.getOccupancy(xy));
% zero_mask = y < 1;
% y(zero_mask) = -1;
% 
% wt = learn_hilbert_map(params, map, xy, y);
% plot_hilbertmap(params, wt, map, xy)

%% Benchmark on number of achor points

% resolution = 1:5:80;
% num_trials = 50;
% calc_time = zeros(size(resolution, 2), num_trials);
% num_anchorpoints = zeros(size(resolution));
% for j = 1:num_trials
%     for i = 1:size(resolution, 2)
%         params.hilbertmap.resolution = resolution(i);
%         X = rand(num_samples, 1) * 2 + 1;
%         Y = rand(num_samples, 1) * 2 + 1;
%         xy = [X(:), Y(:)];
% 
%         y = double(map.getOccupancy(xy));
%         zero_mask = y < 1;
%         y(zero_mask) = -1;
%         [wt, time] = learn_hilbert_map(params, map, xy, y);
%         calc_time(i, j) = time;
%         num_anchorpoints(i) = size(wt, 1);
%     end
% end
% figure(1);
% mean_calc_time = mean(calc_time, 2);
% stdev_calc_time = std(calc_time, 0, 2);
% errorbar(num_anchorpoints, mean_calc_time, stdev_calc_time, 'ob-');
% title('Regression time vs number of anchor points');
% xlabel('Number of Anchor Points'); ylabel('Training Time [s]');

%% Benchmark on number of samples
% num_samples_set = 1:20:500;
% num_trials = 50;
% calc_time = zeros(size(num_samples_set, 2), num_trials);
% for j = 1:num_trials
%     for i = 1:size(num_samples_set, 2)
%         num_samples = num_samples_set(i);
%         X = rand(num_samples, 1) * 2 + 1;
%         Y = rand(num_samples, 1) * 2 + 1;
%         xy = [X(:), Y(:)];
% 
%         y = double(map.getOccupancy(xy));
%         zero_mask = y < 1;
%         y(zero_mask) = -1;
%         [wt, time] = learn_hilbert_map(params, map, xy, y);
%         calc_time(i, j) = time;
% 
%     end
% end
% mean_calc_time = mean(calc_time, 2);
% stdev_calc_time = std(calc_time, 0, 2);
% 
% errorbar(num_samples_set', mean_calc_time, stdev_calc_time, 'ob-');
% title('Regression time vs number of samples');
% xlabel('Number of Samples'); ylabel('Training Time [s]');

%% Benchmark on Kernel Calculation
% params.hilbertmap.kernel = 'threshold';
% resolution = 1:5:80;
% calc_time = zeros(size(resolution, 2), 1);
% num_anchorpoints = zeros(size(resolution));
% for i = 1:size(resolution, 2)
%     params.hilbertmap.resolution = resolution(i);
%     X = rand(num_samples, 1) * 2 + 1;
%     Y = rand(num_samples, 1) * 2 + 1;
%     xy = [X(:), Y(:)];
%     tic;
%     phi_x = kernelFeatures(params, xy, map, params.hilbertmap.kernel);
%     calc_time(i) = toc; 
%     num_anchorpoints(i) = size(phi_x, 1);
% end
% 
% figure(1);
% plot(num_anchorpoints, calc_time, 'ob-'); hold on;
% 
% params.hilbertmap.kernel = 'sparse';
% resolution = 1:5:80;
% calc_time = zeros(size(resolution, 2), 1);
% num_anchorpoints = zeros(size(resolution));
% for i = 1:size(resolution, 2)
%     params.hilbertmap.resolution = resolution(i);
%     X = rand(num_samples, 1) * 2 + 1;
%     Y = rand(num_samples, 1) * 2 + 1;
%     xy = [X(:), Y(:)];
%     tic;
%     phi_x = kernelFeatures(params, xy, map, params.hilbertmap.kernel);
%     calc_time(i) = toc; 
%     num_anchorpoints(i) = size(phi_x, 1);
% end
% 
% figure(1);
% plot(num_anchorpoints, calc_time, 'or-'); hold on;
% 
% params.hilbertmap.kernel = 'rbf';
% resolution = 1:5:80;
% calc_time = zeros(size(resolution, 2), 1);
% num_anchorpoints = zeros(size(resolution));
% for i = 1:size(resolution, 2)
%     params.hilbertmap.resolution = resolution(i);
%     X = rand(num_samples, 1) * 2 + 1;
%     Y = rand(num_samples, 1) * 2 + 1;
%     xy = [X(:), Y(:)];
%     tic;
%     phi_x = kernelFeatures(params, xy, map, params.hilbertmap.kernel);
%     calc_time(i) = toc; 
%     num_anchorpoints(i) = size(phi_x, 1);
% end
% 
% figure(1);
% plot(num_anchorpoints, calc_time, 'oc-'); hold on;
% 
% title('kernel calc time vs number of anchor points');
% xlabel('Number of Anchor Points'); ylabel('Training Time [s]');
% legend({'threshold', 'sparse', 'rbf'})

%% Benchmark on momentum methods
% resolution = 1:5:80;
% num_trials = 1;
% calc_time = zeros(size(resolution, 2), num_trials);
% num_anchorpoints = zeros(size(resolution));
% % params.hilbertmap.momentum = 0.0;
% for j = 1:num_trials
%     for i = 1:size(resolution, 2)
% %         params.hilbertmap.resolution = resolution(i);
%         X = rand(num_samples, 1) * 2 + 1;
%         Y = rand(num_samples, 1) * 2 + 1;
%         xy = [X(:), Y(:)];
% 
%         y = double(map.getOccupancy(xy));
%         zero_mask = y < 1;
%         y(zero_mask) = -1;
%         [wt, time] = learn_hilbert_map(params, map, xy, y);
%         calc_time(i, j) = time;
%         num_anchorpoints(i) = size(wt, 1);
%     end
% end
% figure(1);
% mean_calc_time = mean(calc_time, 2);
% stdev_calc_time = std(calc_time, 0, 2);
% errorbar(num_anchorpoints, mean_calc_time, stdev_calc_time, 'ob-'); hold on;
% % params.hilbertmap.momentum = 0.0;
% params.hilbertmap.momentum = 0.9;
% for j = 1:num_trials
%     for i = 1:size(resolution, 2)
%         params.hilbertmap.resolution = resolution(i);
%         X = rand(num_samples, 1) * 2 + 1;
%         Y = rand(num_samples, 1) * 2 + 1;
%         xy = [X(:), Y(:)];
% 
%         y = double(map.getOccupancy(xy));
%         zero_mask = y < 1;
%         y(zero_mask) = -1;
%         [wt, time] = learn_hilbert_map(params, map, xy, y);
%         calc_time(i, j) = time;
%         num_anchorpoints(i) = size(wt, 1);
%     end
% end
% figure(1);
% mean_calc_time = mean(calc_time, 2);
% stdev_calc_time = std(calc_time, 0, 2);
% errorbar(num_anchorpoints, mean_calc_time, stdev_calc_time, 'or-'); hold on;
% title('Regression time vs number of anchor points');
% xlabel('Number of Anchor Points'); ylabel('Training Time [s]');
% legend('SGD', 'Momentum');

%% Bench mark on weight histogram
clc; close all;
figure('name', 'Navigator', 'NumberTitle', 'off', 'Position', [100 800 400 400]);
figure('name', 'Optimizer', 'NumberTitle', 'off', 'Position', [1900 800 400 400]);
figure('name', 'Hilbert Map', 'NumberTitle', 'off', 'Position', [600 800 1200 400]);

params = Param_TINYRANDOMFOREST;
num_obstacles = 50;
num_samples = 81;

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
params.hilbertmap.pattern = 'radial';
hilbertmap_radial = learn_hilbert_map(params, occupancymap, hilbertmap);

subplot(1, 2, 1);
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

subplot(1, 2, 2);
params.hilbertmap.pattern = 'radial';
map = render_hilbertmap(params, hilbertmap_radial.wt, binmap);
imagesc(binmap.XWorldLimits, fliplr(binmap.YWorldLimits), flipud(map'));
set(gca, 'Ydir', 'normal'); hold on;

if ~isempty(xy)
    plot(xy((y > 0), 1), xy((y > 0), 2), 'xr'); hold on;
    plot(xy((y < 0), 1), xy((y < 0), 2), 'xb'); hold on;
end

colormap(gca, 'jet');
colorbar('Ticks',[]);
title('Radial Pattern');
xlabel('X [meters]'); ylabel('Y [meters]');
xticks(1:binmap.XWorldLimits(2)); yticks(1:binmap.YWorldLimits(2));