function [mean_error, std_dev, nan_ratio] = evaluate_sdf(esdf_map, tsdf_map, epsilon)
% First, select all the points in the matrix that are within epsilon.
% Let's just do outside the obstacle actually: 0 to epsilon.
% Inside the obstacle doesn't matter as much, etc.

logic_map = esdf_map >= 0 & esdf_map < epsilon;

errors = tsdf_map(logic_map) - esdf_map(logic_map);

valid_errors = errors(~isnan(errors));

mean_error = mean(abs(valid_errors));
std_dev = std(abs(valid_errors));
nan_ratio = nnz(isnan(errors))/length(errors);
end
