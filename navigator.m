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
num_trials = 2;
num_tests = 3;

Test_planner = {'optimistic', 'true', 'optimistic'};
Test_goalselection = {'frompath', 'frompath', 'random'};


D = zeros(num_tests, num_trials); % Distance traveled
T = zeros(num_tests, num_trials); % Time taken
S = zeros(num_tests, num_trials); % Success Mask
 
parameterfile.start_point = [5.0, 5.0]; 
parameterfile.goal_point = [15.0, 15.0]; 

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

D_mean = zeros(num_tests, 1);
D_stdev = zeros(num_tests, 1);
T_mean = zeros(num_tests, 1);
T_stdev = zeros(num_tests, 1);
S= logical(S);

for k = 1:num_tests
    if sum(S(k, :))>0
        D_mean(k) = mean(D(k, S(k, :)));
        D_stdev(k) = std(D(k, S(k, :)));
        T_mean(k) = mean(T(k, S(k, :)));
        T_stdev(k) = std(T(k, S(k, :)));        
    end
    % Plot messages
    fprintf('--------------------------------------------------\n');
    fprintf('Test case %d: %s , %s\n', k, Test_planner{k}, Test_goalselection{k});
    fprintf('  - Distance Traveled: %d +- %d\n', D_mean(k), D_stdev(k));
    fprintf('  - Time Traveled: %d +- %d\n', T_mean(k), T_stdev(k));
end