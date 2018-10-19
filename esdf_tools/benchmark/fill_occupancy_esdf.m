function [occupancy_esdf_table] = fill_occupancy_esdf(occupancy_table, grid_size)
Dext = double(bwdist(occupancy_table > 0));
%Dint = -double(bwdist(1 - occupancy_table));

%Dint(Dint < 0) = Dint(Dint < 0) + 1;

% Debug - look at the distance maps.
%cost_map = Dint + Dext;
occupancy_esdf_table = -ones(size(occupancy_table));
occupancy_esdf_table(occupancy_table > -1) = grid_size * Dext(occupancy_table > -1);

end
