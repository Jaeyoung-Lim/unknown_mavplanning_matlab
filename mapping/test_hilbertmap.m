%% Test Hilbert map generation
clc; clear all;

%% Generate a map
params = Param_RANDOMFOREST;

map = create_random_map(10, 10, 10, 50);

get_hilbert_map(map)