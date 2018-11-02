function navigate(params, videoObj)
%% Parameters
plan_horizon = 10;
update_rate = 2;
dt = 0.1;

%% Generate Global Trajectory

switch params.map_type
    case 'randomforest'
        binmap_true = create_random_map(params.globalmap.width, params.globalmap.height, params.globalmap.resolution, params.globalmap.numsamples, params.globalmap.inflation);
        
    case 'image'
        binmap_true = create_image_map(params.map_path);
    
    otherwise
        print('map generation option is not valid');
end
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
local_goal = goalfrompath(cons_binmap, globalpath, mavPose(1:2), plan_horizon);

while true        
    %% Local Planning from global path
    % Create a partial map based on observation
    [localmap_obs, localmap_full] = get_localmap('increment', binmap_true, localmap_obs, params, mavPose);
    
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
    local_goal = goalfrompath(cons_binmap, globalpath, mavPose(1:2), plan_horizon);
    
%     if goalreached(, global_goal)
%         break;
%     end

end
end

function [isgoal] = goalreached(current_position, goal_position)
    tolerance = 0.1;
    isgoal = norm(current_position - goal_position) <  tolerance;
end

function goal = goalfrompath(map, path, current_position, horizon)
    idx = sum(vecnorm(path - current_position, 2, 2) < horizon);
    
    while true
        if(idx <= 1)
           disp('No valid Goal position found');
           break;
        end
        if ~map.getOccupancy(path(idx, :))
           break;
        end
        idx = idx -1;
    end
    goal = path(idx, :);
end

function pose = posefromtrajectoy(trajectory, T, t)
        idx = sum(T < t);
        
        position = trajectory(idx, :);
        velocity = trajectory(idx +1, :) - trajectory(idx, :);
        ram = atan2(velocity(2), velocity(1));
        pose = [position, ram];
end