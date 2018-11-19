function [trajectory] = polynomial(map, initpos, finalpos, init_derivatives, end_derivatives)

path = a_star(map, [initpos(2), initpos(1)], [finalpos(2), finalpos(1)]);
if isempty(path)
  return;
end
path = shortcut_path(map, path);

trajectory = plan_path_waypoints(path, init_derivatives, end_derivatives);
trajectory = split_trajectory(map, trajectory);

end