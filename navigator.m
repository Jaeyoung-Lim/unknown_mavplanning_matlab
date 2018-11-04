%% Navigator
% Navigator runs a receding horizon planner between a randomly sampled
% start and goal point that are not unoccupied.
% 
% The implementation is included from the following papers
%   - Oleynikova (2016), Continuous-time trajectory optimization for online UAV replanning

%% Setup & loading
clear all; close all;
% Parameters
parameterfile = Param_RANDOMFOREST;

%%

writerObj = VideoWriter('myVideo.avi');
writerObj.FrameRate = 10;
open(writerObj);

map = generate_environment(parameterfile);

parameterfile.start_point = samplePosfromMap(map);
parameterfile.goal_point = samplePosfromMap(map);

%% Start Navigation

navigate(parameterfile, map, writerObj);

%%
close(writerObj);