function [goal, goal_vel] = getNextBestView(param, binmap, pose, global_goal, map, hilbertmap)
    %% Next best view planner from Oleynikova 2017
    % Parameters
    num_samples = 80;
    r = 0.5;
    vel = 3.0;

    %%
    mav_pos = pose(1:2); 
    l = zeros(num_samples, 1);
    R = zeros(num_samples, 1);
    pos = zeros(num_samples ,2);
    yaw = zeros(num_samples, 1);
    sample_yaw = 0.0;
    
    goal = global_goal;
    goal_vel = vel*[cos(pose(3)), sin(pose(3))];
    
    switch param.localgoal
        case {'nextbestview', 'nextbestview-yaw'}
            for i=1:num_samples
                sample_pos = samplePosfromMap(binmap); % Sample from conservative binary occupancy map
                pos(i, :) = sample_pos;
                switch param.localgoal
                    case 'nextbestview'
                        we = 0.01;
                        wg = 100;
                        sample_yaw = atan2(sample_pos(2) - mav_pos(2), sample_pos(1) - mav_pos(1)); % From Oleynikova 2017
                        vel = 0.0;
                        sample_pose = [sample_pos, sample_yaw];
                    case 'nextbestview-yaw'
                        we = 0.01;
                        wg = 0.4;
                        sample_yaw = 2*pi()*rand();
                        yaw(i) = sample_yaw;
                        vel = 1.0;
                        sample_pose = [sample_pos, sample_yaw];
                end
                
                l(i) = getExplorationgain(param, map, sample_pose);
                dg = norm(global_goal-mav_pos) + r;
                R(i) = we * l(i) + wg * (dg  - norm(global_goal - sample_pos))/dg;
                [~, idx] = max(R);
                goal = pos(idx, :);
                goal_vel = vel * [cos(yaw(idx)), sin(yaw(idx))];
            end
        case 'nextbestview-hilbert'
            we = 1;
            wg = 0.4;
            vel = 1.0;
            % Get a intermediate goal point
            goal = mav_pos + 0.5*param.sensor.maxrange * [cos(pose(3)), sin(pose(3))];
            
            while true % Update intermediate goal point with gradients
                [dl, l] = getMIGradient(param, map, goal, goal_vel, hilbertmap); %Information cost
                [dg, g] = getGoalGradient(mav_pos, goal, global_goal, r); % Goal directed cost
                
                R = we * (-l) + wg * g;
                dR = we * (-dl) + wg * dg;
                % Limit goal update to within map
                int_goal = goal+ 10 * dR;
                if binmap.getOccupancy(goal)
                    goal = int_goal;                
                end
                
                fprintf('goalcost: %d infcost: %d ratio: %d\n', l, g, l/g);
                if norm(goal - int_goal) <= 1e-1
                    break;
                end
            end
    end
end

function [dg, g] = getGoalGradient(mav_pos, goal, global_goal, r)
    goal_dist = norm(global_goal-mav_pos) + r;
    g  = (goal_dist  - norm(global_goal - goal))/goal_dist;
    dg = (global_goal - goal)/goal_dist;
end