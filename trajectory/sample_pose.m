function [pose] = sample_pose(map_width, map_height)
% Sample free space from a Binary Occupancy gridmap

% map_corner = [map.XWorldLimits(1), map.YWorldLimits(1)];
% map_width = map.XWorldLimits(2) - map.XWorldLimits(1);
% map_height = map.YWorldLimits(2) - map.YWorldLimits(1);

map_corner = [0, 0];


while true
    pos = rand(1,2)*diag([map_width, map_height])  + map_corner;
%      if ~getOccupancy(map, pos)
%         break;
%      end
break;
 end
% Sample mav yaw
yaw = 2* pi()*rand();

pose = [pos, yaw];

end