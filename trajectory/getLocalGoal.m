function local_goal = getLocalGoal(occupancy_map, curr_pose, path, goal, plan_horizon)

if ~occupancy_map.getOccupancy(goal)
    % Local goal is global goal if global goal is free
    local_goal = goal;
else
    %% Pick Goal from Path
    local_goal = goalfrompath(occupancy_map, path, curr_pose(1:2), plan_horizon);
    %% Pick Random Goal
%     local_goal = samplePosfromMap(occupancy_map);
end


end