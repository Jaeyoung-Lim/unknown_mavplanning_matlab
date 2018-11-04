function navigate(params, binmap_true, videoObj)
%% Initialize Parameters
plan_horizon = 10;
update_rate = 10;
dt = 0.1;

%% Plan Optimistic global trajectory 

% Set gloabl start and goal position
global_start = params.start_point;
global_goal = params.goal_point;

mavPose = [global_start, 0.0];
localmap_obs = robotics.OccupancyGrid(params.globalmap.width, params.globalmap.height, params.globalmap.resolution);
map_partial = get_localmap('increment', binmap_true, localmap_obs, params, mavPose);
opt_binmap = get_optimisticmap(map_partial, params, mavPose);
cons_binmap = get_conservativemap(map_partial, params, mavPose);

% Plan global trajectory
[T, globalpath] = plan_trajectory('polynomial', opt_binmap, global_start, global_goal);

% Parse intermediate goal from global path
local_start = globalpath(sum(T < update_rate), :);
if cons_binmap.getOccupancy(global_goal)
    local_goal = global_goal;
else
    local_goal = goalfrompath(cons_binmap, globalpath, mavPose(1:2), plan_horizon);
end

%% Local replanning from global path

while true        
    % Create a partial map based on observation
    [localmap_obs, ~] = get_localmap('increment', binmap_true, localmap_obs, params, mavPose);
    
    % Replan Local trajectory from trajectory replanning rate
    local_start = mavPose(1:2);
    
    cons_binmap = get_conservativemap(localmap_obs, params, mavPose);
    [localT, localpath] = plan_trajectory('chomp', cons_binmap, local_start, local_goal);

    %% Move along local trajectory
    for t = 1:dt:update_rate
        mavPose = posefromtrajectoy(localpath, localT, t);
        
        if params.visualization
            plot_summary(params, binmap_true, localmap_obs, localpath, globalpath, mavPose, videoObj); % Plot MAV moving in environment
        end
    end
    
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