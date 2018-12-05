function plot_summary(param, T, globalmap, partialmap, localpath, globalpath, mav, goalVel)
if ~param.visualization
    return;
end
%% Plot Summary of global and local trajectory
figure(1);
subplot(2,2,1);
colormap gray;
plot_binmap(param, globalmap, mav, localpath, globalpath, goalVel);

subplot(2,2,2);
plot_localmap(param, partialmap, mav.pose, mav.path, localpath, globalpath);

plot_data(param, T, mav); 

drawnow
end

function plot_data(param, T, mav)
    subplot(2,2,3);
    plot(mav.path_vel, 'b-'); hold on;
    xlabel('Time [s]');
    ylabel('Velocity [m/s]'); 
    hold off;
    subplot(2,2,4);
    plot(mav.path_acc, 'b-'); hold on;
    xlabel('Time [s]');
    ylabel('Acceleration [m/s^2]'); 
    hold off;

end

function plot_binmap(param, map, state, localpath, globalpath, goalvel)
        
    show(map); hold on;
    plot(localpath(:, 1), localpath(:, 2), 'g'); hold on;
    plot(state.path(:, 1), state.path(:, 2), 'b'); hold on;
    plot(localpath(end, 1), localpath(end, 2), 'b'); hold on;
    quiver(localpath(end, 1), localpath(end, 2), goalvel(1), goalvel(2), 'r'); hold on;

    if ~isempty(globalpath)
        plot(globalpath(:, 1), globalpath(:, 2), 'r'); hold on;
        plot(globalpath(end, 1), globalpath(end, 2), 'xr'); hold on;
    end
    quiver(state.pose(1), state.pose(2), state.velocity(1), state.velocity(2), 'r'); hold on;
    plot(state.pose(1), state.pose(2), 'xr','MarkerSize',10); hold on;
    rectangle('Position',[state.pose(1)-0.5*param.localmap.width, ...
                          state.pose(2)-0.5*param.localmap.height, ...
                          param.localmap.width, ...
                          param.localmap.height], ...
                          'EdgeColor', 'b');
    hold off;
    
end

function plot_localmap(param, map, pose, mavpath, localpath, globalpath)
        
    show(map); hold on;
    switch param.mapping
        case 'local'
            plot(0.5*param.localmap.width, 0.5*param.localmap.height, 'xr','MarkerSize',10); hold off;
            
        case 'increment'
            plot(localpath(:, 1), localpath(:, 2), 'g'); hold on;
            plot(mavpath(:, 1), mavpath(:, 2), 'b'); hold on;
            plot(localpath(end, 1), localpath(end, 2), 'xb'); hold on;
            if ~isempty(globalpath)
                    plot(globalpath(end, 1), globalpath(end, 2), 'xr'); hold on;
            end

            plot(pose(1), pose(2), 'xr','MarkerSize',10); hold off;
            
    end
    
%     frame = occupancyMatrix(map);
%     writeVideo(video_obj, frame);
    
end

function plot_map(map, pose, intsectionPts, angles)    
    show(map);
    hold on;
    plot(pose(1), pose(2), 'xr','MarkerSize',10);
    hold on;
    plot(intsectionPts(:,1),intsectionPts(:,2) , '*r'); % Intersection points
    hold on;
    for i = 1:size(intsectionPts, 1)
        plot([pose(1),intsectionPts(i,1)],...
            [pose(2),intsectionPts(i,2)],'-b') % Plot intersecting rays
    end
    hold off;
end
