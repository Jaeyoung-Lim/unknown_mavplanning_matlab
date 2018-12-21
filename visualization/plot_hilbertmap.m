function plot_hilbertmap(param, hilbertmap, binmap, pose, localpath)
    if ~param.hilbertmap.plot
        return;
    end    

    figure(findobj('name', 'Hilbert Map'));
    xy = hilbertmap.xy;
    y = hilbertmap.y;
    wt = hilbertmap.wt;

    tic;
    map = render_hilbertmap(param, wt, binmap);
    time = toc;
    fprintf('Render Time: %d\n',time)
    %% Plot Sample points and local observation map
    subplot(1, 2, 1);
    show(binmap); hold on;

%     colormap(gca, 'gray');
    switch param.mapping
         case 'local'
            xy = xy - pose(1:2);
            plot(xy((y > 0), 1), xy((y > 0), 2), 'xr'); hold on;
            plot(xy((y < 0), 1), xy((y < 0), 2), 'xb'); hold on;
        case 'increment'
            plot(xy((y > 0), 1), xy((y > 0), 2), 'xr'); hold on;
            plot(xy((y < 0), 1), xy((y < 0), 2), 'xb'); hold on;
    end
    %% Plot Hilbertmap
    subplot(1, 2, 2);
    imshow(flipud(map'), 'InitialMagnification', 400); hold on;
    colormap(gca, 'jet');
    colorbar('Ticks',[]);
    title('Hilbert Map');
    xlabel('X [meters]'); ylabel('Y [meters]');
    xticks(1:4); yticks(1:4);
    plot(localpath(:, 1), localpath(:, 2), 'w'); hold off;
    
%     subplot(2, 2, 3);
%     hist(wt, 100);
%     
%     subplot(2, 2, 4);
%     hist(wt(abs(wt)>0.01), 100);

end