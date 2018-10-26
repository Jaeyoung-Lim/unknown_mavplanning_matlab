%% Setup & loading
clear all; close all;
% Parameterss
set_params();

writerObj = VideoWriter('myVideo.avi');
writerObj.FrameRate = 10;
open(writerObj);
%% Generate Global Trajectory
% Get the Global map
switch options.map
    case 'randomforest'
        binmap_true = create_random_map(width_m, height_m, resolution_m, numsamples_m, inflation_m);
        
    case 'image'
        binmap_true = create_image_map('/home/jalim/dev/unknown_mavplanning_matlab/data/intelgfs.png');
    otherwise
        print('map generation option is not valid');
end
setOccupancy(binmap_true, vertcat(start_point, goal_point, ...
  start_point+0.05, goal_point+0.05, start_point-0.05, goal_point-0.05), 0);

path = a_star(binmap_true, start_point, goal_point);

%% Random sample pose inside the map
% Sample position and check if it is free
% [mavPose] = sample_pose(binmap_true);

for j = 1:size(path, 1)-1
    position = path(j, :);
    velocity = path(j +1, :) - path(j, :);
    ram = atan2(velocity(2), velocity(1));
    
    mavPose = [position, ram];
    %% Generate Local map
    % Create a partial map based on observation
    map_obs = get_localmap(binmap_true, mavPose);

    %% Plot
    if options.plotting
        plot_summary(binmap_true, map_obs, path, mavPose, writerObj);
    end
end

close(writerObj);