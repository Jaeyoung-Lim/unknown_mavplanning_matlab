close all; clc; clear all;

%% Plot Occupancy probability depending on the cost
figure(1);
occprob = 0:0.01:1.0;

entropy_cost = zeros(size(occprob, 2), 1);
collision_cost = zeros(size(occprob, 2), 1);
r = 0.01;

for i = 1:size(occprob, 2)
    dg = occprob(i) + r;
    entropy_cost(i) = (dg - abs(occprob(i)-0.5)) /dg;

end

plot(occprob, entropy_cost, 'k');
hold on;
title('Goal cost');
xlabel('distance to goal');
ylabel('goal cost');