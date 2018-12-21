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
    if ~isempty(xy)
        switch param.mapping
             case 'local'
                origin = [0.5*binmap.XWorldLimits(2), 0.5*binmap.YWorldLimits(2)];
                xy = xy - pose(1:2);
                localpath = localpath - pose(1:2) + origin;
                plot(origin(1), origin(2), 'wo'); hold on;
        end
        plot(xy((y > 0), 1), xy((y > 0), 2), 'xr'); hold on;
        plot(xy((y < 0), 1), xy((y < 0), 2), 'xb'); hold on;
    end
    %% Plot Hilbertmap
    subplot(1, 2, 2);
%     imshow(flipud(map'), 'InitialMagnification', 400); hold on;
    imagesc(binmap.XWorldLimits, fliplr(binmap.YWorldLimits), flipud(map')); set(gca, 'Ydir', 'normal');
    hold on;
    colormap(gca, 'jet');
    colorbar('Ticks',[]);
    title('Hilbert Map');
    xlabel('X [meters]'); ylabel('Y [meters]');
    xticks(1:binmap.XWorldLimits(2)); yticks(1:binmap.YWorldLimits(2));
    plot(localpath(1, 1), localpath(1, 2), 'wo'); hold on;
    plot(localpath(:, 1), localpath(:, 2), 'w'); hold off;
    
%     subplot(2, 2, 3);
%     hist(wt, 100);
%     
%     subplot(2, 2, 4);
%     hist(wt(abs(wt)>0.01), 100);

end