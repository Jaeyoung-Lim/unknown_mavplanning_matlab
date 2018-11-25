function plot_hilbertmap(p, record, xy, map)
    %% Visualization
    figure(3);
    plot(vecnorm(record, 2, 1), 'bx-');

    figure(4);
    subplot(1, 2, 2);
    imshow(flipud(p'));
    colormap jet;
    colorbar('Ticks',[]);
    title('Hilbert Map');
    xlabel('X [meters]'); ylabel('Y [meters]');
    xticks(1:4); yticks(1:4);
    subplot(1, 2, 1);
    show(map); hold on;
    plot(xy(:, 1), xy(:, 2), 'xr');

end