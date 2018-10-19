function [table, gx, gy] = evaluate_on_grid(x_lims, y_lims, grid_size)
%EVALUTE_ON_GRID Summary of this function goes here
%   Detailed explanation goes here

grid_dim_x = uint32(round((x_lims(2) - x_lims(1))/grid_size));
grid_dim_y = uint32(round((y_lims(2) - y_lims(1))/grid_size));

table = zeros(grid_dim_x, grid_dim_y);
[gx, gy] = meshgrid(x_lims(1):grid_size:x_lims(2), y_lims(1):grid_size:y_lims(2));

table = dist_to_wall(gx, gy);


end

