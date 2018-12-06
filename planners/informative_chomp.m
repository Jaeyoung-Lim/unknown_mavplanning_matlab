function [trajectory] = informative_chomp(map, initpos, finalpos, initvel, finalvel, initacc)

if nargin < 4
    initvel = [0.0, 0.0];
    finalvel = [0.0, 0.0];
    initacc = [0.0, 0.0];
elseif nargin < 5
    finalvel = [0.0, 0.0];
    initacc = [0.0, 0.0];
elseif nargin < 6
    initacc = [0.0, 0.0];
end
K = size(initpos, 2); % Number of dimensions.
N = 11; % Is equivalent to N = 12 in Markus code
v_max = 10.0;
a_max = 10.0;

trajectory = create_trajectory(K, N);
trajectory = add_vertex_state_to_trajectory(trajectory, initpos, 1, 0, initvel, initacc);

% trajectory = add_vertex_state_to_trajectory(trajectory, 2 * (initpos + finalpos)/4, 0, 1);
% 
% trajectory = add_vertex_state_to_trajectory(trajectory, 2 * (initpos + finalpos)/4, 0, 1);
% trajectory = add_vertex_state_to_trajectory(trajectory, 3 * (initpos  +finalpos)/4, 0, 1);

trajectory = add_vertex_state_to_trajectory(trajectory, finalpos, 1, 0, finalvel);

% Estimate segment times.
trajectory = estimate_trajectory_times(trajectory, v_max, a_max);
trajectory = solve_trajectory(trajectory);

%% Optimize path around obstacles.
trajectory = optimize_trajectory_collisions(map, trajectory, 0);

end