close all; clc; clear all;

%% Plot Occupancy probability depending on the cost
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

%% With True depth model
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