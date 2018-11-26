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

resolution = 1:5:80;
calc_time = zeros(size(resolution));
num_anchorpoints = zeros(size(resolution));
for i = 1:size(resolution, 2)
    params.hilbertmap.resolution = resolution(i);
    X = rand(num_samples, 1) * 2 + 1;
    Y = rand(num_samples, 1) * 2 + 1;
    xy = [X(:), Y(:)];

    y = double(map.getOccupancy(xy));
    zero_mask = y < 1;
    y(zero_mask) = -1;
    [wt, time] = learn_hilbert_map(params, map, xy, y);
    calc_time(i) = time;
    num_anchorpoints(i) = size(wt, 1);
end
figure(1);
plot(num_anchorpoints, calc_time, 'ob-');
title('Regression time vs number of anchor points');
xlabel('Number of Anchor Points'); ylabel('Training Time [s]');

%% Bench mark on number of samples

% num_samples_set = 1:20:500;
% calc_time = zeros(size(num_samples_set));
% 
% for i = 1:size(num_samples_set, 2)
%     num_samples = num_samples_set(i);
%     X = rand(num_samples, 1) * 2 + 1;
%     Y = rand(num_samples, 1) * 2 + 1;
%     xy = [X(:), Y(:)];
% 
%     y = double(map.getOccupancy(xy));
%     zero_mask = y < 1;
%     y(zero_mask) = -1;
%     [wt, time] = learn_hilbert_map(params, map, xy, y);
%     calc_time(i) = time;
% 
% end
% 
% plot(num_samples_set, calc_time, 'ob-');
% title('Regression time vs number of samples');
% xlabel('Number of Samples'); ylabel('Training Time [s]');