function scandata = getLaserScan(map, pose, param)
    scan_resolution = 0.05;
    angles = -param.sensor.fov/2:scan_resolution:param.sensor.fov/2;
    intsectionPts = rayIntersection(map, pose, angles, param.sensor.maxrange); % Generate rays
    nan_mask = isnan(intsectionPts(:,1));
    intsectionPts(nan_mask, :) = param.sensor.maxrange*ones(sum(nan_mask(:, 1)),2);
    
    scandata = vecnorm(intsectionPts - pose(1:2), 2, 2)';
    
end