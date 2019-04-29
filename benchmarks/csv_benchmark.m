clc; close all; clear all;
data_dir = '/home/jaeyoung/data/';

%% Local vs Global Timing Benchmark

path = 'archive/LocalPlannerBenchmark/tsdf_threshold_0/local_benchmark.csv';
data_local3 = csvread(strcat(data_dir, path), 1, 0);
density = [0.05, 0.1, 0.15, 0.2, 0.25, 0.3, 0.35, 0.4, 0.45, 0.5];

for i = 1:numel(density)
    mask = (data_local3(:, 3) == density(i));
    success_rate(i) = sum(data_local3(mask, 8) .* data_local3(mask, 9))/30;
end
plot(density, success_rate, 'x--', 'LineWidth',1.5); hold on;


path = 'archive/LocalPlannerBenchmark/tsdf_threshold_05/local_benchmark.csv';
data_local3 = csvread(strcat(data_dir, path), 1, 0);
density = [0.05, 0.1, 0.15, 0.2, 0.25, 0.3, 0.35, 0.4, 0.45, 0.5];

for i = 1:numel(density)
    mask = (data_local3(:, 3) == density(i));
    success_rate(i) = sum(data_local3(mask, 8) .* data_local3(mask, 9))/30;
end
plot(density, success_rate, 'x--', 'LineWidth',1.5); hold on;


path = 'archive/LocalPlannerBenchmark/tsdf_threshold_075/local_benchmark.csv';
data_local3 = csvread(strcat(data_dir, path), 1, 0);
density = [0.05, 0.1, 0.15, 0.2, 0.25, 0.3, 0.35, 0.4, 0.45, 0.5];

for i = 1:numel(density)
    mask = (data_local3(:, 3) == density(i));
    success_rate(i) = sum(data_local3(mask, 8) .* data_local3(mask, 9))/30;
end
plot(density, success_rate, 'x--', 'LineWidth',1.5); hold on;


% path = 'local_benchmark/mav_local_planner_benchmark.csv';
path = 'archive/LocalPlannerBenchmark/mav_local_benchmark.csv';

data_local3 = csvread(strcat(data_dir, path), 1, 0);
density2 = [0.05, 0.1, 0.15, 0.2, 0.25, 0.3, 0.35, 0.4, 0.45, 0.5];

for i = 1:numel(density2)
    mask = (data_local3(:, 3) == density2(i));
    success_rate(i) = sum(data_local3(mask, 8) .* data_local3(mask, 9))/30;
end
plot(density2, success_rate, 'x-', 'LineWidth',1.5); hold on;


legend('Hilbert Planner TSDF 0', 'Hilbert Planner TSDF 0.5', 'Hilbert Planner TSDF 0.75', 'Oleynikova 2018');
title('Success Rate, Obstacle Density');
ylabel('Success Rate', 'fontweight','bold');
xlabel('Obstacle Density [obj/m^2]', 'fontweight','bold');
ylim([0, 1]);

%% Horizon Benchmark
path = 'archive/HorizonBenchmark/horizon_4/local_benchmark.csv';
data_local2 = csvread(strcat(data_dir, path), 1, 0);

density = [0.1, 0.2, 0.3, 0.4, 0.5];
success_rate = size(1, numel(density));
figure('Name','Horizon Benchmark');

for i = 1:numel(density)
    mask = (data_local2(:, 3) == density(i));
    success_rate(i) = sum(data_local2(mask, 8) .* data_local2(mask, 9) .* data_local2(mask, 10))/20;
end
plot(density, success_rate, 'x--', 'LineWidth',1.5); hold on;

path = 'archive/HorizonBenchmark/horizon_6/local_benchmark.csv';
data_local2 = csvread(strcat(data_dir, path), 1, 0);

density = [0.1, 0.2, 0.3, 0.4, 0.5];
success_rate = size(1, numel(density));

for i = 1:numel(density)
    mask = (data_local2(:, 3) == density(i));
    success_rate(i) = sum(data_local2(mask, 8) .* data_local2(mask, 9) .* data_local2(mask, 10))/20;
end
plot(density, success_rate, 'x--', 'LineWidth',1.5); hold on;

path = 'archive/HorizonBenchmark/horizon_8/local_benchmark.csv';
data_local2 = csvread(strcat(data_dir, path), 1, 0);

density = [0.1, 0.2, 0.3, 0.4, 0.5];
success_rate = size(1, numel(density));

for i = 1:numel(density)
    mask = (data_local2(:, 3) == density(i));
    success_rate(i) = sum(data_local2(mask, 8) .* data_local2(mask, 9) .* data_local2(mask, 10))/20;
end
plot(density, success_rate, 'x--', 'LineWidth',1.5); hold on;

path = 'archive/HorizonBenchmark/horizon_10/local_benchmark.csv';
data_local2 = csvread(strcat(data_dir, path), 1, 0);

density = [0.1, 0.2, 0.3, 0.4, 0.5];
success_rate = size(1, numel(density));

for i = 1:numel(density)
    mask = (data_local2(:, 3) == density(i));
    success_rate(i) = sum(data_local2(mask, 8) .* data_local2(mask, 9) .* data_local2(mask, 10))/20;
end
plot(density, success_rate, 'x--', 'LineWidth',1.5); hold on;
title('Horizon Length, Success Rate', 'fontsize', 12);
ylabel('Success Rate', 'fontweight','bold');
xlabel('Obstacle Density [obj/m^2]', 'fontweight','bold');
legend('Horizon 4m', 'Horizon 6m', 'Horizon 8m', 'Horizon 10m');

%% Horizon Benchmark
path = 'archive/HorizonBenchmark/horizon_4/local_benchmark.csv';
data_local2 = csvread(strcat(data_dir, path), 1, 0);

density = [0.1, 0.2, 0.3, 0.4, 0.5];
path_length = size(1, numel(density));
figure('Name','Horizon Benchmark-PathLength');

for i = 1:numel(density)
    mask = (data_local2(:, 3) == density(i));
    path_length(i) = sum(data_local2(mask, 15))/20;
end
plot(density, path_length, 'x--', 'LineWidth',1.5); hold on;

path = 'archive/HorizonBenchmark/horizon_6/local_benchmark.csv';
data_local2 = csvread(strcat(data_dir, path), 1, 0);

density = [0.1, 0.2, 0.3, 0.4, 0.5];
success_rate = size(1, numel(density));

for i = 1:numel(density)
    mask = (data_local2(:, 3) == density(i));
    path_length(i) = sum(data_local2(mask, 15))/20;
end
plot(density, path_length, 'x--', 'LineWidth',1.5); hold on;

path = 'archive/HorizonBenchmark/horizon_8/local_benchmark.csv';
data_local2 = csvread(strcat(data_dir, path), 1, 0);

density = [0.1, 0.2, 0.3, 0.4, 0.5];
success_rate = size(1, numel(density));

for i = 1:numel(density)
    mask = (data_local2(:, 3) == density(i));
    path_length(i) = sum(data_local2(mask, 15))/20;
end
plot(density, path_length, 'x--', 'LineWidth',1.5); hold on;

path = 'archive/HorizonBenchmark/horizon_10/local_benchmark.csv';
data_local2 = csvread(strcat(data_dir, path), 1, 0);

density = [0.1, 0.2, 0.3, 0.4, 0.5];
success_rate = size(1, numel(density));

for i = 1:numel(density)
    mask = (data_local2(:, 3) == density(i));
    path_length(i) = sum(data_local2(mask, 15))/20;
end
plot(density, path_length, 'x--', 'LineWidth',1.5); hold on;
title('Horizon Length, Success Rate', 'fontsize', 12);
ylabel('Success Rate', 'fontweight','bold');
xlabel('Obstacle Density [obj/m^2]', 'fontweight','bold');
legend('Horizon 4m', 'Horizon 6m', 'Horizon 8m', 'Horizon 10m');

%% Plot Trajectory
trajectory_path = 'archive/HorizonBenchmark/horizon_4/local_trajectory.csv';
environment_path = 'archive/HorizonBenchmark/horizon_4/environment.csv';
results_path = 'archive/HorizonBenchmark/horizon_4/local_benchmark.csv';

trajectory_raw = csvread(strcat(data_dir, trajectory_path), 1, 0);
environment_raw = csvread(strcat(data_dir, environment_path), 1, 0);
results_raw = csvread(strcat(data_dir, results_path), 1, 0);
% Plot Trajectory
num_trials = max(trajectory_raw(:, 1));
figure('Name','Trajectory');
trial_number = 21;

trial_mask = (trajectory_raw(:, 1) == trial_number);

plot3(trajectory_raw(trial_mask, 2), trajectory_raw(trial_mask, 3), trajectory_raw(trial_mask, 4), '-', 'LineWidth',1.5); hold on;
% Plot Obstacles

obstacle_mask = (environment_raw(:, 1) == trial_number);
environment_list = environment_raw(obstacle_mask, 1:3);
for i = 1:sum(obstacle_mask)
    drawCylinder(environment_raw(i, 5), environment_raw(i, 6), environment_raw(i, 2:3));
end
title('Trajectory in Map');
grid on; axis equal;

function drawCylinder(r, h, pos)
    [X, Y, Z] = cylinder(1.0);
    X = r * X + pos(1);
    Y = r * Y + pos(2);
    Z = h * Z;

    mesh(X,Y,Z, 'facecolor', [1 0 0], 'EdgeColor', [1 0 0]); hold on;
    fill3(X(1,:),Y(1,:),Z(1,:),'r');
    fill3(X(2,:),Y(2,:),Z(2,:),'r');

end