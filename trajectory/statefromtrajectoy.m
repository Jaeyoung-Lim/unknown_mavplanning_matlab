function [pose, velocity, acceleration] = statefromtrajectoy(trajectory, trajectory_vel, trajectory_acc, T, t)
        idx = sum(T <= t);
        
        position = trajectory(idx, :);
        velocity = trajectory_vel(idx, :);
        acceleration = trajectory_acc(idx, :);
        
        ram = atan2(velocity(2), velocity(1));
        pose = [position, ram];
end