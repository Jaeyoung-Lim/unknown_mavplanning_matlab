function goal = goalfrompath(map, path, current_position, horizon)
    idx = sum(vecnorm(path - current_position, 2, 2) < horizon);
    %TODO: Improve on getting local goal from path: the horizon is the path
    %length
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