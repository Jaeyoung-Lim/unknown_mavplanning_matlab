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
num_trials = 1;

D =[]; % Distance traveled
T = []; % Time taken
 
%%

% writerObj = VideoWriter('myVideo.avi');
% writerObj.FrameRate = 10;
% open(writerObj);

parameterfile.start_point = [5.0, 5.0]; 
parameterfile.goal_point = [15.0, 15.0]; 

%% Start Navigation
% for i=1:5
if parameterfile.map_generate
    map = generate_envwithPos(parameterfile, parameterfile.start_point, parameterfile.goal_point);
    save map;
    parameterfile.map_generate = false;
else
    load('map.mat');
end

for i = 1:num_trials
    [time, path, failure] = navigate(parameterfile, map);
    if ~failure
        distance_traveled = pathlength(path);
        D = [D, distance_traveled];
        T = [T, time];
    end

end
% end