function globalpath = planGlobalTrajectory(params, occupancymap, global_start, global_goal)
    % Plan global trajectory
    binmap_true = occupancymap.truemap;
    map_partial = occupancymap.localmap;
    
    switch params.global_planner
        case 'optimistic'
            % Global plan based on optimistic map
            opt_binmap = get_optimisticmap(map_partial, params, mav.pose); % Optimistic binary occupancy grid
            [~, globalpath] = plan_trajectory('polynomial', opt_binmap, global_start, global_goal);

        case 'true'
            % Global plan based on true map
            [~, globalpath] = plan_trajectory('polynomial', binmap_true, global_start, global_goal);
        case 'disable'
            % Disable global planner
            globalpath = [];

    end
end