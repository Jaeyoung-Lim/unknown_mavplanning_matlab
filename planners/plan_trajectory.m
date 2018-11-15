function [T, path, path_vel]=plan_trajectory(planner_type, binary_occupancygrid, start_position, goal_position, start_velocity, goal_velocity)
%% Run Planner between start and endpoint depending on the planner type
if nargin < 5
    start_velocity = [0.0, 0.0];    
    goal_velocity = [0.0, 0.0];
elseif nargin < 6
    goal_velocity = [0.0, 0.0];
end
path_vel = [0.0, 0.0];

% binary_occupancygrid.inflate(0.5);

switch planner_type
    case 'a_star'
        path = a_star(binary_occupancygrid, start_position, goal_position);
    
    case 'polynomial'
        trajectory = polynomial(binary_occupancygrid, start_position, goal_position);        
        if isempty(trajectory)
            disp('empty')
        end
        [T, path] = sample_trajectory(trajectory, 0.1);
        
    case 'chomp'

        trajectory = continous_chomp(binary_occupancygrid, start_position, goal_position, start_velocity, goal_velocity);
        [T, path, path_vel] = sample_trajectory(trajectory, 0.1);
end