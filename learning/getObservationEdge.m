function arcpoints = getObservationEdge(param, map, pose)
    dl = zeros(2, 1);
    arcpoints = [];
    
    scan_resolution = min(1/(param.sensor.maxrange*param.localmap.resolution), (1/param.localmap.height*param.localmap.resolution));
    angles = -param.sensor.fov/2:20*scan_resolution:param.sensor.fov/2;
    for i = 1:1:size(angles, 2)

        intsectionPts = rayIntersection(map, pose, angles(i), param.sensor.maxrange); % Generate rays
        if isnan(intsectionPts)
            [endpoints, ~] = raycast(map, pose, param.sensor.maxrange, angles(i));
        else
            [endpoints, ~] = raycast(map, pose(1:2), intsectionPts);
        end
        arcpoints = [arcpoints; endpoints];
    end
    
    if ~isempty(arcpoints)
        arcpoints = grid2world(map, arcpoints);
    end
end
