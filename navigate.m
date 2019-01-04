function [T, mavpath, failure] = navigate(params, binmap_true)
%% Initialize Parameters
initialize();

%% Plan Optimistic global trajectory 
occupancymap.truemap = binmap_true;
% Initialize Local map
occupancymap = get_localmap(params.mapping, occupancymap, params, mav.pose); % Create a partial map based on observation

% Plan global trajectory
globalpath = planGlobalTrajectory(params, occupancymap, global_start, global_goal);
[hilbertmap, ~] = learn_hilbert_map(params, occupancymap, hilbertmap, mav.pose);

while true        
    %% Replan Local trajectory from trajectory replanning rate
    local_start = mav.pose(1:2);
    cons_binmap = get_conservativemap(occupancymap, params, mav.pose);
    [local_goal, local_goal_vel] = getLocalGoal(params, cons_binmap, mav.pose, globalpath, global_goal, occupancymap, hilbertmap); % Parse intermediate goal from global path
        
    [localT, localpath, localpath_vel, localpath_acc] = plan_trajectory(params, cons_binmap, local_start, local_goal, mav.velocity, local_goal_vel, mav.acceleration, occupancymap, hilbertmap);
    %%
    if hilbertmap.enable
        plot_hilbertmap(params, hilbertmap, occupancymap, mav.pose, localpath);
    end

%     if detectLocalOptima(localpath)
%         if params.globalreplan
%             % Global plan based on optimistic map
%             globalpath = planGlobalTrajectory(params, occupancymap, local_start, global_goal);
%         else
%             failure = true;
%             disp('Stuck in local goal!');
%             break;
%         end
%     end
    %% Move along local trajectory
    for t = 0:dt:params.update_rate
        [mav.pose, mav.velocity, mav.acceleration] = statefromtrajectoy(localpath, localpath_vel, localpath_acc, localT, t);

        [mav, T] = updatePath(mav, T, dt); %Record path from state
        
        % Create a partial map based on observation
        [occupancymap, ~, free_space, occupied_space] = get_localmap(params.mapping, occupancymap, params, mav.pose);
        
        if params.hilbertmap.enable
            % Subsample the observations to store in bin
            [hilbertmap.xy, hilbertmap.y] = sampleObservations(free_space, occupied_space, hilbertmap.xy, hilbertmap.y);
        end
        
        plot_summary(params, T, occupancymap, localpath, globalpath, mav, local_goal_vel, global_goal); % Plot MAV moving in environment
        
        if isCollision(mav.pose(1:2), occupancymap.truemap) || goalreached(mav.pose(1:2), global_goal)
            break; % Get out of the for loop
        end
    end
    % Discard samples that are outside the map\
    if hilbertmap.enable
        [hilbertmap, ~] = learn_hilbert_map(params, occupancymap, hilbertmap, mav.pose);
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