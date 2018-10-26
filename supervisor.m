%% Setup & loading
clear all; close all;
% Parameterss
writerObj = VideoWriter('myVideo.avi');
writerObj.FrameRate = 10;
open(writerObj);

% Get the Global map
% params = Param_RANDOMFOREST;
parameterfile = Param_RANDOMFOREST;

for i=1:10
    if isempty(parameterfile.start_point)
        randompose = sample_pose(parameterfile.globalmap.width, parameterfile.globalmap.height);
        parameterfile.start_point = randompose(1:2);
    end
    if isempty(parameterfile.goal_point)
        randompose = sample_pose(parameterfile.globalmap.width, parameterfile.globalmap.height);
        parameterfile.goal_point = randompose(1:2);
    end

    gen_observations(parameterfile, writerObj);

end

close(writerObj);