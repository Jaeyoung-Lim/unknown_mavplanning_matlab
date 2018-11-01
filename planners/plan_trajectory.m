function [T, path]=plan_trajectory(planner_type, binary_occupancygrid, start_position, goal_position)

% Run global planner
switch planner_type
    case 'a_star'
        path = a_star(binary_occupancygrid, start_position, goal_position);
    case 'chomp'
        trajectory = continous_chomp(binary_occupancygrid, start_position, goal_position);
        [T, path] = sample_trajectory(trajectory, 0.1);
end