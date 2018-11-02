function navigate(params, videoObj)
%% Initialize Parameters
plan_horizon = 10;
update_rate = 2;
dt = 0.1;

% Generate the map
binmap_true = generate_environment(params);

%% Generate Global Trajectory
% Make sure the start and goal is unoccupied
setOccupancy(binmap_true, vertcat(params.start_point, params.goal_point, ...
  params.start_point+0.05, params.goal_point+0.05, params.start_point-0.05, params.goal_point-0.05), 0);

% Set gloabl start and goal position
global_start = params.start_point;
global_goal = params.goal_point;

%% Plan Optimistic global trajectory 
mavPose = [global_start, 0.0];
localmap_obs = robotics.OccupancyGrid(params.globalmap.width, params.globalmap.height, params.globalmap.resolution);
map_partial = get_localmap('increment', binmap_true, localmap_obs, params, mavPose);
opt_binmap = get_optimisticmap(map_partial, params, mavPose);
cons_binmap = get_conservativemap(map_partial, params, mavPose);

[T, globalpath] = plan_trajectory('chomp', opt_binmap, global_start, global_goal);

% Parse intermediate goal from global path
local_start = globalpath(sum(T < update_rate), :);
if cons_binmap.getOccupancy(global_goal)
    local_goal = global_goal;
else
    local_goal = goalfrompath(cons_binmap, globalpath, mavPose(1:2), plan_horizon);
end

while true        
    %% Local replanning from global path
    % Create a partial map based on observation
    [localmap_obs, ~] = get_localmap('increment', binmap_true, localmap_obs, params, mavPose);
    
    % Replan Local trajectory from trajectory replanning rate
    cons_binmap = get_conservativemap(localmap_obs, params, mavPose);
    [localT, localpath] = plan_trajectory('chomp', cons_binmap, local_start, local_goal);

    %% Move along local trajectory
    for t = 1:dt:update_rate
        mavPose = posefromtrajectoy(localpath, localT, t);
        % Plot
        if params.visualization
            plot_summary(params, binmap_true, localmap_obs, localpath, mavPose, videoObj);
        end
    end
    
    local_start = mavPose(1:2);
    % Check if goal is visible
    if cons_binmap.getOccupancy(global_goal)
        local_goal = global_goal;
    else
        local_goal = goalfrompath(cons_binmap, globalpath, mavPose(1:2), plan_horizon);
    end
    
    if goalreached(mavPose(1:2), global_goal)
        break;
    end

end
end



