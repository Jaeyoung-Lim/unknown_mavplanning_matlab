%% Learn Local Goal
% This application learns to predict a intermediate goal where if the map was fully know, a A* algorithm whould have given
% 

%% Setup & loading
clc; clear all; close all;
% Parameters
parameterfile = Param_RANDOMFOREST;

X = [];
T = [];

for i=1:2000
    map = generate_environment(parameterfile);
    parameterfile.start_point = samplePosfromMap(map);
    parameterfile.goal_point = samplePosfromMap(map);

    %% Start Planning and generating goal points
    [Telem, Xelem] = gen_laser2goal(parameterfile, map);
    X = [X, Xelem'];
    T = [T, Telem];
    
    
end

save(X);
save(T);