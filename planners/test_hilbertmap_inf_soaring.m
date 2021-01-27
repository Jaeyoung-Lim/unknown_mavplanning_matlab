clc; close all;
%% Create a random map.
map_size = 1;

param = Param_TINYRANDOMFOREST;
figure('name', 'Navigator', 'NumberTitle', 'off', 'Position', [100 800 400 400]);
figure('name', 'Optimizer', 'NumberTitle', 'off', 'Position', [1900 800 400 400]);


occupancymap = struct('localmap', [], ... % Locally observed map
                      'incrementmap', [], ... % Global observed map
                      'truemap', []); % True binary occupancy map


[occupancymap.truemap, start_pos, goal_pos] = generate_envwithPos(param, param.start_point, param.goal_point);
start_point = start_pos;
goal_point = goal_pos;
map = occupancymap.truemap;

%% Get Hilbert map
occupancymap.incrementmap = initlocalmap(param);
occupancymap.localmap = initlocalmap(param);

hilbertmap.wt = [];
hilbertmap.xy = [];
hilbertmap.y = [];
res = 0.5;
num_samples = 41;
X = map.XWorldLimits(2) - rand(num_samples, 1) * 0.5 *map.XWorldLimits(2);
Y = rand(num_samples, 1) * 1.0 *map.YWorldLimits(2);
xy =  [X(:), Y(:)];
num_samples = 21;
X = rand(num_samples, 1) * 0.5 *map.XWorldLimits(2);
Y = rand(num_samples, 1) * 0.5 *map.YWorldLimits(2);
xy =  [xy; X(:), Y(:)];

hilbertmap.xy = xy;

y = double(map.getOccupancy(xy));
zero_mask = y < 1;
y(zero_mask) = -1;
hilbertmap.y = y;


hilbertmap = learn_hilbert_map(param, occupancymap, hilbertmap, [start_point, 0]);
%% Get a straight line plan.
%path = [start_point; goal_point];

K = 2; % Number of dimensions.
N = 11; % Is equivalent to N = 12 in Markus code
v_max = 1.0;
a_max = 2.0;

trajectory = create_trajectory(K, N);
trajectory = add_vertex_to_trajectory(trajectory, start_point, 1);

trajectory = add_vertex_to_trajectory(trajectory, 1*(start_point+goal_point)/4, 0, 1);
trajectory = add_vertex_to_trajectory(trajectory, 2*(start_point+goal_point)/4, 0, 1);
trajectory = add_vertex_to_trajectory(trajectory, 3*(start_point+goal_point)/4, 0, 1);

%trajectory = add_vertex_to_trajectory(trajectory, 3*(start_point+goal_point)/4, 0, 1);

trajectory = add_vertex_to_trajectory(trajectory, goal_point, 0, 1);

% Estimate segment times.
trajectory = estimate_trajectory_times(trajectory, v_max, a_max);
trajectory = solve_trajectory(trajectory);

%trajectory = plan_path_waypoints([start_point;goal_point]);

%% Optimize path around obstacles.
figure(findobj('name', 'Optimizer'));
show(map); hold on;
trajectory_chomp = optimize_trajectory_collisions_free(map, trajectory, 0);
trajectory_hilbert = optimize_trajectory_collisions_hilbert(map, trajectory, 0, 0, 0.1, occupancymap.localmap, hilbertmap, param);


%% Plot
figure(1);
subplot(1, 2, 1);
[cost_map, cost_map_x, cost_map_y] = get_cost_map(map);
plot_map_table(map, cost_map);
colorbar;
hold on;
title('Collision cost Map');
plot([start_point(1), goal_point(1)], [start_point(2), goal_point(2)], 'xw');
[t, p] = sample_trajectory(trajectory_chomp, 0.1);
plot(p(:, 1), p(:, 2), 'w');

hold off;

% figure(2);
subplot(1, 2, 2);
xy = hilbertmap.xy;
y = hilbertmap.y;
wt = hilbertmap.wt;

tic;
map_hilbert = render_hilbertmap(param, wt, map);
time = toc;
fprintf('Render Time: %d\n',time)

imagesc(map.XWorldLimits, fliplr(map.YWorldLimits), flipud(map_hilbert'));

set(gca, 'Ydir', 'normal');
hold on;

if ~isempty(xy)
    plot(xy((y > 0), 1), xy((y > 0), 2), 'xr'); hold on;
    plot(xy((y < 0), 1), xy((y < 0), 2), 'xb'); hold on;
end

% colormap(gca, 'jet');
colorbar('Ticks',[]);
title('Hilbert Map');
xlabel('x position [m]'); ylabel('y position [m]');
axis image;
plot([start_point(1), goal_point(1)], [start_point(2), goal_point(2)], 'xw');  hold on;
[t, p1] = sample_trajectory(trajectory_hilbert, 0.1);
plot(p1(:, 1), p1(:, 2), 'w');  hold on;
