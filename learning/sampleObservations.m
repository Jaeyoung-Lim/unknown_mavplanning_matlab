function [xy, y] = sampleObservations(free_space, occupied_space, xy, y)
    freespace = free_space(randi([1 size(free_space, 1)], min(5, size(free_space, 1)), 1), :);
    occupiedspace = occupied_space(randi([1 size(occupied_space, 1)], min(3, size(occupied_space, 1)), 1), :);
    xy = [xy; occupiedspace];
    y = [y; ones(size(occupiedspace, 1), 1)];
    xy = [xy; freespace];
    y = [y; -1 * ones(size(freespace, 1), 1)];

end