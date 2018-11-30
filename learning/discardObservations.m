function [xy, y] = discardObservations(param, xy, y, pose)
    size(xy, 1)
    map_mask = vecnorm(xy - pose(1:2), 2, 2) < param.localmap.width;
    xy = xy(map_mask, :);
    y = y(map_mask, :);
    size(xy, 1)

end