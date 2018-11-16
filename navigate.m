function [T, mavpath, failure] = navigate(params, binmap_true)
%% Initialize Parameters
initialize();

%% Plan Optimistic global trajectory 
global_start = params.start_point; % Set gloabl start and goal position
global_goal = params.goal_point;
% init_yaw = atan2(global_goal(2)-global_start(2), global_goal(1)-global_start(1));
init_yaw = pi()/2;
mav.pose = [global_start, init_yaw]; % Current position starts from global start
mav.velocity = [0.0, 0.0];

% Initialize Local map
localmap_obs = robotics.OccupancyGrid(params.globalmap.width, params.globalmap.height, params.globalmap.resolution);

map_partial = get_localmap('increment', binmap_true, localmap_obs, params, mav.pose); % 
opt_binmap = get_optimisticmap(map_partial, params, mav.pose); % Optimistic binary occupancy grid

% Plan global trajectory
switch params.global_planner
    case 'optimistic'
        % Global plan based on optimistic map
        [~, globalpath] = plan_trajectory('polynomial', opt_binmap, global_start, global_goal);
     
    case 'true'
        % Global plan based on true map
        [~, globalpath] = plan_trajectory('polynomial', binmap_true, global_start, global_goal);
    case 'disable'
        % Disable global planner
        globalpath = [];

end

%% Local replanning from global path
[localmap_obs, ~] = get_localmap('increment', binmap_true, localmap_obs, params, mav.pose);     % Create a partial map based on observation

while true        
    % Replan Local trajectory from trajectory replanning rate

    local_start = mav.pose(1:2);
    cons_binmap = get_conservativemap(localmap_obs, params, mav.pose);
    [local_goal, local_goal_vel] = getLocalGoal(params, cons_binmap, mav.pose, globalpath, global_goal, localmap_obs); % Parse intermediate goal from global path
   
    [localT, localpath, localpath_vel] = plan_trajectory('chomp', cons_binmap, local_start, local_goal, mav.velocity, local_goal_vel);
    
    if detectLocalOptima(localpath)
        switch params.globalreplan
            case false
                failure = true;
                disp('Stuck in local goal!');
                break;
            case true
                opt_binmap = get_optimisticmap(map_partial, params, mav.pose); % Optimistic binary occupancy grid
                % Global plan based on optimistic map
                [~, globalpath] = plan_trajectory('polynomial', opt_binmap, local_start, global_goal);
        end
    end
    %% Move along local trajectory
    for t = 0:dt:params.update_rate
        [mav.pose, mav.velocity] = posefromtrajectoy(localpath, localpath_vel, localT, t);
        %TODO: Collision Checking
        mav.path = [mav.path; mav.pose(1:2)]; % Record trajectory
        mav.path_vel = [mav.path_vel; norm(mav.velocity)];
        T = T + dt;

        [localmap_obs, ~] = get_localmap('increment', binmap_true, localmap_obs, params, mav.pose);     % Create a partial map based on observation

        if params.visualization
            plot_summary(params, T, binmap_true, localmap_obs, localpath, globalpath, mav, local_goal_vel); % Plot MAV moving in environment
        end
        
        if goalreached(mav.pose(1:2), global_goal)
            break;
        end
    end

    if goalreached(mav.pose(1:2), global_goal)
        disp('Goal Reached!');
        break;
    end
end

mavpath = mav.path;
end