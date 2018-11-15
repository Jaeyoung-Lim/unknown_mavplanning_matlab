function [pose, velocity] = posefromtrajectoy(trajectory, trajectory_vel, T, t)
        idx = sum(T <= t);
        
        position = trajectory(idx, :);
        velocity = trajectory_vel(idx, :);
        
        ram = atan2(velocity(2), velocity(1));
        pose = [position, ram];
end