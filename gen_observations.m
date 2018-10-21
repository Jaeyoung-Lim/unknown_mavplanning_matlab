%% Setup & loading
% Parameterss
%TODO: Define camera FOV as a parameter
set_params()


%% Generate maps
% Get the true map
binmap_true = create_random_map(width_m, height_m, resolution_m, 10, inflation_m);
% Convert map to occupancy grid
map_true = robotics.OccupancyGrid(double(binmap_true.occupancyMatrix));
% Create a partial map based on observation
map_obs = robotics.OccupancyGrid(width_m, height_m, resolution_m);

%% Random sample pose inside the map
% Sample position and check if it is free
[mavPose] = sample_pose(binmap_true);

%% Raycast observations
angles = (mavPose(3)-fov/2:0.01:mavPose(3)+fov/2)';

intsectionPts = rayIntersection(map_true,mavPose,angles,maxrange);

for i = 1:1:size(intsectionPts, 1)
    ray_endpoint = intsectionPts(i, :);
    if norm(double(isnan(ray_endpoint))) > 0
        ray_endpoint = mavPose(1:2) + [maxrange*cos(angles(i)), maxrange*sin(angles(i))];
    end
    ray_endpoint(1) = max(min(ray_endpoint(1), map_obs.XWorldLimits(2)), map_obs.XWorldLimits(1));
    ray_endpoint(2) = max(min(ray_endpoint(2), map_obs.YWorldLimits(2)), map_obs.YWorldLimits(1));
    
    [endpoints, midpoints] = raycast(map_obs, mavPose(1:2), ray_endpoint);
    %TODO: 
    setOccupancy(map_obs, midpoints, zeros(size(midpoints, 1), 1), 'grid');
    setOccupancy(map_obs, endpoints, ones(size(endpoints, 1), 1), 'grid');
end
%% Generate a local map


%% Mark unknown space / known space


%% Plot
if options.plotting
    figure(1)
    show(binmap_true);
    hold on;
    plot(mavPose(1), mavPose(2), 'xr','MarkerSize',10)
    hold off;    
    figure(2)
    show(map_true);
    hold on;
    plot(mavPose(1), mavPose(2), 'xr','MarkerSize',10)
    hold on;
    plot(intsectionPts(:,1),intsectionPts(:,2) , '*r') % Intersection points
    hold on;
    plot(mavPose(1),mavPose(2),'ob') % Robot pose
    for i = 1:3
        plot([mavPose(1),intsectionPts(i,1)],...
            [mavPose(2),intsectionPts(i,2)],'-b') % Plot intersecting rays
    end
    plot([mavPose(1),mavPose(1)-6*sin(angles(4))],...
        [mavPose(2),mavPose(2)+6*cos(angles(4))],'-b') % No intersection ray
    hold off;
    figure(3)
    show(map_obs);
end