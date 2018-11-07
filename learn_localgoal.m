%% Navigator
% Navigator runs a receding horizon planner between a randomly sampled
% start and goal point that are not unoccupied.
% 
% The implementation is included from the following papers
%   - Oleynikova (2016), Continuous-time trajectory optimization for online UAV replanning

%% Setup & loading
clc; clear all; close all;
% Parameters
parameterfile = Param_RANDOMFOREST;

%%

writerObj = VideoWriter('myVideo.avi');
writerObj.FrameRate = 10;
open(writerObj);


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

    gen_laser2goal(parameterfile, map, writerObj);
end
%%
close(writerObj);