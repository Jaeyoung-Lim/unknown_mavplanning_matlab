%% Setup & loading
clear all; close all;
% Parameterss
writerObj = VideoWriter('myVideo.avi');
writerObj.FrameRate = 10;
open(writerObj);
%% Generate Global Trajectory
% Get the Global map
params = Param_RANDOMFOREST;

switch params.map_type
    case 'randomforest'
        binmap_true = create_random_map(params.globalmap.width, params.globalmap.height, params.globalmap.resolution, params.globalmap.numsamples, params.globalmap.inflation);
        
    case 'image'
        binmap_true = create_image_map(map_path);
    
    otherwise
        print('map generation option is not valid');
end
setOccupancy(binmap_true, vertcat(params.start_point, params.goal_point, ...
  params.start_point+0.05, params.goal_point+0.05, params.start_point-0.05, params.goal_point-0.05), 0);

switch params.planner
    case 'a_star'
        path = a_star(binmap_true, params.start_point, params.goal_point);
    case 'chomp'
        trajectory = continous_chomp(binmap_true, params.start_point, params.goal_point);
        [~, path] = sample_trajectory(trajectory, 0.1);
end

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
    map_obs = get_localmap(binmap_true, params, mavPose);

    %% Plot
    if params.visualization
        plot_summary(params, binmap_true, map_obs, path, mavPose, writerObj);
    end
end

close(writerObj);