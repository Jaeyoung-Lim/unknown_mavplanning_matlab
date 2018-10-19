function tsdf_map = add_random_viewpoints(sensor_desc, num_viewpoints, map, map_table, tsdf_map)

% Number of points sampled already.
i = 0;

while i < num_viewpoints
  % Sample a random position
  pos(1) = map.XWorldLimits(2) * rand();
  pos(2) = map.YWorldLimits(2) * rand();
  [table_pos_x, table_pos_y] = world_to_table_pos(pos, map);
  table_pos = [table_pos_x, table_pos_y];

  if (map_table(table_pos_x, table_pos_y) > 0) 
    continue;
  end

  % Sample a random yaw between 0 and 360
  % 0 and 2-pi
  yaw = 2*pi*rand();

  tsdf_map = add_viewpoint(sensor_desc, pos, yaw, map, map_table, tsdf_map);

  i = i+1;
end

end