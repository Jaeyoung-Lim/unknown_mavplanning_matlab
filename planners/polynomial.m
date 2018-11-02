function [trajectory] = polynomial(map, initpos, finalpos)


waypoints = [initpos; finalpos]; % Works nicely with tree level 1.

% trajectory = plan_path_waypoints(waypoints);
[~, trajectory] = replan_segment(map, waypoints(1, :), waypoints(2, :));

end