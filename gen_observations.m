%% Setup & loading
% Parameterss
%TODO: Define camera FOV as a parameter
set_params()
% Get the true map
binmap_true = create_random_map(width_m, height_m, resolution_m, 10, inflation_m);
map_true = robotics.OccupancyGrid(double(binmap_true.occupancyMatrix));
%% Random sample positions inside the map
% Sample position that is free
map_corner = [binmap_true.XWorldLimits(1), binmap_true.YWorldLimits(1)];

while true
    mavPos = rand(1,2)*diag([width_m, height_m])  + map_corner;
     if ~getOccupancy(binmap_true, mavPos)
        break;
     end
 end
% Sample mav yaw
mavYaw = 2* pi()*rand();

%% Raycast observations

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
    hold off;
    
end