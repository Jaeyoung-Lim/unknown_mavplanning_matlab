clc; clear all;

%%
figure(1);
A =[0, 1, 1;
0.1, 0.999883, 0.969291;
0.2, 0.999348, 0.9505;
0.3, 0.997862, 0.933802;
0.4, 0.994183, 0.913757;
0.5, 0.675867, 0.529329;
0.6, 0.152367, 0.00128289;
0.7, 0.129455, 0.0008219;
0.8, 0.109173, 0.000500419;
0.9, 0.0846479, 0.000177421;
1.0, 0.0, 0.0];

Prob = A(:, 1);
Precision = A(:, 2);
Recall = A(:, 3);

plot(Precision, Recall, 'k-.'); hold on;
A =[0, 1, 1;
0.1, 0.99408, 0.918606;
0.2, 0.992274, 0.907984;
0.3, 0.990413, 0.89739;
0.4, 0.987975, 0.882306;
0.5, 0.675547, 0.528225;
0.6, 0.191765, 0.00667983;
0.7, 0.178246, 0.00574875;
0.8, 0.168268, 0.00512247;
0.9, 0.157679, 0.00441278;
1.0, 0.0, 0.0];

Prob = A(:, 1);
Precision = A(:, 2);
Recall = A(:, 3);

plot(Precision, Recall, 'k-'); hold on;

title('ROC Curve'); hold on;
xlabel('False Positive Rate'); hold on;
ylabel('True Positive Rate'); hold on;
legend('Hilbertmap EUROC VICON01 Easy', 'Hilbertmap EUROC VICON02 Medium', 'Hilbertmap EUROC VICON03 Difficult'); hold off;

%%
%%
figure(2);
A =[0, 1, 1;
0.1, 0.225437, 0.902591;
0.2, 0.170975, 0.884789;
0.3, 0.136737, 0.863401;
0.4, 0.113389, 0.842324;
0.5, 0.097127, 0.812933;
0.6, 0.0856356, 0.770432;
0.7, 0.0765638, 0.704669;
0.8, 0.0688839, 0.601355;
0.9, 0.0598219, 0.475486;
1.0, 0.0, 0.0];

Prob = A(:, 1);
Precision = A(:, 2);
Recall = A(:, 3);

plot(Precision, Recall, 'k-.'); hold on;

A =[0, 1, 1;
0.1, 0.385287, 0.920674;
0.2, 0.385287, 0.916604;
0.3, 0.368326, 0.91332;
0.4, 0.348538, 0.909277;
0.5, 0.28608, 0.88081;
0.6, 0.257466, 0.608657;
0.7, 0.257466, 0.587997;
0.8, 0.228755, 0.565466;
0.9, 0.213933, 0.506483;
1.0, 0.0, 0.0];

Prob = A(:, 1);
Precision = A(:, 2);
Recall = A(:, 3);

plot(Precision, Recall, 'k-'); hold on;

title('ROC Curve'); hold on;
xlabel('False Positive Rate'); hold on;
ylabel('True Positive Rate'); hold on;
legend('Hilbertmap TSDF Map', 'Hilbertmap Raw'); hold off;

