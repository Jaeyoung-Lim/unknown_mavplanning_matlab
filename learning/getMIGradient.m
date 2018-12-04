function dl = getMIGradient(param, map, pos, vel, hilbertmap)
    %% Calculate mutual information gradient from hilbertmap
    
    yaw = atan2(vel(2), vel(1));
    pose = [pos, yaw];
    
    % Calculate the arc positions
    perturbed_hilbertmap = hilbertmap;
    
    arcpoints = getObservationEdge(param, map, pose);
    dMI = zeros(size(arcpoints));
    perturbed_hilbertmap.xy = [perturbed_hilbertmap.xy; arcpoints];
    perturbed_hilbertmap.y = [perturbed_hilbertmap.y; -1*ones(size(arcpoints, 1), 1)];
    perturbed_hilbertmap.wt = learn_hilbert_map(param, map, perturbed_hilbertmap, pose);
    
    for i = 1:size(arcpoints, 1)
        x_query = arcpoints(i, :);
        dH = getEntropyGradient(param, x_query, map, hilbertmap);
        dH_hat = getEntropyGradient(param, x_query, map, perturbed_hilbertmap);
        dMI(i, :) = dH - dH_hat;
    end
    dl = sum(dMI, 1);
    
    figure(3);
    show(map); hold on;
    if ~isempty(arcpoints)
        plot(arcpoints(:, 1), arcpoints(:, 2), 'xr'); hold on;
    end
    plot(pos(1), pos(2), 'ob'); hold on;
    plot([pos(1), pos(1)+1000*dl(1)], [pos(2), pos(2)+1000*dl(2)], 'g-'); hold off;
end