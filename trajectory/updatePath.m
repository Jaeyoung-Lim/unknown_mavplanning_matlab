function [state, T] = updatePath(state, T, dt)
        state.path = [state.path; state.pose(1:2)]; % Record trajectory
        state.path_vel = [state.path_vel; norm(state.velocity)];
        state.path_acc = [state.path_acc; norm(state.acceleration)];
        T = T + dt;

end