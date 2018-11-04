function [trajectory] = polynomial(map, initpos, finalpos)

% show(map); hold on;
% plot([initpos(1), finalpos(1)], [initpos(2), finalpos(2)], 'x');


path = a_star(map, initpos, finalpos);
path = [path(:, 2), path(:, 1)]; %TODO: This should be debugged on the mav_tools side
% plot(path(:, 1), path(:, 2));
path = shortcut_path(map, path);
trajectory = plan_path_waypoints(path);
trajectory = split_trajectory(map, trajectory);

end