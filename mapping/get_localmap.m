function [occupancymap, map_true, free_space, occupied_space] = get_localmap(map_type, occupancymap, param, pose)
    %% Initialize
    if isempty(occupancymap.incrementmap)
        occupancymap.incrementmap = initlocalmap(param);
    end

    free_space = []; %Observed Free space in the map
    occupied_space = []; % Observed Occupied space inthe map    
    
    binmap = occupancymap.truemap;
    map_obs = occupancymap.incrementmap;
    
    % Always increment map for local observation

    map_true = robotics.OccupancyGrid(double(binmap.occupancyMatrix), param.globalmap.resolution);
    origin = pose;
    
    scan_resolution = min(1/(param.sensor.maxrange*param.localmap.resolution), (1/param.localmap.height*param.localmap.resolution));
    
    angles = -param.sensor.fov/2:scan_resolution:param.sensor.fov/2;

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
    if ~isempty(free_space)
        occupied_mask = checkOccupancy(map_obs, free_space, 'grid') > 0;
        if ~isempty(free_space(~occupied_mask, :))
            setOccupancy(map_obs, free_space(~occupied_mask, :), zeros(size(free_space(~occupied_mask, :), 1), 1), 'grid');
        end
    end
    if ~isempty(occupied_space)
        setOccupancy(map_obs, occupied_space, ones(size(occupied_space, 1), 1), 'grid');
    end
    
    if ~isempty(free_space)
        free_space = grid2world(map_obs,free_space);
    end    
    if ~isempty(occupied_space)
        occupied_space = grid2world(map_obs, occupied_space);
    end
    
    occupancymap.incrementmap = map_obs;
    
    % Update local map if enabled
    switch map_type
        case 'local'
            % Recreate local map
            % Pad global map so that the submap can exceed the boudaries
            ij_pos = world2grid(map_obs, pose(1:2));
            i_width = world2grid(map_obs, [0.5*param.localmap.width, map_obs.YWorldLimits(2)]);
            j_height = world2grid(map_obs, [0.0, map_obs.YWorldLimits(2)-0.5*param.localmap.height + 0.001]); %% This is a hack
            map_obs_values = double(map_obs.occupancyMatrix);
            map_obs_values = padarray(map_obs_values, [i_width(2), j_height(1)], 0.5, 'both');
            submap_obs = map_obs_values(ij_pos(1):(ij_pos(1)+2*i_width(2)-1), ij_pos(2):(ij_pos(2)+2*j_height(1)-1));
            localmap_obs = robotics.OccupancyGrid(submap_obs, param.globalmap.resolution);
        otherwise
            localmap_obs = map_obs;
    end
    
    occupancymap.localmap = localmap_obs;
    
end