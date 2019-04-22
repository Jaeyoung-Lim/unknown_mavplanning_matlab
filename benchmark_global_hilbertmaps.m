close all; clear all;

%% Global Hilbert Planner Benchmark

res = [0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0];
success_rate = [1, 0.86, 0.64, 0.36, 0.32, 0.34, 0.22];
query_time =      [0.000386, 00.000093, 00.000032, 00.000010, 00.000007, 00.000008, 00.000003];
query_time_sigma= [0.000160, 00.000014, 00.000007, 00.000008, 00.000005, 00.000005, 00.000007];
loco_time =       [00.614529, 00.102769, 00.029012, 00.013519, 00.019476, 00.022391, 00.014959];
loco_time_sigma = [00.614529, 00.075663, 00.022711, 00.007863, 00.009262, 00.024029, 00.009406];
planning_time =   [13.54,         3.313,     1.119,     0.467,     0.671,     0.835,    0.4713];

figure('Name','Planning Time');
plot(res, planning_time, 'ko-');
xlim([0, 2.5]);
ylim([0, 15]);
title('Planning Time vs Resoultion');
xlabel('Resolution [Feature/m]');
ylabel('Planning Time [ms]');

figure('Name','Loco Time');
plot(res, loco_time, 'ko-');
xlim([0, 2.5]);
ylim([0, 1]);
title('Planning Time vs Resoultion');
xlabel('Resolution [Feature/m]');
ylabel('Planning Time [ms]');

figure('Name','Query Time');
plot(res, 1000*query_time, 'ko-');
xlim([0, 2.5]);
ylim([0, 0.5]);
title('Query Time vs Resoultion');
xlabel('Resolution [Feature/m]');
ylabel('Query Time [ms]');

figure('Name','Success Rate');
plot(res, success_rate, 'ko-');
xlim([0, 2.5]);
ylim([0, 1.0]);
title('Success Rate vs Resoultion');
xlabel('Resolution [Feature/m]');
ylabel('Query Time [ms]');

figure('Name','Success Rate and Planning Time');
yyaxis left;
plot(res, planning_time, 'bx--', 'LineWidth',1.5); hold on;
ylim([0, 15]);
yticks(0:2:15);
ylabel('Planning Time [s]');
yyaxis right;
plot(res, 1-success_rate, 'ro--', 'LineWidth',1.5);
ylim([0, 1.0]);
xlim([0, 2.5]);
title('Faulure Rate, Planning Time with Hilbert Map Resoultion');
xlabel('Resolution [Feature/m]');
ylabel('Failure Rate');