function l = getExplorationgain(param, map, pose)
    %% Calculate exploration gain from view fulstrum
    l = 0; %Exploration gain is a scalar cost
    scan_resolution = min(1/(param.sensor.maxrange*param.localmap.resolution), (1/param.localmap.height*param.localmap.resolution));

    angles = -param.sensor.fov/2:20*scan_resolution:param.sensor.fov/2;
    for i = 1:1:size(angles, 2)

        intsectionPts = rayIntersection(map, pose, angles(i), param.sensor.maxrange); % Generate rays
        if isnan(intsectionPts)
            [~, midpoints] = raycast(map, pose, param.sensor.maxrange, angles(i));
        else
            [~, midpoints] = raycast(map, pose(1:2), intsectionPts);
        end
        if ~isempty(midpoints)
            if ~isempty(checkOccupancy(map, midpoints, 'grid') < 0)
                l = l + sum(checkOccupancy(map, midpoints, 'grid') < 0);
            end
        end
    end
end