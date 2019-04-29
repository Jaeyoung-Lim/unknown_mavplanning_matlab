close all; clc; clear all;

%% Figure 1 Plot Occupancy probability depending on the cost
figure(1);
occprob = 0:0.01:1.0;

entropy_cost = zeros(size(occprob, 2), 1);
collision_cost = zeros(size(occprob, 2), 1);

for i = 1:size(occprob, 2)
    entropy_cost(i) = (-occprob(i))*log2(occprob(i)) - (1-occprob(i))*log2(1-occprob(i));

    collision_cost(i) = occprob(i);

end

plot(occprob, collision_cost, 'r');
hold on;
plot(occprob, entropy_cost, 'b');
hold on;

legend('occprob', 'entropy', '0.1*entropy +occprob', '0.3*entropy + occprob', 'entropy+ occprob');
title('Collision Cost and Uncertainty Cost');
xlabel('Occupancy Probability');
ylabel('Cost');

%% Figure 2 With True depth model
figure(2);
s = -10:0.1:10;
occprob = zeros(1, size(s, 2));

entropy_cost = zeros(size(occprob, 2), 1);
collision_cost = zeros(size(occprob, 2), 1);

for i = 1:size(occprob, 2)
    occprob(i) = qcdf(s(i)) - 0.5*qcdf(s(i)-3);

    entropy_cost(i) = (-occprob(i))*log2(occprob(i)) - (1-occprob(i))*log2(1-occprob(i));

    collision_cost(i) = occprob(i);

end
plot(s, collision_cost, 'r');
hold on;
plot(s, entropy_cost, 'b');
hold on;
plot(s, 0.1*entropy_cost+0.9*collision_cost, 'k-.');
hold on;
plot(s, 0.3*entropy_cost+collision_cost, 'k.');
hold on;
plot(s, 0.6*entropy_cost+collision_cost, 'k-');
hold on;
legend('occprob', 'entropy', '0.1*entropy +occprob', '0.3*entropy + occprob', 'entropy+ occprob');
title('Collision Cost and Uncertainty Cost');
xlabel('Occupancy Probability');
ylabel('Cost');

%% Figure 3 
figure(3);
plot(s, collision_cost, 'k--', 'LineWidth', 1.5); hold on; %% Occupancy Probability
occupancy = (-10:0.1:10 > 1);
plot(s, occupancy, 'b'); hold on; %% Occupancy Probability
plot(s, 0.3*entropy_cost+collision_cost, 'k-', 'LineWidth', 1.5); hold on;
title('Occupancy Probability', 'FontSize',12);
ylim([0, 1.2]);
xlabel('Position [m]', 'FontWeight','bold', 'FontSize',12);
ylabel('Cost', 'FontWeight','bold', 'FontSize',12);
legend('Occupancy Probability', 'Occupancy Ground Truth', 'Collision + Entropy', 'FontSize',12);
grid on;

function occprob = qcdf(s)
    if s <  -3
        occprob = 0.0;
    elseif s <= -1
        occprob = (1/48) * (3 + s)^3;
    elseif s < 1 
        occprob = 0.5 + (1/24) * s * (3 + s) * (3 - s);
    elseif s <= 3
        occprob = 1 - (1/48) * (3 -s)^3;
    else
        occprob = 1;
    end
end


