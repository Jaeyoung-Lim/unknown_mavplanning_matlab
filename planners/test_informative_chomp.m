clc; clear all;
%% Get Parameters
param = Param_CORNER;


[map, start_pos, goal_pos] = generate_envwithPos(param, param.start_point, param.goal_point);

start_point = start_pos;
goal_point = goal_pos;

%% Create a random map.
% clf;
% map = create_random_map(4, 4, 10, 10, 0.4);  
% %map = robotics.BinaryOccupancyGrid(4, 5, 10);
% %setOccupancy(map, [2, 1.7], 1);
% %inflate(map, 0.4);
% 
% start_point = [0.5 0.5];
% goal_point = [3.5 3.5];
% 
% % Clear 0.5, 0.5 and 3.5, 3.5
% setOccupancy(map, vertcat(start_point, goal_point, ...
%   start_point+0.05, goal_point+0.05, start_point-0.05, goal_point-0.05), 0);


%% Get Local map from start point
pose = [start_point, pi()/2];

localmap_obs = initlocalmap(param);
[localmap_obs, ~, free_space, occupied_space] = get_localmap(param.mapping, map, localmap_obs, param, pose);


%% Learn Hilbert map
if param.hilbertmap.enable

    hilbertmap.wt = [];
    hilbertmap.xy = [];
    hilbertmap.y = [];
    [hilbertmap.xy, hilbertmap.y] = sampleObservations(free_space, occupied_space, hilbertmap.xy, hilbertmap.y);

    hilbertmap = learn_hilbert_map(param, map, hilbertmap);
end
%% Get a straight line plan.
K = 2; % Number of dimensions.
N = 11; % Is equivalent to N = 12 in Markus code
v_max = 1.0;
a_max = 2.0;

trajectory = create_trajectory(K, N);
trajectory = add_vertex_to_trajectory(trajectory, start_point, 1);

trajectory = add_vertex_to_trajectory(trajectory, 2*(start_point+goal_point)/4, 0, 1);

trajectory = add_vertex_to_trajectory(trajectory, goal_point, 1);

% Estimate segment times.
trajectory = estimate_trajectory_times(trajectory, v_max, a_max);
trajectory = solve_trajectory(trajectory);

%trajectory = plan_path_waypoints([start_point;goal_point]);

%% Optimize path around obstacles.
% trajectory = optimize_trajectory_collisions(map, trajectory, 0);
trajectory = optimize_trajectory_collisions_inf(map, trajectory, 0, 0, 0.1, localmap_obs, hilbertmap, param);

%% Plot
figure(1);
subplot(1, 2, 1);
show(map);
subplot(1, 2, 2);
% Plot Collision Cost map with trajectory
[cost_map, cost_map_x, cost_map_y] = get_cost_map(map);
plot_map_table(map, cost_map);
colorbar;
hold on;
plot([start_point(1), goal_point(1)], [start_point(2), goal_point(2)], 'xw');
[t, p] = sample_trajectory(trajectory, 0.1);
plot(p(:, 1), p(:, 2), 'w');

figure(2);
plot_hilbertmap(param, hilbertmap, localmap_obs, pose);
% Plot

%hold off;
