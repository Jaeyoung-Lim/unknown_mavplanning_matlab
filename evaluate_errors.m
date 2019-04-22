

figure('Name','False Negative Rate');
% TSDF threshold = 0
x = [0, 0, 103086, 55158, 58046, 0, 0, 0, 0, 0];
xbins = -1:0.2:1-0.01;
bar(xbins, x); hold on;
sum(x)

% TSDF threshold = 1.0
x = [0, 0, 59271, 6063, 2441, 0, 0, 0, 0, 0,];
xbins = -1:0.2:1-0.01;
bar(xbins, x); hold on;
sum(x)

% TSDF threshold = 1.5
x = [0, 0, 3319, 115, 0, 0, 0, 0, 0, 0];
xbins = -1:0.2:1-0.01;
bar(xbins, x); hold on;
sum(x)

title('False Negative'); hold on;
legend('TSDF Threshold 0', 'TSDF Threshold 1.0', 'TSDF Threshold 1.5');
grid on;

figure('Name','False Positive Rate');


x = [0, 0, 0, 0, 0, 62331, 60247, 534941, 0, 0];
xbins = -1:0.2:1-0.01;
bar(xbins, x); hold on;
sum(x)
