function [xy, y] = discardObservations(param, xy, y, pose)
    map_mask = vecnorm(xy - pose(1:2), 2, 2) > 0.5*param.localmap.width;
    xy = xy(map_mask, :);
    y = y(map_mask, :);

end