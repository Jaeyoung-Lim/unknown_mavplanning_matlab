function [T, path]=plan_trajectory(planner_type, binary_occupancygrid, start_position, goal_position, goal_velocity, start_velocity)
%% Run Planner between start and endpoint depending on the planner type
if nargin < 6
    start_velocity = [0.0, 0.0];
    goal_velocity = [0.0, 0.0];
else if nargin < 5
    start_velocity = [0.0, 0.0];    
end


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

        trajectory = continous_chomp(binary_occupancygrid, start_position, goal_position);
        [T, path] = sample_trajectory(trajectory, 0.1);
end