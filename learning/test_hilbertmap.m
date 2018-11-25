%% Test Hilbert map generation
clc; clear all;

%% Generate a map
params = Param_TINYRANDOMFOREST;
num_samples = 81;

% map = create_random_map(4, 4, 10, 10, 0.4);
load map;

% res = 1.0;
% [X, Y] = meshgrid(0:res:(map.XWorldLimits(2)), 0:res:(map.YWorldLimits(2)));
% X = X(:);
% Y= Y(:);
% xy = [X, Y];

X = rand(num_samples, 1) * 4;
Y = rand(num_samples, 1) * 4;
xy = [X(:), Y(:)];

y = double(map.getOccupancy(xy));
zero_mask = y < 1;
y(zero_mask) = -1;

hilbert_map = get_hilbert_map(params, map, xy, y);
