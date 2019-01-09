function [map_optimistic] = get_optimisticmap(occupancymap, param, pose)
    %% Initialize
    % Returns optimistic map from 
    map = occupancymap.localmap; %% This is not right    
    map_optimistic = robotics.OccupancyGrid(double(map.occupancyMatrix), param.globalmap.resolution);
    map_optimistic = robotics.BinaryOccupancyGrid(map_optimistic.occupancyMatrix > map_optimistic.OccupiedThreshold, param.globalmap.resolution);
    
end