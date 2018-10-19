function [cost_map, cost_map_x, cost_map_y] = get_esdf_map(map)
%GET_COST_MAP Summary of this function goes here
%   Detailed explanation goes here
map_table = get_map_table(map);
map_table = map_table/max(max(map_table));

Dext = double(bwdist(map_table));
Dint = -double(bwdist(1-map_table));

Dint(Dint < 0) = Dint(Dint < 0) + 1;

map_res = 1/map.Resolution;

% Debug - look at the distance maps.
%cost_map = Dint + Dext;
cost_map = map_res * (Dint + Dext);

if (nargout > 1)
  % Then also compute the cost map gradients.
  [cost_map_x, cost_map_y] = gradient(cost_map/map_res);
  % Have to flip cost map y.
  cost_map_y = -cost_map_y;
end
end

