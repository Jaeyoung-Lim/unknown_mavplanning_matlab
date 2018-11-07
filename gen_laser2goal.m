function gen_laser2goal(params, map, videoObj)
%% Make a plan using A*.
X = []; % Input states for learning
T = []; % Target states

global_start = params.start_point;
global_goal = params.goal_point;
mavPose = [global_start, 0.0]; % Current position starts from global start

[mavT, mavPath] = plan_trajectory('polynomial', map, global_start, global_goal);

% hold off;
for i=1:numel(mavT)        
    %% Move along local trajectory
    t = mavT(i);
    mavPose = posefromtrajectoy(mavPath, mavT, t);
    
    %% Get local observations
    [reference_goal, observation_data, intermediate_goal] = generateData(mavPose, t, mavT, mavPath, map, params);
    
    X = [X, [reference_goal, observation_data]'];
    T = [T, intermediate_goal'];
    
    
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

end
