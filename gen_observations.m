%% Setup & loading
clear all;
close all;
% Parameterss
%TODO: Define camera FOV as a parameter
set_params()


%% Generate maps
% Get the true map
binmap_true = create_random_map(width_m, height_m, resolution_m, numsamples_m, inflation_m);
% Convert map to occupancy grid
map_true = robotics.OccupancyGrid(double(binmap_true.occupancyMatrix), resolution_m);
% Create a partial map based on observation
map_obs = robotics.OccupancyGrid(width_m, height_m, resolution_m);

%% Random sample pose inside the map
% Sample position and check if it is free
[mavPose] = sample_pose(binmap_true);

%% Generate a local map

angles = (mavPose(3)-fov/2):0.01:(mavPose(3)+fov/2);
intsectionPts = rayIntersection(map_true,mavPose,angles,maxrange);

for i = 1:1:size(intsectionPts, 1)
    
    ray_endpoint = intsectionPts(i, :);
    if norm(double(isnan(ray_endpoint))) > 0
        ray_endpoint = mavPose(1:2) + [maxrange*cos(angles(i)), maxrange*sin(angles(i))]; 
        ray_endpoint(1) = max(min(ray_endpoint(1), map_obs.XWorldLimits(2)), map_obs.XWorldLimits(1));
        ray_endpoint(2) = max(min(ray_endpoint(2), map_obs.YWorldLimits(2)), map_obs.YWorldLimits(1));

        [endpoints, midpoints] = raycast(map_obs, mavPose(1:2), ray_endpoint);

        setOccupancy(map_obs, midpoints, zeros(size(midpoints, 1), 1), 'grid');
    else
        ray_endpoint(1) = max(min(ray_endpoint(1), map_obs.XWorldLimits(2)), map_obs.XWorldLimits(1));
        ray_endpoint(2) = max(min(ray_endpoint(2), map_obs.YWorldLimits(2)), map_obs.YWorldLimits(1));

        [endpoints, midpoints] = raycast(map_obs, mavPose(1:2), ray_endpoint);

        setOccupancy(map_obs, midpoints, zeros(size(midpoints, 1), 1), 'grid');
        setOccupancy(map_obs, endpoints, ones(size(endpoints, 1), 1), 'grid'); 
    end
end

%% Mark unknown space / known space


%% Plot
if options.plotting
    plot_binmap(binmap_true, mavPose);
    plot_map(map_true, mavPose, intsectionPts, angles);
    plot_partialmap(map_obs);
end

function plot_binmap(map, pose)
    figure('Name', 'True binary occupancy gridmap');
    show(map);
    hold on;
    plot(pose(1), pose(2), 'xr','MarkerSize',10)
    hold off;
end

function plot_map(map, pose, intsectionPts, angles)
    figure('Name', 'True Occupancy gridmap')
    show(map);
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

function plot_partialmap(map)
    figure('Name', 'Observation')
    show(map);
end