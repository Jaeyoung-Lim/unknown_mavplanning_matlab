% Params
resolution_m = 20;
rng(0);
epsilon = 0.5;
num_samples = 500;

%% Setup & loading
map = load_map(resolution_m);

% Fill in map table and ESDF.
map_table = get_map_table(map);

[esdf_map, esdf_map_x, esdf_map_y] = get_esdf_map(map);

figure(1)
show(map)

figure(2)
plot_map_table(map, esdf_map)
caxis([-1, 2]);

% TODO: create a nice colormap for these...
cmap = colormap('parula');
cmap(ceil(end/3), :) = [1 1 1];
cmap(ceil(end/3)-1, :) = [1 1 1];
cmap(ceil(end/3)+1, :) = [1 1 1];
temp = cmap(1:ceil(end/3)+1, 1);
cmap(1:ceil(end/3)+1, 1) = cmap(1:ceil(end/3)+1, 3);
%cmap(1:ceil(end/3)+1, 3) = temp;
colormap(cmap);

%% Original TSDF Map Creation
% Create a sensor description.
sensor_desc = {};
sensor_desc.fov = deg2rad(70);
sensor_desc.range = 8;
sensor_desc.res_rad = 0.01;

tsdf_map = NaN(size(esdf_map));
% Fill in a tsdf map from this viewpoint
% Unseen space is dist = NaN

% Fill in map...
%tsdf_map = add_viewpoint(sensor_desc, [3, 3], 0, map, map_table, tsdf_map);

tsdf_map = add_random_viewpoints(sensor_desc, num_samples, map, map_table, tsdf_map);

figure(3)
plot_map_table(map, tsdf_map);
caxis([-1, 2]);
colormap(cmap);

%% Evaluation
% Get accuracy only really near the surface
% Discard any nans
% Basically, for all original esdf values in a range, grab the tsdf values,
% if not nan, compare. Also count number of nans.
for eps = [0.5, 10]
  [mean_error, std_dev, nan_ratio] = evaluate_sdf(esdf_map, tsdf_map, eps);
  fprintf('V: %d Epsilon: %f Mean error: %f St_dev: %f Nan Ratio: %f\n', num_samples, eps, mean_error, std_dev, nan_ratio);
end

%% Hybrid E/TSDF?
% Fill in ESDF values anywhere further than x from surface (don't use
% occupied/unoccupied, just go from the original values). Iterative.
% Have to keep track of which are the 'original' (fixed) values and which
% are derivative, as this is the only way to do it correctly when going off
% distances rather than occupied/free values.
% How to handle probability?

[hybrid_esdf_map] = fill_hybrid_esdf(tsdf_map, 1/resolution_m, epsilon);
figure(4)
plot_map_table(map, hybrid_esdf_map);
caxis([-1, 2]);
colormap(cmap);

fprintf('Hybrid\n');
for eps = [0.5, 10]
  [mean_error, std_dev, nan_ratio] = evaluate_sdf(esdf_map, hybrid_esdf_map, eps);
  fprintf('V: %d Epsilon: %f Mean error: %f St_dev: %f Nan Ratio: %f\n', num_samples, eps, mean_error, std_dev, nan_ratio);
end

%% Occupancy + ESDF generation
[occupancy_map] = fill_hybrid_esdf(tsdf_map, 1/resolution_m, 0);
figure(5)
plot_map_table(map, hybrid_esdf_map);
caxis([-1, 2]);
colormap(cmap);

fprintf('Occupancy + ESDF\n');
for eps = [0.5, 10]
  [mean_error, std_dev, nan_ratio] = evaluate_sdf(esdf_map, occupancy_map, eps);
  fprintf('V: %d Epsilon: %f Mean error: %f St_dev: %f Nan Ratio: %f\n', num_samples, eps, mean_error, std_dev, nan_ratio);
end

%% Evaluate gradient magnitude + direction
% Checking mask:
mask = ~isnan(tsdf_map) & tsdf_map > 0;

[egrad_x, egrad_y] = gradient(esdf_map);
[tgrad_x, tgrad_y] = gradient(tsdf_map);
[hgrad_x, hgrad_y] = gradient(hybrid_esdf_map);
[ograd_x, ograd_y] = gradient(occupancy_map);

fprintf('Gradients\n');
[mag_error, dir_error] = evaluate_gradient(egrad_x, egrad_y, mask, tgrad_x, tgrad_y);
fprintf('TSDF Mag error: %f Dir error: %f\n', mag_error, rad2deg(dir_error));
[mag_error, dir_error] = evaluate_gradient(egrad_x, egrad_y, mask, hgrad_x, hgrad_x);
fprintf('HSDF Mag error: %f Dir error: %f\n', mag_error, rad2deg(dir_error));
[mag_error, dir_error] = evaluate_gradient(egrad_x, egrad_y, mask, ograd_x, ograd_y);
fprintf('OSDF Mag error: %f Dir error: %f\n', mag_error, rad2deg(dir_error));