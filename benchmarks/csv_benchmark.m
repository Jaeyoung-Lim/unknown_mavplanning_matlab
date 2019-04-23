clc; close all; clear all;
data_dir = '/home/jaeyoung/data/';

%% Local vs Global Timing Benchmark
path = 'archive/LocalPlannerBenchmark/tsdf_threshold_0/local_benchmark.csv';
data_local2 = csvread(strcat(data_dir, path), 1, 0);

density = [0.1, 0.2, 0.3, 0.4, 0.5];
success_rate = size(1, numel(density));
figure('Name','Success Rates');

for i = 1:numel(density)
    mask = (data_local2(:, 3) == density(i));
    success_rate(i) = sum(data_local2(mask, 8) .* data_local2(mask, 9) .* data_local2(mask, 10))/10;
end
plot(density, success_rate, 'x--', 'LineWidth',1.5); hold on;

path = 'archive/LocalPlannerBenchmark/tsdf_threshold_05/local_benchmark.csv';
data_local = csvread(strcat(data_dir, path), 1, 0);

for i = 1:numel(density)
    mask = (data_local(:, 3) == density(i));
%     success_rate(i) = sum(data_local(mask, 8) .* data_local(mask, 9) .* data_local(mask, 9));
    success_rate(i) = sum(data_local(mask, 8) .* data_local(mask, 9).* data_local(mask, 10))/10;
end

plot(density, success_rate, 'x--', 'LineWidth',1.5); hold on;

path = 'archive/LocalPlannerBenchmark/tsdf_threshold_075/local_benchmark.csv';
data_local3 = csvread(strcat(data_dir, path), 1, 0);

for i = 1:numel(density)
    mask = (data_local3(:, 3) == density(i));
    success_rate(i) = sum(data_local3(mask, 8) .* data_local3(mask, 9) .* data_local3(mask, 10))/10;
end
plot(density, success_rate, 'x--', 'LineWidth',1.5); hold on;
legend('TSDF threshold = 0.0', 'TSDF threshold = 0.5', 'TSDF threshold = 0.75');
title('Success Rate, Obstacle Density');
xlabel('Obstacle density');
ylabel('Success Rate');
ylim([0, 1]);

%% Acceleration Trajectory
%% Local vs Global Timing Benchmark
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

path = 'archive/LocalPlannerBenchmark/tsdf_threshold_05/local_benchmark.csv';
data_local = csvread(strcat(data_dir, path), 1, 0);
