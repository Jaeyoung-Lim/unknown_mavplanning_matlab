%% Learn Local Goal
% This application learns to predict a intermediate goal where if the map was fully know, a A* algorithm whould have given
% 

%% Setup & loading
clc; clear all; close all;
% Parameters
parameterfile = Param_RANDOMFOREST;

for i=1:100
    map = generate_environment(parameterfile);
    parameterfile.start_point = samplePosfromMap(map);
    parameterfile.goal_point = samplePosfromMap(map);

    % map_matrix = double(map.occupancyMatrix);
    % map_matrix = padarray(map_matrix , [3, 3], 1, 'both');
    % map = robotics.BinaryOccupancyGrid(map_matrix,  parameterfile.globalmap.resolution);
    % map_inflate = robotics.BinaryOccupancyGrid(map_matrix,  parameterfile.globalmap.resolution);
    % map_inflate.inflate(0.4);
    % 
    % 
    % parameterfile.start_point = samplePosfromMap(map_inflate);
    % parameterfile.goal_point = samplePosfromMap(map_inflate);

    %% Start Navigation
    gen_laser2goal(parameterfile, map);
end