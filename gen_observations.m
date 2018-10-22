%% Setup & loading
clear all;
close all;
% Parameterss
set_params();

writerObj = VideoWriter('myVideo.avi');
writerObj.FrameRate = 10;
open(writerObj);
%% Generate Global Trajectory
% Get the Global map
binmap_true = create_random_map(width_m, height_m, resolution_m, numsamples_m, inflation_m);

setOccupancy(binmap_true, vertcat(start_point, goal_point, ...
  start_point+0.05, goal_point+0.05, start_point-0.05, goal_point-0.05), 0);

path = a_star(binmap_true, start_point, goal_point);

%% Generate Local map
% Convert map to occupancy grid
map_true = robotics.OccupancyGrid(double(binmap_true.occupancyMatrix), resolution_m);

%% Random sample pose inside the map
% Sample position and check if it is free
% [mavPose] = sample_pose(binmap_true);
if options.plotting
    plot_binmap(binmap_true, path);
end

for j = 1:size(path, 1)-1
    position = path(j, :);
    velocity = path(j +1, :) - path(j, :);
    ram = atan2(velocity(2), velocity(1));
    
    mavPose = [position, ram];
    % Create a partial map based on observation
    map_obs = get_localmap(map_true, mavPose);

    %% Plot
    if options.plotting
%         plot_map(map_true, mavPose, intsectionPts, angles);
        writerObj = plot_partialmap(map_obs, writerObj);
    end
end
close(writerObj);

function plot_binmap(map, path)
    figure(101)
    show(map)
    hold on;
    plot(path(:, 1), path(:, 2));
    hold on;
%     plot(pose(1), pose(2), 'xr','MarkerSize',10);
end

function plot_map(map, pose, intsectionPts, angles)
    figure(1)
    show(map)
    hold on;
    plot(pose(1), pose(2), 'xr','MarkerSize',10)
    hold on;
    plot(intsectionPts(:,1),intsectionPts(:,2) , '*r') % Intersection points
    hold on;
    for i = 1:size(intsectionPts, 1)
        plot([pose(1),intsectionPts(i,1)],...
            [pose(2),intsectionPts(i,2)],'-b') % Plot intersecting rays
    end
    hold off;
end

function [video_obj] = plot_partialmap(map, video_obj)
    figure(107)
    show(map)
    hold on;
    frame = occupancyMatrix(map);
    writeVideo(video_obj, frame);
end