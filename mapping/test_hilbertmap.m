%% Test Hilbert map generation
clc; clear all;

%% Generate a map
params = Param_RANDOMFOREST;

map = create_random_map(4, 4, 10, 10, 0.4);

hilbert_map = get_hilbert_map(map);