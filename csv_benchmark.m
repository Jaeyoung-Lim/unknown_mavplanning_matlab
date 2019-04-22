clc; clear all;
data_dir = '/home/jaeyoung/data/';

%% Local vs Global Timing Benchmark
path = 'local_benchmark/local_benchmark.csv';
data_local = csvread(strcat(data_dir, path), 1, 0);

density = 0.05:0.05:0.5;
success_rate = size(1, numel(density));

for i = 1:numel(density)
    mask = (data_local(:, 3) == density(i));
    success_rate(i) = sum(data_local(mask, 8) .* data_local(mask, 9) .* data_local(mask, 9));
end

figure('Name','Loco T');
