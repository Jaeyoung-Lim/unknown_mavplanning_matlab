function hilbertmap = discardObservations(param, hilbertmap, pose)

    map_mask = vecnorm(hilbertmap.xy - pose(1:2), 2, 2) < param.localmap.width;
    hilbertmap.xy = hilbertmap.xy(map_mask, :);
    hilbertmap.y = hilbertmap.y(map_mask, :);

end