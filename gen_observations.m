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

switch options.globalplanner
    case 'a_star'
        path = a_star(binmap_true, start_point, goal_point);
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
    map_obs = get_localmap(binmap_true, mavPose);

    %% Plot
    if options.plotting
        plot_binmap(binmap_true, path, mavPose);
%         plot_map(map_true, mavPose, intsectionPts, angles);
        writerObj = plot_localmap(map_obs, writerObj);
        drawnow
    end
end

close(writerObj);

function plot_binmap(map, path, pose)
    set_params();
    
    subplot(1,2,1);
    
    show(map); hold on;
    plot(path(:, 1), path(:, 2)); hold on;
    plot(pose(1), pose(2), 'xr','MarkerSize',10); hold on;
    rectangle('Position',[pose(1)-0.5*width_subm, pose(2)-0.5*height_subm, width_subm, height_subm], 'EdgeColor', 'b');
    hold off;
    
end

function plot_map(map, pose, intsectionPts, angles)    
    show(map);
    hold on;
    plot(pose(1), pose(2), 'xr','MarkerSize',10);
    hold on;
    plot(intsectionPts(:,1),intsectionPts(:,2) , '*r'); % Intersection points
    hold on;
    for i = 1:size(intsectionPts, 1)
        plot([pose(1),intsectionPts(i,1)],...
            [pose(2),intsectionPts(i,2)],'-b') % Plot intersecting rays
    end
    hold off;
end

function [video_obj] = plot_localmap(map, video_obj)
    set_params();
    
    subplot(1,2,2);
    
    show(map); hold on;
    plot(0.5*width_subm, 0.5*height_subm, 'xr','MarkerSize',10); hold off;
    
    image = occupancyMatrix(map);
    frame = image;
    writeVideo(video_obj, frame);
end