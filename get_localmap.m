function [map_obs] = get_localmap(binmap, param, pose)
    %% Initialize
    free_space = []; %Observed Free space in the map
    occupied_space = []; % Observed Occupied space inthe map
    
    %% Convert map to occupancy grid
    % Pad global map so that the submap can exceed the boudaries
    ij_pos = world2grid(binmap, pose(1:2));
    i_width = world2grid(binmap, [0.5*param.localmap.width, binmap.YWorldLimits(2)]);
    j_height = world2grid(binmap, [0.0, binmap.YWorldLimits(2)-0.5*param.localmap.height]);
    binmap = double(binmap.occupancyMatrix);
    binmap = padarray(binmap, [i_width(2), j_height(1)], 'both');
    sub_binmap = binmap(ij_pos(1):(ij_pos(1)+2*i_width(2)), ij_pos(2):(ij_pos(2)+2*j_height(1)));
    map_true = robotics.OccupancyGrid(sub_binmap, param.localmap.resolution);

    % Update observations on local map
    map_obs = robotics.OccupancyGrid(param.localmap.width, param.localmap.height, param.localmap.resolution);
    scan_resolution = min(1/(0.5*param.localmap.width*param.localmap.resolution), (1/0.5*param.localmap.height*param.localmap.resolution));
    
    angles = -param.sensor.fov/2:scan_resolution:param.sensor.fov/2;
    origin = [0.5*param.localmap.width, 0.5*param.localmap.height, pose(3)]; % For Robocentric Coordinates

    intsectionPts = rayIntersection(map_true, origin, angles, param.sensor.maxrange); % Generate rays
            
    for i = 1:1:size(intsectionPts, 1)

        ray_endpoint = intsectionPts(i, :);
        
        if norm(double(isnan(ray_endpoint))) > 0
            
            [~, midpoints] = raycast(map_obs, origin, param.sensor.maxrange, angles(i));
            
            free_space = [free_space; midpoints];
        else
            ray_endpoint(1) = max(min(ray_endpoint(1), map_obs.XWorldLimits(2)), map_obs.XWorldLimits(1));
            ray_endpoint(2) = max(min(ray_endpoint(2), map_obs.YWorldLimits(2)), map_obs.YWorldLimits(1));

            [endpoints, midpoints] = raycast(map_obs, origin(1:2), ray_endpoint);
            
            free_space = [free_space; midpoints];
            occupied_space = [occupied_space; endpoints];
        end
    end
    
    setOccupancy(map_obs, free_space, zeros(size(free_space, 1), 1), 'grid');
    setOccupancy(map_obs, occupied_space, ones(size(occupied_space, 1), 1), 'grid');    
end