function pose = posefromtrajectoy(trajectory, T, t)
        idx = sum(T <= t);
        
        position = trajectory(idx, :);
        if ~(idx -1 <= 0)
            velocity = trajectory(idx, :) - trajectory(idx-1, :);
        else
            velocity = [0, 0];
        end
        
        ram = atan2(velocity(2), velocity(1));
        pose = [position, ram];
end