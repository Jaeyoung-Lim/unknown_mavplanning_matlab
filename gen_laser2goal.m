function [T, X] = gen_laser2goal(params, map)
%% Make a plan using A*.
X = []; % Input states for learning
T = []; % Target states
plan_horizon = 10;
global_start = params.start_point;
global_goal = params.goal_point;

[mavT, mavPath] = plan_trajectory('polynomial', map, global_start, global_goal);
mavPos = mavPath(1, :);
mavYaw = atan2(mavPath(2, 2) - mavPath(1, 2), mavPath(2, 1) - mavPath(1, 1)); 
mavPose = [mavPos, mavYaw]; % Current position starts from global start

%% Get local observations
[reference_goal, observation_data, intermediate_goal] = generateData(mavPose, plan_horizon, mavT, mavPath, map, params);
theta_ref = atan2(reference_goal(2), reference_goal(1)) - mavYaw;
d_ref = norm(reference_goal, 2);
theta_int = atan2(intermediate_goal(2), intermediate_goal(1)) - mavYaw;
d_int = norm(intermediate_goal, 2);
X = [d_ref, theta_ref, observation_data];
T = [d_int, theta_int];

if params.visualization=='summary'
    show(map); hold on;
    plot(mavPath(:, 1), mavPath(:, 2), 'b'); hold on;
    plot(mavPose(1), mavPose(2), 'xr'); hold on;
    plot(global_start(1), global_start(2), 'xb'); hold on;
    plot(reference_goal(1), reference_goal(2), 'ob'); hold on;
    plot(global_goal(1), global_goal(2), 'xg'); hold on;
    hold off;
    drawnow
end
end