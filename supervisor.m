%% Setup & loading
clear all; close all;
% Parameterss
writerObj = VideoWriter('myVideo.avi');
writerObj.FrameRate = 10;
open(writerObj);

% Get the Global map
% params = Param_RANDOMFOREST;
parameterfile = Param_INTEL;

gen_observations(parameterfile);

close(writerObj);