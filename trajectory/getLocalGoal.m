function [local_goal, local_goal_vel] = getLocalGoal(param, binoccupancy_map, curr_pose, path, goal, occupancymap, hilbertmap)

if nargin < 6
    occupancy_map = [];
else
    occupancy_map = occupancymap.localmap;
end

if isempty(hilbertmap.wt)
    num_features = param.hilbertmap.resolution^2 * binoccupancy_map.XWorldLimits(2) * binoccupancy_map.YWorldLimits(2);
    hilbertmap.wt = zeros(num_features, 1);
end
% Coordinate transform incase of local goal
switch param.mapping
    case 'local'
        goal = global2localpos(param, goal, curr_pose(1:2));
        curr_pose(1:2) = global2localpos(param, curr_pose(1:2), curr_pose(1:2));
        
end
switch param.planner.type
    case 'hilbertchomp'
        local_goal = param.goal_point;
        local_goal_vel = [0.0, 0.0];
        return;
end

if isinsideMap(param, binoccupancy_map, goal)
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

            case {'nextbestview', 'nextbestview-yaw', 'nextbestview-hilbert'}
                %% Pick Next Best View
                [local_goal, local_goal_vel] = getNextBestView(param, binoccupancy_map, curr_pose, goal, occupancy_map, hilbertmap);

            otherwise
                disp('invalid local planner parameter')

        end
    end
else
    switch param.localgoal
        case 'global'
            local_goal = goal;
            local_goal_vel = zeros(1, 2);
    end

    % This is nonsense:
    local_goal = samplePosfromMap(binoccupancy_map);
    local_goal_vel = zeros(1,2);    
end

switch param.mapping
    case 'local'
        local_goal = global2localpos(param, local_goal, curr_pose(1:2));        
end

end

function flag = isinsideMap(param, map, goal)
    origin = [0.5*param.localmap.width, 0.5*param.localmap.height]; % For Robocentric Coordinates
    goal = goal + origin;
    if goal(1) <= map.XWorldLimits(2) && goal(1) >= map.XWorldLimits(1) && goal(2) <= map.YWorldLimits(2) && goal(2) >= map.YWorldLimits(1)
        flag = true;
    else
        flag = false;    
    end
    
end