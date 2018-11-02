function pose = posefromtrajectoy(trajectory, T, t)
        idx = sum(T < t);
        
        position = trajectory(idx, :);
        velocity = trajectory(idx, :) - trajectory(idx-1, :);
        ram = atan2(velocity(2), velocity(1));
        pose = [position, ram];
end