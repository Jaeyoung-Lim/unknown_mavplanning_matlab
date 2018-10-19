function [sdf_table, sigma_table, cost_table] = make_sdf_likelihood(x_lims, y_lims, grid_size)
%MAKE_TSDF_MAP Summary of this function goes here
%   Detailed explanation goes here
sensor_pos(1) = x_lims(1);
sensor_pos(2) = y_lims(2)/2;

sensor_pos_scaled = sensor_pos / grid_size;

% Fov is 90 degrees...
% I guess cast a bunch of rays??? One per end pixel?

% Number of rays scales with voxel size for ease...
num_inds = 100;
min_y_ind = 0;
max_y_ind = y_lims(2)/grid_size;

% Ray equations for the skew line.
% y = mx + b
skew_line = [2 -2];

grid_dim_x = uint32(round((x_lims(2) - x_lims(1))/grid_size)) + 1;
grid_dim_y = uint32(round((y_lims(2) - y_lims(1))/grid_size)) + 1;
sdf_table = -ones(grid_dim_x, grid_dim_y);
sigma_table = sdf_table;
votes = cell(grid_dim_x, grid_dim_y);

for (i = min_y_ind:num_inds)
  x = x_lims(2)/grid_size;
  y = i * y_lims(2)/(grid_size*num_inds);
  [ray_indices] = cast_ray(sensor_pos_scaled, ...
      [x, y]);
  
  % Now figure out where we actually hit.
  
  % Ray equations.
  % mx + b = 0
  sensor_line = [(y*grid_size-1)/2, 1];
  
  noise = normrnd(0, 0.5);

  pos = get_line_intercept(skew_line, sensor_line) + noise;
  
  % Update all cells along the ray.
  for (j = 1:size(ray_indices, 1))
    %if (nnz(ray_indices(j, :)) ~= 2)
    %  continue;
    %end
    ray_pos_scaled = ray_indices(j, :) * grid_size;
    distance = norm(ray_pos_scaled - pos);
    if (pos(1) < ray_pos_scaled(1))
      distance = -distance;
    end
    votes{ray_indices(j, 2) + 1, ray_indices(j, 1) + 1} = ...
      horzcat(votes{ray_indices(j, 2) + 1, ray_indices(j, 1) + 1}, distance);
    %sdf_table(ray_indices(j, 2) + 1, ray_indices(j, 1) + 1) = distance;
  end
    
  % waitbar(i/max_y_ind);
    
   %xs = [x_lims(1):grid_size:x_lims(2)];
   %plot(xs, sensor_line(1).*xs + sensor_line(2), 'w');
   %plot(pos(1), pos(2), 'ow');
  
end

% Iterate over all votes and create the map by averaging.
for i = 1:size(votes, 1)
  for j = 1:size(votes, 2)
    if ~isempty(votes{i, j})
      sdf_table(i, j) = mean(votes{i, j});
      sigma_table(i, j) = std(votes{i, j});
    end
  end
end

% Cache the original values.
means = sdf_table;
stds = sigma_table;

% Costs
[cost_table_x, cost_table_y] = gradient(means);
cost_table = sqrt(cost_table_x .^2 + cost_table_y .^2);
end