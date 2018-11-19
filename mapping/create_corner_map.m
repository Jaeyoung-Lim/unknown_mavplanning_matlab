function map = create_corridor_map(width_m, height_m, resolution, num_samples, inflation)

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