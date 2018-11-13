%% Navigator
% Navigator runs a receding horizon planner between a randomly sampled
% start and goal point that are not unoccupied.
% 
% The implementation is included from the following papers
%   - Oleynikova (2016), Continuous-time trajectory optimization for online UAV replanning

%% Setup & loading
clear all; close all;

% Parameters
% parameterfile = Param_RANDOMFOREST;
parameterfile = Param_CORRIDOR;

num_trials = 1; % Number of trials for statistics
Test_planner = {'optimistic', 'true', 'optimistic'}; % Configuration for different test sets
Test_goalselection = {'frompath', 'frompath', 'random'};


%% Initialize variables for statistics
num_tests = size(Test_planner, 2);

D = zeros(num_tests, num_trials); % Distance traveled
T = zeros(num_tests, num_trials); % Time taken
S = zeros(num_tests, num_trials); % Success Mask

%% Navigate through environment and store results
for i = 1:num_trials
    for j=1:num_tests
        % Switch test cases
        parameterfile.global_planner = Test_planner{j};
        parameterfile.localgoal = Test_goalselection{j};

        %% Generate Map only once
        if parameterfile.map_generate
            map = generate_envwithPos(parameterfile, parameterfile.start_point, parameterfile.goal_point);
            save map;
            parameterfile.map_generate = false;
        else
            map = load('map.mat', 'map');
            map = map.map;
        end
        %% Start Navigation

        [time, path, failure] = navigate(parameterfile, map);
        S(j, i) = ~failure;
        if ~failure
            distance_traveled = pathlength(path);
            D(j, i) = distance_traveled;
            T(j, i) = time;
        end
    end
    parameterfile.map_generate = true;
end

%% Calculate analytics
calc_analytics(D, T, S);