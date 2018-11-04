function [map_optimistic] = get_optimisticmap(map, param, pose)
    %% Initialize
    % Returns optimistic map from 
    
    map_optimistic = robotics.OccupancyGrid(double(map.occupancyMatrix), param.globalmap.resolution);
    map_optimistic = robotics.BinaryOccupancyGrid(map_optimistic.occupancyMatrix > map_optimistic.OccupiedThreshold, param.globalmap.resolution);
    
end