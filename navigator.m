%% Setup & loading
clear all; close all;
% Parameters
parameterfile = Param_RANDOMFOREST;

%%

writerObj = VideoWriter('myVideo.avi');
writerObj.FrameRate = 10;
open(writerObj);

map = generate_environment(parameterfile);

parameterfile.start_point = sample_map(map);
parameterfile.goal_point = sample_map(map);
navigate(parameterfile, map, writerObj);

close(writerObj);