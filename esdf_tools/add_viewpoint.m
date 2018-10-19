function tsdf_map = add_viewpoint(sensor_desc, pos, yaw, map, map_table, tsdf_map)

% Settings, maybe pull from sensor later.
%distance_behind_m = 5;
distance_behind_m = 0.5;
distance_behind_voxel = distance_behind_m * map.Resolution;

% Convert the position to table coordinates
[table_pos_x, table_pos_y] = world_to_table_pos(pos, map);
table_pos = [table_pos_x, table_pos_y];

% First make sure we're actually in empty space.
if (map_table(table_pos_x, table_pos_y) > 0) 
  disp 'NOT EMPTY POSE';
  return
end

% Then ray-cast out for every ray in the sensor.
min_yaw = yaw - sensor_desc.fov/2;
max_yaw = yaw + sensor_desc.fov/2;
% Don't need to wrap here, we'll wrap when raycasting.

voxel_size = 1/map.Resolution;
max_voxels = sensor_desc.range/voxel_size;

% Hmm so we start at the table position...
for curr_yaw = min_yaw:sensor_desc.res_rad:max_yaw
  % Start casting a ray out.
  surface_distance = -1;
  ray_vector = [sin(curr_yaw), cos(curr_yaw)];
  for i = 1:max_voxels
    voxel_pos = int32(round(double(table_pos) + i * ray_vector));
    if (map_table(voxel_pos(1), voxel_pos(2)) > 0)
      surface_distance = i;
      break;
    end
  end
  
  if (surface_distance > 0)
    % Now go back and set distances.
    for i = 1:max_voxels
      voxel_pos = int32(double(table_pos) + i * ray_vector);
      % Get the measurement at this point in the ray...
      point_distance = (surface_distance - i) * voxel_size;
      if (any(voxel_pos > size(tsdf_map)) || any(voxel_pos < 1))
        break;
      end
      
      if (i > surface_distance + distance_behind_voxel) 
        break;
      end
      
      if (isnan(tsdf_map(voxel_pos(1), voxel_pos(2))))
        tsdf_map(voxel_pos(1), voxel_pos(2)) = point_distance;
      else
        % Combination strategy: average
%         tsdf_map(voxel_pos(1), voxel_pos(2)) = (tsdf_map(voxel_pos(1), voxel_pos(2)) + point_distance)/2;
        
        % Combination strategy: min distance if previous distance outside
        % obstacle.
        if (tsdf_map(voxel_pos(1), voxel_pos(2)) > 0 && point_distance > 0)
          tsdf_map(voxel_pos(1), voxel_pos(2)) = min(tsdf_map(voxel_pos(1), voxel_pos(2)), point_distance);
        elseif (tsdf_map(voxel_pos(1), voxel_pos(2)) < 0 && point_distance > 0)
          tsdf_map(voxel_pos(1), voxel_pos(2)) = point_distance;
        else
          tsdf_map(voxel_pos(1), voxel_pos(2)) = max(tsdf_map(voxel_pos(1), voxel_pos(2)), point_distance);
        end
      end
    end
  end
  
end

end