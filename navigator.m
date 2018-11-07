%% Navigator
% Navigator runs a receding horizon planner between a randomly sampled
% start and goal point that are not unoccupied.
% 
% The implementation is included from the following papers
%   - Oleynikova (2016), Continuous-time trajectory optimization for online UAV replanning

% Parameters
parameterfile = Param_RANDOMFOREST;
num_trials = 1;
num_tests = 1;


%% Setup & loading
clear all; close all;

D =[]; % Distance traveled
T = []; % Time taken
S = []; % Success Mask
 
parameterfile.start_point = [5.0, 5.0]; 
parameterfile.goal_point = [15.0, 15.0]; 

%% Start Navigation
for j=1:num_tests
    
    
    %% Generate Map only once
    if parameterfile.map_generate
        map = generate_envwithPos(parameterfile, parameterfile.start_point, parameterfile.goal_point);
        save map;
        parameterfile.map_generate = false;
    else
        load('map.mat');
    end
    %% Navigate through environment and store results
    for i = 1:num_trials
        [time, path, failure] = navigate(parameterfile, map);
        S = [S, ~failure];
        if ~failure
            distance_traveled = pathlength(path);
            D = [D, distance_traveled];
            T = [T, time];
        end

    end
end