function p = render_hilbertmap(param, wt, map)
% Reconstruct the hilbert map
    high_res = param.hilbertmap.render_resolution;
    map_width = map.XWorldLimits(2)* high_res;
    map_height = map.YWorldLimits(2) * high_res;
    p = 0.5*ones(map_width, map_height);
    for i = 1:map_width
        for j = 1:map_height
            x = [i, j] * 1/ high_res;
            p(i, j) = occupancyProb(param, wt, x, map);
        end
    end
end