clc; clear all; close all;
%% Global Hilbert Planner Benchmark

res = [0.5, 1.0, 1.5, 2.0];
query_time1 =      [0.000386, 00.000032, 00.000007, 00.000003];
query_time_sigma= [0.000160];
loco_time =       [00.614529];
loco_time_sigma = [00.614529];

query_time2 = query_time1;

figure('Name','Success Rate and Planning Time');
bar(res, 1000* [query_time1', query_time2'], 'grouped');
title('Faulure Rate, Planning Time with Hilbert Map Resoultion');
xlabel('Resolution [Feature/m]');
xticks(0.5:0.5:2.0);
ylabel('Failure Rate');
legend('Global Hilbert Map','Local Hilbert Map');