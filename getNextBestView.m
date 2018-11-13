function goal = getNextBestView(param, map, pose, global_goal)
    %% Next best view planner from Oleynikova 2017
    num_samples = 10;
    mav_pos = pose(1:2);
    
    getExplorationgain(param, map, pose);
    
    l = zeros(num_samples, 1);
    R = zeros(num_samples, 1);
    for i=1:num_samples
        
        sample_pos = samplePosfromMap(map);
        sample_yaw = atan2(sample_pos(2) - mav_pos(2), sample_pos(1) - mav_pos(1));
        sample_pose = [sample_pos, sample_yaw];
        l(i) = getExplorationgain(param, map, pose);
        dg = norm(global_goal-mav_pos) + r;
        R(i) = we * l(i) + wg * (dg  - norm(global_goal - sample_pos))/dg;
    end
    [~, idx] = min(R);
    goal = sample_pos(idx);

end

function l = getExplorationgain(param, map, pose)
        scan_resolution = min(1/(param.sensor.maxrange*param.localmap.resolution), (1/param.localmap.height*param.localmap.resolution));
        
        angles = -param.sensor.fov/2:20*scan_resolution:param.sensor.fov/2;
        for i = 1:1:size(angles, 1)
            
            [~, midpoints] = raycast(map, pose, param.sensor.max_range, angle);
            l = sum(checkOccupancy(map, midpoints, 'grid') > map.threshold);
        end
end