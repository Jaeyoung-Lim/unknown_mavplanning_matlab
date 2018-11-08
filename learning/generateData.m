function [reference_goal, observation_data, global_goal] = generateData(pose, horizon, time_path, path, map, param)

map = robotics.OccupancyGrid(double(map.occupancyMatrix), param.globalmap.resolution);

observation_data = getLaserScan(map, pose, param);
reference_goal = getIntermediateGoal(pose, horizon, time_path, path);

%% TODO: Convert to robocentric frame
global_goal = path(end, :) - pose(1:2);

%% 

end

function scandata = getLaserScan(map, pose, param)
    scan_resolution = 1;
    angles = -param.sensor.fov/2:scan_resolution:param.sensor.fov/2;
    intsectionPts = rayIntersection(map, pose, angles, param.sensor.maxrange); % Generate rays
    nan_mask = isnan(intsectionPts(:,1));
    intsectionPts(nan_mask, :) = param.sensor.maxrange*ones(sum(nan_mask(:, 1)),2);
    
    scandata = vecnorm(intsectionPts - pose(1:2), 2, 2)';
    
end

function goal = getIntermediateGoal(pose, time, time_path, path)
    idx = sum(time_path <= time);
    
    for i = idx:1:size(time_path)
        
        if norm(path(idx, :) - pose(1:2)) > 1
            break;
        end
    end
    goal = path(idx, :);
end