function [map_conservative] = get_conservativemap(map, param, pose)
    %% Initialize
    % Returns optimistic map from 
    
    map_conservative = robotics.OccupancyGrid(double(map.occupancyMatrix), param.globalmap.resolution);
    map_conservative = robotics.BinaryOccupancyGrid(map_conservative.occupancyMatrix > map_conservative.FreeThreshold);
    
end