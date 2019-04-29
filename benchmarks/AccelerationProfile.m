clc; close all; clear all;
data_dir = '/home/jaeyoung/data/';

% %% Acceleration Trajectory
% 
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

ori = [1.0, 0.0, 0.0, 0.0];
pos = [0.0, 0.0, 0.0];
clr = 'k';
drawSkelQuadrotor(1.0, ori, pos, clr);
axis equal;

function drawSkelQuadrotor(scale, orientation, position, clr)

R = quat2rotm(orientation);
r1_pos = position + (R*scale*[0.17, 0, 0.0]')';
r2_pos = position + (R*scale*[-0.17, 0, 0.0]')';
r3_pos = position + (R*scale*[0, 0.17, 0.0]')';
r4_pos = position + (R*scale*[0, -0.17, 0.0]')';

m1_pos = position + (R*scale*[0.17, 0, -0.05]')';
m2_pos = position + (R*scale*[-0.17, 0, -0.05]')';
m3_pos = position + (R*scale*[0, 0.17, -0.05]')';
m4_pos = position + (R*scale*[0, -0.17, -0.05]')';
      
arm1 = [m1_pos; m2_pos];
arm2 = [m3_pos; m4_pos];

motor1 = [m1_pos;r1_pos];
motor2 = [m2_pos;r2_pos];
motor3 = [m3_pos;r3_pos];
motor4 = [m4_pos;r4_pos];

plot3(motor1(:, 1), motor1(:, 2), motor1(:, 3), clr, 'MarkerFaceColor', 'k', 'LineWidth', 2); hold on;
plot3(motor2(:, 1), motor2(:, 2), motor2(:, 3), clr, 'MarkerFaceColor', 'k', 'LineWidth', 2); hold on;
plot3(motor3(:, 1), motor3(:, 2), motor3(:, 3), clr, 'MarkerFaceColor', 'k', 'LineWidth', 2); hold on;
plot3(motor4(:, 1), motor4(:, 2), motor4(:, 3), clr, 'MarkerFaceColor', 'k', 'LineWidth', 2); hold on;

plot3(arm1(:, 1), arm1(:, 2), arm1(:, 3), clr, 'MarkerFaceColor', 'k', 'LineWidth', 2); hold on;
plot3(arm2(:, 1), arm2(:, 2), arm2(:, 3), clr, 'MarkerFaceColor', 'k', 'LineWidth', 2); hold on;

plotCircle3D(r1_pos,R(:,3)',scale*0.1); hold on;
plotCircle3D(r2_pos,R(:,3)',scale*0.1); hold on;
plotCircle3D(r3_pos,R(:,3)',scale*0.1); hold on;
plotCircle3D(r4_pos,R(:,3)',scale*0.1); hold on;

end

function plotCircle3D(center,normal,radius)

theta=0:0.01:2*pi;
v=null(normal);
points=repmat(center',1,size(theta,2))+radius*(v(:,1)*cos(theta)+v(:,2)*sin(theta));
plot3(points(1,:),points(2,:),points(3,:),'r-');

end
