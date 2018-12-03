function plot_hilbertmap(param, wt, binmap, xy, y, pose)
    if ~param.hilbertmap.plot
        return;
    end    
    figure(2);

    tic;
    map = render_hilbertmap(param, wt, binmap);
    time = toc;
    fprintf('Render Time: %d\n',time)
    subplot(2, 2, 1);
    show(binmap); hold on;

%     colormap(gca, 'gray');
    switch param.mapping
         case 'local'
            xy = xy - pose(1:2);
            plot(xy((y > 0), 1), xy((y > 0), 2), 'xr'); hold on;
            plot(xy((y < 0), 1), xy((y < 0), 2), 'xb'); hold off;
        case 'increment'
            plot(xy(:, 1), xy(:, 2), 'xr'); hold off;
    end
    subplot(2, 2, 2);
    imshow(flipud(map'), 'InitialMagnification', 400);
    colormap(gca, 'jet');
    colorbar('Ticks',[]);
    title('Hilbert Map');
    xlabel('X [meters]'); ylabel('Y [meters]');
    xticks(1:4); yticks(1:4);
    
    subplot(2, 2, 3);
    hist(wt, 100);
    
    subplot(2, 2, 4);
    hist(wt(wt~=0), 100);


end