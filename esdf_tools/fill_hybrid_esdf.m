function [tsdf_map] = fill_hybrid_esdf(tsdf_map, res, epsilon)
% Easy logic.
% Go through each cell.
% For each cell, if it's not within epsilon of the surface, check its
% neighbors (4-conn)
% If the value + 1 is lower than its current value, update current value.
% Let's update all cells until no updates are made.
% Or actually keep track of queue...

siz = size(tsdf_map);

max_ind = siz(1) * siz(2);

queue = [];

updated = 1;
% Go through all voxels once.
while (updated ~= 0) 
  updated = 0;
  for i = 1:max_ind
    % Suitable for update: filled in, not in crust, outside object.
    if (~isnan(tsdf_map(i)) && abs(tsdf_map(i)) > epsilon && tsdf_map(i) > -1)
      updated = 0;
      neighbors = get_neighbors(siz, i);
      for j = 1:length(neighbors)
        if (tsdf_map(neighbors(j)) <= -1)
          continue;
        end
        if (tsdf_map(neighbors(j)) + res < tsdf_map(i))
          tsdf_map(i) = tsdf_map(neighbors(j)) + res;
          updated = 1;
        end
      end
      if (updated)
        queue = [queue neighbors];
      end
    end
  end
end

% % Now just handle the queue.
queue = unique(queue);
while ~isempty(queue)
  i = queue(1);
  
  % Suitable for update: filled in, not in crust, outside object.
  if (~isnan(tsdf_map(i)) && abs(tsdf_map(i)) > epsilon && tsdf_map(i) > -1)
    updated = 0;
    neighbors = get_neighbors(siz, i);
    for j = 1:length(neighbors)
      if (tsdf_map(neighbors(j)) <= -1)
        continue;
      end
      if (tsdf_map(neighbors(j)) + res < tsdf_map(i))
        tsdf_map(i) = tsdf_map(neighbors(j)) + res;
        updated = 1;
      end
    end
    if (updated)
      %queue = [queue neighbors];
    end
  end
  
  queue = unique(queue(2:end));
end
end

function inds = get_neighbors(siz, ind)
inds = [];
[row, col] = ind2sub(siz, ind);
% 4-conn
new_row = row + 1;
new_col = col;
if (in_range(siz, new_row, new_col))
  inds(end+1) = sub2ind(siz, new_row, new_col);
end

new_row = row - 1;
new_col = col;
if (in_range(siz, new_row, new_col))
  inds(end+1) = sub2ind(siz, new_row, new_col);
end

new_row = row;
new_col = col + 1;
if (in_range(siz, new_row, new_col))
  inds(end+1) = sub2ind(siz, new_row, new_col);
end

new_row = row;
new_col = col - 1;
if (in_range(siz, new_row, new_col))
  inds(end+1) = sub2ind(siz, new_row, new_col);
end
end

function valid = in_range(siz, row, col)
if (row <= siz(1) && col <= siz(2) && row >= 1 && col >= 1)
  valid = 1;
else
  valid = 0;
end
end