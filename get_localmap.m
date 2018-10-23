function [map_obs] = get_localmap(binmap, pose)
    %% Generate a local map
    set_params();
    % Convert map to occupancy grid
    ij_min = world2grid(binmap, pose(1:2) + [-0.5*width_subm, 0.5*height_subm]);
    ij_max = world2grid(binmap, pose(1:2) + [0.5*width_subm, -0.5*height_subm]);
    binmap = double(binmap.occupancyMatrix);
    sub_binmap = binmap(ij_min(1):ij_max(1), ij_min(2):ij_max(2));
    map_true = robotics.OccupancyGrid(sub_binmap, resolution_m);

    % Update observations on local map
    map_obs = robotics.OccupancyGrid(width_subm, height_subm, resolution_m);

    angles = -fov/2:0.01:fov/2;
    origin = [0.5*width_subm, 0.5*height_subm, pose(3)];
    intsectionPts = rayIntersection(map_true, origin, angles, maxrange);
    for i = 1:1:size(intsectionPts, 1)

        ray_endpoint = intsectionPts(i, :);
        
        if norm(double(isnan(ray_endpoint))) > 0
            
            [~, midpoints] = raycast(map_obs, origin, maxrange, angles(i));
            
            if(~isempty(midpoints))
                setOccupancy(map_obs, midpoints, zeros(size(midpoints, 1), 1), 'grid');
            end
        else
            ray_endpoint(1) = max(min(ray_endpoint(1), map_obs.XWorldLimits(2)), map_obs.XWorldLimits(1));
            ray_endpoint(2) = max(min(ray_endpoint(2), map_obs.YWorldLimits(2)), map_obs.YWorldLimits(1));

            [endpoints, midpoints] = raycast(map_obs, origin(1:2), ray_endpoint);
            
            if(~isempty(midpoints))
                setOccupancy(map_obs, midpoints, zeros(size(midpoints, 1), 1), 'grid');
            end
            
            if(~isempty(endpoints))
                setOccupancy(map_obs, endpoints, ones(size(endpoints, 1), 1), 'grid');         
            end
        end
    end
end