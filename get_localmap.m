function [map_obs] = get_localmap(map_true, pose)
    %% Generate a local map
    set_params();
    % Update observations on local map
    map_obs = robotics.OccupancyGrid(width_m, height_m, resolution_m);

    angles = -fov/2:0.01:fov/2;
    intsectionPts = rayIntersection(map_true, pose, angles, maxrange);

    for i = 1:1:size(intsectionPts, 1)

        ray_endpoint = intsectionPts(i, :);
        if norm(double(isnan(ray_endpoint))) > 0
            [~, midpoints] = raycast(map_obs, pose, maxrange, angles(i));
            setOccupancy(map_obs, midpoints, zeros(size(midpoints, 1), 1), 'grid');
        else
            ray_endpoint(1) = max(min(ray_endpoint(1), map_obs.XWorldLimits(2)), map_obs.XWorldLimits(1));
            ray_endpoint(2) = max(min(ray_endpoint(2), map_obs.YWorldLimits(2)), map_obs.YWorldLimits(1));

            [endpoints, midpoints] = raycast(map_obs, pose(1:2), ray_endpoint);

            setOccupancy(map_obs, midpoints, zeros(size(midpoints, 1), 1), 'grid');
            setOccupancy(map_obs, endpoints, ones(size(endpoints, 1), 1), 'grid'); 
        end
    end
end