function navigate(params, videoObj)
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

planning_horizon = 10;
update_rate = 2;
dt = 0.1;


%% Plan Optimistic global trajectory 
mavPose = [global_start, 0.0];
localmap_obs = robotics.OccupancyGrid(params.globalmap.width, params.globalmap.height, params.globalmap.resolution);
map_partial = get_localmap('increment', binmap_true, localmap_obs, params, mavPose);
opt_binmap = get_optimisticmap(map_partial, params, mavPose);

[T, globalpath] = plan_trajectory('polynomial', opt_binmap, global_start, global_goal);

%% Initialize local plan
local_start = start_pos;
% local_goal = ;


while true
    %% TODO: Parse path from global path
    local_start = start_pos;
    local_goal = global_goal;


    localpath = globalpath;
    %% Plan Local trajectory
    [T, globalpath] = plan_trajectory(params.planner, binmap_true, local_start, local_goal);

        
    for t = 1:dt:update_rate
        position = path(j, :);
        velocity = path(j +1, :) - path(j, :);
        ram = atan2(velocity(2), velocity(1));

        mavPose = [position, ram];
        %% Generate Local map
        % Create a partial map based on observation
        [localmap_obs, localmap_full] = get_localmap(binmap_true, localmap_obs, params, mavPose);
        
        %% Plot
        if params.visualization
            plot_summary(params, binmap_true, localmap_obs, path, mavPose, videoObj);
        end   
        if goalreached(position, global_goal)
            break;
        end
    end
    start_pos = mavPose(1:2);
end

end

function [isgoal] = goalreached(current_position, goal_position)

    tolerance = 0.1;
    isgoal = norm(current_position - goal_position) <  tolerance;
end