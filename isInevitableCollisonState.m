function collision = isInevitableCollisonState(param, binmap, sample_pose)
    
    % This inevitable collision check is from Richter 2015collision = false;
    collision = false;
    
%     action_sets = gen_actionset(sample_pose);
%     
%     show(binmap);
    
    
    
end

function gen_actionset(pose)
    % Lets start with a naive search approach
    % The action set is from the actuator constrained car model
    k_dot_max = 1.0;
    k_max = 1.0;
    k = 1.0;
    
    k_dot_set = -k_dot_max*dt:dt:k_dot_max;
%     k_set =  = k + k_dot_set;
%     k_cmd_set = k_set(k_set < k_max);


end