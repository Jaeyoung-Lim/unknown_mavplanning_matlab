function [occupancy_table] = make_occupancy_map(x_lims, y_lims, grid_size)
%MAKE_TSDF_MAP Summary of this function goes here
%   Detailed explanation goes here
sensor_pos(1) = x_lims(1);
sensor_pos(2) = y_lims(2)/2;

sensor_pos_scaled = sensor_pos / grid_size;

% Fov is 90 degrees...
% I guess cast a bunch of rays??? One per end pixel?

% Number of rays scales with voxel size for ease...
min_y_ind = 0;
max_y_ind = y_lims(2)/grid_size;

% Ray equations for the skew line.
% y = mx + b
skew_line = [2 -2];

grid_dim_x = uint32(round((x_lims(2) - x_lims(1))/grid_size)) + 1;
grid_dim_y = uint32(round((y_lims(2) - y_lims(1))/grid_size)) + 1;
occupancy_table = -ones(grid_dim_x, grid_dim_y);

for (i = min_y_ind:max_y_ind)
  % Ray equations.
  % mx + b = 0
  sensor_line = [(i*grid_size-1)/2, 1];
  
  % Now figure out where we actually hit.
  pos = get_line_intercept(skew_line, sensor_line);
  
  [ray_indices] = cast_ray(sensor_pos_scaled, [x_lims(2)/grid_size, i]);
  %sensor_pos_scaled
  %pos / grid_size
  %ray_indices
  % Update all cells along the ray.
  for (j = 1:size(ray_indices, 1))
    ray_pos_scaled = ray_indices(j, :) * grid_size;
    if (round(pos(1)/grid_size) <= ray_indices(j, 1))
      occupancy_table(ray_indices(j, 2) + 1, ray_indices(j, 1) + 1) = 1;
      break;
    elseif (occupancy_table(ray_indices(j, 2) + 1, ray_indices(j, 1) + 1) < 0)
      occupancy_table(ray_indices(j, 2) + 1, ray_indices(j, 1) + 1) = 0;
    end
  end
  
  
  [ray_indices] = cast_ray(sensor_pos_scaled, pos / grid_size);
  for (j = 1:size(ray_indices, 1) - 1)
    if (occupancy_table(ray_indices(j, 2) + 1, ray_indices(j, 1) + 1) < 0)
      occupancy_table(ray_indices(j, 2) + 1, ray_indices(j, 1) + 1) = 0;
    end
  end
  occupancy_table(ray_indices(end, 2) + 1, ray_indices(end, 1) + 1) = 1;

  
  % waitbar(i/max_y_ind);
%     imagesc(x_lims, y_lims, occupancy_table)
%    xs = [x_lims(1):grid_size:x_lims(2)];
%    plot(xs, sensor_line(1).*xs + sensor_line(2));
%    plot(pos(1), pos(2), 'o');
%   pause;
end

end