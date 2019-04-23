clc; close all; clear all;
data_dir = '/home/jaeyoung/data/';

%% Acceleration Trajectory

path = 'archive/GlobalPlannerBenchmark/localtsdf_threshold_0/local_benchmark.csv';
data_local = csvread(strcat(data_dir, path), 1, 0);

density = [0.1, 0.2, 0.3, 0.4, 0.5];
success_rate = size(1, numel(density));
figure('Name','Success Rates');

for i = 1:numel(density)
    mask = (data_local(:, 3) == density(i));
    success_rate(i) = sum(data_local(mask, 8) .* data_local(mask, 9) .* data_local(mask, 10))/10;
end
plot(density, success_rate, 'x--', 'LineWidth',1.5); hold on;
legend('TSDF threshold = 0.0', 'TSDF threshold = 0.5', 'TSDF threshold = 0.75');
title('Success Rate, Obstacle Density');
xlabel('Obstacle density');
ylabel('Success Rate');
ylim([0, 1]);