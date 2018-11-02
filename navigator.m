%% Setup & loading
clear all; close all;
% Parameters
parameterfile = Param_RANDOMFOREST;

%%

writerObj = VideoWriter('myVideo.avi');
writerObj.FrameRate = 10;
open(writerObj);


for i=1:10
    if isempty(parameterfile.start_point)
        randompose = sample_pose(parameterfile.globalmap.width, parameterfile.globalmap.height);
        parameterfile.start_point = randompose(1:2);
    end
    if isempty(parameterfile.goal_point)
        randompose = sample_pose(parameterfile.globalmap.width, parameterfile.globalmap.height);
        parameterfile.goal_point = randompose(1:2);
    end

    navigate(parameterfile, writerObj);

end

close(writerObj);