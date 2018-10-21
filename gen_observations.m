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
[mavPos, mavYaw] = sample_pose(binmap_true);

%% Raycast observations
maxrange = 20;
angles = [pi/4,-pi/4,0,-pi/8];
robotPose = [4,4,pi/2];
intsectionPts = rayIntersection(map_true,robotPose,angles,maxrange,0.7);
raycast(map_ob
%% Generate a local map


%% Mark unknown space / known space


%% Plot
if options.plotting
    figure(1)
    show(binmap_true);
    hold on;
    plot(mavPos(1), mavPos(2), 'xr','MarkerSize',10)
    hold off;    
    figure(2)
    show(map_true);
    hold on;
    plot(mavPos(1), mavPos(2), 'xr','MarkerSize',10)
    hold on;
    plot(intsectionPts(:,1),intsectionPts(:,2) , '*r') % Intersection points
    hold on;
    plot(robotPose(1),robotPose(2),'ob') % Robot pose
    for i = 1:3
        plot([robotPose(1),intsectionPts(i,1)],...
            [robotPose(2),intsectionPts(i,2)],'-b') % Plot intersecting rays
    end
    plot([robotPose(1),robotPose(1)-6*sin(angles(4))],...
        [robotPose(2),robotPose(2)+6*cos(angles(4))],'-b') % No intersection ray
    hold off;
    figure(3)
    show(map_obs);
end