function [goal, goal_vel] = getNextBestView(param, binmap, pose, global_goal, map, hilbertmap)
    %% Next best view planner from Oleynikova 2017
    % Parameters
    num_samples = 80;
    we = 0.01;
    wg = 0.4;
    r = 0.5;
    vel = 3.0;

    %%
    mav_pos = pose(1:2); 
    l = zeros(num_samples, 1);
    R = zeros(num_samples, 1);
    pos = zeros(num_samples ,2);
    yaw = zeros(num_samples, 1);
    sample_yaw = 0.0;
    
    for i=1:num_samples
        sample_pos = samplePosfromMap(binmap);
        pos(i, :) = sample_pos;
        switch param.localgoal
            case 'nextbestview'
                sample_yaw = atan2(sample_pos(2) - mav_pos(2), sample_pos(1) - mav_pos(1)); % From Oleynikova 2017
                vel = 0.0;
            case {'nextbestview-yaw', 'nextbestview-hilbert'}
                sample_yaw = 2*pi()*rand();
                yaw(i) = sample_yaw;
                vel = 1.0;
        end
        sample_pose = [sample_pos, sample_yaw];
        l(i) = getExplorationgain(param, map, sample_pose);
        dg = norm(global_goal-mav_pos) + r;
        R(i) = we * l(i) + wg * (dg  - norm(global_goal - sample_pos))/dg;
    end
    [~, idx] = max(R);
    goal = pos(idx, :);
    goal_vel = vel * [cos(yaw(idx)), sin(yaw(idx))];
    
    switch param.localgoal
        case 'nextbestview-hilbert'
            while true
                dl = getMIGradient(param, map, goal, goal_vel, hilbertmap);
                [goal, goal_vel] = updateLocalGoal(dl, goal, goal_vel, hilbertmap);
            end
    end
end

function [goal, goal_vel] = updateLocalGoal(dl, goal, goal_vel, hilbertmap)
    goal = goal + 1000*dl;
    goal_vel = goal_vel;
end