function [X, Y] = getObservation(param, map, pose)
    scale_distance = 10;
    scale_angle = pi();
    scale_length = 15;
    
    o = getLaserScan(map, pose, param);
    % Decide wich region we are in and simulate both corners
    s = pose(3) - 0.5*pi();
    l = abs(pose(2) - 18);
    X = (o / scale_distance )';
    Y = [s / scale_angle; l / scale_length];
    
end