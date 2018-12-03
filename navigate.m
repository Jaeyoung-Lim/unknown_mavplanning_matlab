function [T, mavpath, failure] = navigate(params, binmap_true)
%% Initialize Parameters
initialize();

%% Plan Optimistic global trajectory 

% Initialize Local map
localmap_obs = initlocalmap(params);
localmap_obs = get_localmap(params.mapping, binmap_true, localmap_obs, params, mav.pose);     % Create a partial map based on observation

% Plan global trajectory
globalpath = planGlobalTrajectory(params, binmap_true, global_start, global_goal, localmap_obs);

while true        
    %% Replan Local trajectory from trajectory replanning rate
    local_start = mav.pose(1:2);
    [local_goal, local_goal_vel] = getLocalGoal(params, localmap_obs, mav.pose, globalpath, global_goal, localmap_obs); % Parse intermediate goal from global path
        
    [localT, localpath, localpath_vel, localpath_acc] = plan_trajectory('chomp', cons_binmap, local_start, local_goal, mav.velocity, local_goal_vel, mav.acceleration);
%%    
    if detectLocalOptima(localpath)
        if params.globalreplan
            % Replan Global plan from local start
            globalpath = planGlobalTrajectory(params, binmap_true, local_start, global_goal, localmap_obs);
        else
            failure = true;
            disp('Stuck in local goal!');
            break;
        end
    end
    %% Move along local trajectory
    for t = 0:dt:params.update_rate
        [mav.pose, mav.velocity, mav.acceleration] = statefromtrajectoy(localpath, localpath_vel, localpath_acc, localT, t);

        [mav, T] = updatePath(mav, T, dt); %Record path from state
        
        % Create a partial map based on observation
        [localmap_obs, ~, free_space, occupied_space] = get_localmap(params.mapping, binmap_true, localmap_obs, params, mav.pose);
        
        if params.hilbertmap.enable
            % Only memorize a small set of features
            [xy, y] = sampleObservations(free_space, occupied_space, xy, y);
        end
        
        plot_summary(params, T, binmap_true, localmap_obs, localpath, globalpath, mav, local_goal_vel); % Plot MAV moving in environment
        
        if isCollision(mav.pose(1:2), binmap_true) || goalreached(mav.pose(1:2), global_goal)
            break; % Get out of the for loop
        end
    end
    %% Learn and Plot hilbertmaps 
    if params.hilbertmap.enable
        % Discard samples that are outside the map
        [xy, y] = discardObservations(params, xy, y, mav.pose);
        % Learn hilbert maps
        [wt, learning_time] = learn_hilbert_map(params, localmap_obs, xy, y, wt_1, mav.pose);
        
        regression_time = [regression_time, learning_time];
        wt_1 = wt;
        plot_hilbertmap(params, wt, localmap_obs, xy, y, mav.pose);
    end
    if isCollision(mav.pose(1:2), binmap_true)
       failure = true;
       break; 
    elseif goalreached(mav.pose(1:2), global_goal)
        disp('Goal Reached!');
        break;
    end
end
mavpath = mav.path;
end
