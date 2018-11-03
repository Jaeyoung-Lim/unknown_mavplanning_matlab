function [trajectory] = polynomial(map, initpos, finalpos)

path = a_star(map, initpos, finalpos);

path = shortcut_path(map, path);
trajectory = plan_path_waypoints(path);
trajectory = split_trajectory(map, trajectory);

end