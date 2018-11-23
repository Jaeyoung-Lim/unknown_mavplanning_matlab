%% Test Hilbert map generation
clc; clear all;

%% Generate a map
params = Param_RANDOMFOREST;

% map = create_random_map(4, 4, 10, 10, 0.4);
load map;

% res = 0.5;
% [X, Y] = meshgrid(0:res:(binmap.XWorldLimits(2)), 0:res:(binmap.YWorldLimits(2)));
% X = X(:);
% Y= Y(:);
% xy = [X, Y];
X = rand(81, 1) * 4;
Y = rand(81, 1) * 4;
xy = [X(:), Y(:)];

y = double(map.getOccupancy(xy));
zero_mask = y < 1;
y(zero_mask) = -1;


hilbert_map = get_hilbert_map(map, xy, y);