function [videoObj] = plot_summary(globalmap, partialmap, mavpath, mavpose, videoObj)

    plot_binmap(globalmap, mavpath, mavpose);
    % plot_map(map_true, mavPose, intsectionPts, angles);
    videoObj = plot_localmap(partialmap, videoObj);
    drawnow
end

function plot_binmap(map, path, pose)
    set_params();
    
    subplot(1,2,1);
    
    show(map); hold on;
    plot(path(:, 1), path(:, 2)); hold on;
    plot(pose(1), pose(2), 'xr','MarkerSize',10); hold on;
    rectangle('Position',[pose(1)-0.5*width_subm, pose(2)-0.5*height_subm, width_subm, height_subm], 'EdgeColor', 'b');
    hold off;
    
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

function [video_obj] = plot_localmap(map, video_obj)
    set_params();
    
    subplot(1,2,2);
    
    show(map); hold on;
    plot(0.5*width_subm, 0.5*height_subm, 'xr','MarkerSize',10); hold off;
    
    image = occupancyMatrix(map);
    frame = image;
    writeVideo(video_obj, frame);
end