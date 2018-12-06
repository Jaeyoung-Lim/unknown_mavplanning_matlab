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
% legend({'linear', 'sparse', 'rbf'})

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

%% Benchmark kernel mappings

res = 0.5;
[X, Y] = meshgrid(res:res:(map.XWorldLimits(2)-res), res:res:(map.YWorldLimits(2)-res));
X = X(:);
Y= Y(:);
xy = [X, Y];

X = rand(num_samples, 1) * 2 + 1;
Y = rand(num_samples, 1) * 2 + 1;
xy = [X(:), Y(:)];

y = double(map.getOccupancy(xy));
zero_mask = y < 1;
y(zero_mask) = -1;

wt = learn_hilbert_map(params, map, xy, y);
plot_hilbertmap(params, wt, map, xy)
