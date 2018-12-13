function [dl, l] = getMIGradient(param, map, pos, vel, hilbertmap)
    %% Calculate mutual information gradient from hilbertmap
    
    yaw = atan2(vel(2), vel(1));
    pose = [pos, yaw];
    
    % Calculate the arc positions
    perturbed_hilbertmap = hilbertmap;
    
    arcpoints = getObservationEdge(param, map, pose);
    MI = zeros(size(arcpoints, 1), 1);
    dMI = zeros(size(arcpoints));
%     perturbed_hilbertmap.xy = [perturbed_hilbertmap.xy; arcpoints];
%     perturbed_hilbertmap.y = [perturbed_hilbertmap.y; -1*ones(size(arcpoints, 1), 1)];

    perturbed_hilbertmap.xy = arcpoints;
    perturbed_hilbertmap.y = zeros(size(arcpoints, 1), 1);
    for i = 1:size(arcpoints, 1)
%         p = occupancyProb(param, hilbertmap.wt, arcpoints(i, :), map);
        p = 0.2;
        perturbed_hilbertmap.y(i) = log(p/(1-p));
    end

    perturbed_hilbertmap = learn_hilbert_map(param, map, perturbed_hilbertmap, pose);
    
    figure(100);
    subplot(1, 2, 1);
    imshow(flipud(render_hilbertmap(param, hilbertmap.wt, map)'));
    colormap(gca, 'jet');
    colorbar('Ticks',[]);
    
    subplot(1, 2, 2);
    imshow(flipud(render_hilbertmap(param, perturbed_hilbertmap.wt, map)'));
    colormap(gca, 'jet');
    colorbar('Ticks',[]);
    
    for i = 1:size(arcpoints, 1)
        % Calculate mutual information gradient for each points
        x_query = arcpoints(i, :);
        [dH, H] = getEntropyGradient(param, x_query, map, hilbertmap);
        [dH_hat, H_hat] = getEntropyGradient(param, x_query, map, perturbed_hilbertmap);
        dMI(i, :) = dH - dH_hat;
        MI(i) = H - H_hat;
    end
    dl = sum(dMI, 1);
    l = sum(MI, 1);
    
    figure(300);
    show(map); hold on;
    if ~isempty(arcpoints)
        plot(arcpoints(:, 1), arcpoints(:, 2), 'xr'); hold on;
        quiver(arcpoints(:, 1), arcpoints(:, 2), 100*dMI(:, 1), 100*dMI(:, 2), 'g-'); hold on;
    end
    plot(pos(1), pos(2), 'ob'); hold off;
    
    
end