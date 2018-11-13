function local_goal = getLocalGoal(param, occupancy_map, curr_pose, path, goal)

if ~occupancy_map.getOccupancy(goal)
    % Local goal is global goal if global goal is free
    local_goal = goal;
else
    switch param.localgoal
        case 'frompath'
            %% Pick Goal from Path
            local_goal = goalfrompath(occupancy_map, path, curr_pose(1:2), param.plan_horizon);

        case 'random'
            %% Pick Random Goal
            local_goal = samplePosfromMap(occupancy_map);

    end
end


end