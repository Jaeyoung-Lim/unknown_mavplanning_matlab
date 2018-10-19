figure_path = '../figures//';
do_print = 0;
font_size = 20;

xlims = [0, 2];
ylims = [0, 2];
grid_size = 0.25;
epsilon = 0.75;
% Create ground truth.
[esdf_table, gx, gy] = evaluate_on_grid(xlims, ylims, grid_size);

% Create original tables.
[tsdf_table] = make_tsdf_map(xlims, ylims, grid_size);
[tsdf_table] = truncate_tsdf(tsdf_table, epsilon);
[occupancy_table] = make_occupancy_map(xlims, ylims, grid_size);
%[etsdf_table] = fill_hybrid_esdf(tsdf_table, grid_size, epsilon);
%[occupancy_esdf_table] = fill_occupancy_esdf(occupancy_table, grid_size);

% Calculate errors.
%[tsdf_err_table, tsdf_err] = calc_error(esdf_table, tsdf_table);
%[etsdf_err_table, etsdf_err] = calc_error(esdf_table, etsdf_table);
%[occupancy_esdf_err_table, occupancy_esdf_err] = calc_error(esdf_table, occupancy_esdf_table);

% Create colormaps.
cmap = create_cmap(0);
error_cmap = create_error_cmap();
occupancy_cmap = [0.75 0.75 0.75; 1 1 1; 0 0 0];

figure(1)
imagesc(xlims, ylims, esdf_table);
set(gca, 'Ydir', 'normal');
axis image;
caxis([-1, 2]);
colormap(cmap);
c = colorbar;
hold on;
xlabel('x position [m]');
ylabel('y position [m]');
ylabel(c, 'Signed Distance [m]')
title('True Euclidean Distance')
xs = 1:0.1:2;
ys = slanted_wall_func(xs);
plot(xs, ys, 'k', 'LineWidth', 5); 
axis(horzcat(xlims, ylims));
set(gca,'FontSize', font_size);
if (do_print)
  print('-dpng', [figure_path 'esdf.png']);
  print('-depsc', [figure_path 'esdf.eps']);
end
hold off;

figure(2)
imagesc(xlims, ylims, tsdf_table);
set(gca, 'Ydir', 'normal');
axis image;
caxis([-1, 2]);
colormap(cmap);
c = colorbar;
hold on;
xlabel('x position [m]');
ylabel('y position [m]');
ylabel(c, 'Signed Distance [m]')
axis(horzcat(xlims, ylims));
title('TSDF (Projective Distance)')
hold on;
plot(xs, ys, 'k', 'LineWidth', 5); 
set(gca,'FontSize', font_size);
if (do_print)
  print('-dpng', [figure_path 'tsdf.png']);
  print('-depsc', [figure_path 'tsdf.eps']);
end
hold off;

figure(3)
imagesc(xlims, ylims, occupancy_table);
hold on;
set(gca, 'Ydir', 'normal');
axis image;
caxis([-1, 1]);
colormap(occupancy_cmap);
%c = colorbar;
hold on;
xlabel('x position [m]');
ylabel('y position [m]');
ylabel(c, 'Signed Distance [m]')
axis(horzcat(xlims, ylims));
title('Occupancy')
hold on;
plot(xs, ys, 'r', 'LineWidth', 5); 
set(gca,'FontSize', font_size);
if (do_print)
  print('-dpng', [figure_path 'occ.png']);
  print('-depsc', [figure_path 'occ.eps']);
end
hold off;
