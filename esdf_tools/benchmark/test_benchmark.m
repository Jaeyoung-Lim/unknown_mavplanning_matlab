figure_path = '../figures/benchmark_0_50/';
do_print = 0;
font_size = 20;

xlims = [0, 2];
ylims = [0, 2];
grid_size = 0.25;
epsilon = 0.20;
% Create ground truth.
[esdf_table, gx, gy] = evaluate_on_grid(xlims, ylims, grid_size);

% Create original tables.
[tsdf_table] = make_tsdf_map(xlims, ylims, grid_size);
[occupancy_table] = make_occupancy_map(xlims, ylims, grid_size);
[etsdf_table] = fill_hybrid_esdf(tsdf_table, grid_size, epsilon);
[occupancy_esdf_table] = fill_occupancy_esdf(occupancy_table, grid_size);

% Calculate errors.
[tsdf_err_table, tsdf_err] = calc_error(esdf_table, tsdf_table);
[etsdf_err_table, etsdf_err] = calc_error(esdf_table, etsdf_table);
[occupancy_esdf_err_table, occupancy_esdf_err] = calc_error(esdf_table, occupancy_esdf_table);

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
plot(xs, ys, 'k', 'LineWidth', 2); 
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
plot(xs, ys, 'k', 'LineWidth', 2); 
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
plot(xs, ys, 'r', 'LineWidth', 2); 
set(gca,'FontSize', font_size);
if (do_print)
  print('-dpng', [figure_path 'occ.png']);
  print('-depsc', [figure_path 'occ.eps']);
end
hold off;

figure(4)
imagesc(xlims, ylims, etsdf_table);
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
title('E/TSDF (Hybrid)')
hold on;
plot(xs, ys, 'k', 'LineWidth', 2); 
set(gca,'FontSize', font_size);
if (do_print)
  print('-dpng', [figure_path 'hybrid.png']);
  print('-depsc', [figure_path 'hybrid.eps']);
end
hold off;

figure(5)
imagesc(xlims, ylims, occupancy_esdf_table);
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
title('Occupancy ESDF')
hold on;
plot(xs, ys, 'k', 'LineWidth', 2); 
set(gca,'FontSize', font_size);
if (do_print)
  print('-dpng', [figure_path 'occ_esdf.png']);
  print('-depsc', [figure_path 'occ_esdf.eps']);
end
hold off;


figure(6)
imagesc(xlims, ylims, tsdf_err_table);
set(gca, 'Ydir', 'normal');
axis image;
caxis([-1, 1]);
colormap(error_cmap);
c = colorbar;
hold on;
xlabel('x position [m]');
ylabel('y position [m]');
ylabel(c, 'SDF Error [m]')
axis(horzcat(xlims, ylims));
title(sprintf('TSDF Error [Mean Abs Err: %f m]', tsdf_err));
hold on;
plot(xs, ys, 'k', 'LineWidth', 2); 
set(gca,'FontSize', font_size);
if (do_print)
  print('-dpng', [figure_path 'tsdf_err.png']);
  print('-depsc', [figure_path 'tsdf_err.eps']);
end
hold off;

figure(7)
imagesc(xlims, ylims, etsdf_err_table);
set(gca, 'Ydir', 'normal');
axis image;
caxis([-1, 1]);
colormap(error_cmap);
c = colorbar;
hold on;
xlabel('x position [m]');
ylabel('y position [m]');
ylabel(c, 'SDF Error [m]')
axis(horzcat(xlims, ylims));
title(sprintf('Hybrid E/TSDF Error [Mean Abs Err: %f m]', etsdf_err));
hold on;
plot(xs, ys, 'k', 'LineWidth', 2); 
set(gca,'FontSize', font_size);
if (do_print)
  print('-dpng', [figure_path 'hybrid_err.png']);
  print('-depsc', [figure_path 'hybrid_err.eps']);
end
hold off;

figure(8)
imagesc(xlims, ylims, occupancy_esdf_err_table);
set(gca, 'Ydir', 'normal');
axis image;
caxis([-1, 1]);
colormap(error_cmap);
c = colorbar;
hold on;
xlabel('x position [m]');
ylabel('y position [m]');
ylabel(c, 'SDF Error [m]')
axis(horzcat(xlims, ylims));
title(sprintf('Occupancy ESDF Error [Mean Abs Err: %f m]', occupancy_esdf_err));
hold on;
plot(xs, ys, 'k', 'LineWidth', 2); 
set(gca,'FontSize', font_size);
if (do_print)
  print('-dpng', [figure_path 'occ_esdf_err.png']);
  print('-depsc', [figure_path 'occ_esdf_err.eps']);
end
hold off;
