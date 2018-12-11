function arcpoints = getObservationEdge(param, map, pose)
    dl = zeros(2, 1);
    arcpoints = [];
    
    scan_resolution = min(1/(param.sensor.maxrange*param.localmap.resolution), (1/param.localmap.height*param.localmap.resolution));
    angles = -param.sensor.fov/2:scan_resolution:param.sensor.fov/2;
    arcpoints = zeros(size(angles, 2), 2);
    for i = 1:1:size(angles, 2)

        intsectionPts = rayIntersection(map, pose, angles(i), param.sensor.maxrange); % Generate rays
        if isnan(intsectionPts) % No intersecting points inside the map
            endpoints = pose(1:2) + param.sensor.maxrange * [cos(angles(i) + pose(3)), sin(angles(i) + pose(3))];
        else
            [endpoints, ~] = raycast(map, pose(1:2), intsectionPts);
            endpoints = grid2world(map, endpoints);
        end
        if isempty(endpoints)
            disp('wtf');
        end
        arcpoints = [arcpoints; endpoints];
        arcpoints(i, :) = endpoints;
    end
end
