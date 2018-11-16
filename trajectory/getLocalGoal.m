function [local_goal, local_goal_vel] = getLocalGoal(param, binoccupancy_map, curr_pose, path, goal, occupancy_map)

if nargin < 6
    occupancy_map = [];
end
local_goal_yaw = [];

if ~binoccupancy_map.getOccupancy(goal)
    % Local goal is global goal if global goal is free
    local_goal = goal;
    local_goal_vel = zeros(1,2);
else
    switch param.localgoal
        case 'frompath'
            %% Pick Goal from Path
            local_goal = goalfrompath(binoccupancy_map, path, curr_pose(1:2), param.plan_horizon);

        case 'random'
            %% Pick Random Goal
            local_goal = samplePosfromMap(binoccupancy_map);
            
        case {'nextbestview', 'nexbestview-yaw'}
            %% Pick Next Best View
            [local_goal, local_goal_vel] = getNextBestView(param, binoccupancy_map, curr_pose, goal, occupancy_map);

    end
end


end