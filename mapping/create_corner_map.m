function map = create_corridor_map(width_m, height_m, resolution, num_samples, inflation)
%% Parameters
pst = 0.4;
ptt = 0;
corridor_width = 4;
corridor_length = 14;

fullgrid = ones(height_m*resolution, width_m*resolution);
map = robotics.BinaryOccupancyGrid(fullgrid, resolution);

segment_pose = [4, 16, 0];
map = set_corner(map, segment_pose, corridor_width, corridor_length, resolution);

end

function map = set_corner(map, segment_pose, corridor_width, corridor_length, resolution)
    segment_pose(3) = 0;
    r = create_straight(segment_pose, corridor_length, corridor_width, resolution);
    setOccupancy(map, r, 0);
    segment_pose(3) = 3*pi()/2;
    r = create_straight(segment_pose, corridor_length, corridor_width, resolution);
    setOccupancy(map, r, 0);

end