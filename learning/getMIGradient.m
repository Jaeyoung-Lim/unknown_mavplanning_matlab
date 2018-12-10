function [dl, l] = getMIGradient(param, map, pos, vel, hilbertmap)
    %% Calculate mutual information gradient from hilbertmap
    
    yaw = atan2(vel(2), vel(1));
    pose = [pos, yaw];
    
    % Calculate the arc positions
    perturbed_hilbertmap = hilbertmap;
    
    arcpoints = getObservationEdge(param, map, pose);
    MI = zeros(size(arcpoints, 1), 1);
    dMI = zeros(size(arcpoints));
    perturbed_hilbertmap.xy = [perturbed_hilbertmap.xy; arcpoints];
    perturbed_hilbertmap.y = [perturbed_hilbertmap.y; -1*ones(size(arcpoints, 1), 1)];
    perturbed_hilbertmap.wt = learn_hilbert_map(param, map, perturbed_hilbertmap, pose);
    
    for i = 1:size(arcpoints, 1)
        x_query = arcpoints(i, :);
        [dH, H] = getEntropyGradient(param, x_query, map, hilbertmap);
        [dH_hat, H_hat] = getEntropyGradient(param, x_query, map, perturbed_hilbertmap);
        dMI(i, :) = dH - dH_hat;
        MI(i) = H - H_hat;
    end
    dl = sum(dMI, 1);
    l = sum(MI, 1);
    
%     figure(3);
%     show(map); hold on;
%     if ~isempty(arcpoints)
%         plot(arcpoints(:, 1), arcpoints(:, 2), 'xr'); hold on;
%         quiver(arcpoints(1, 1), arcpoints(2, 2), 100*dl(1), 100*dl(2), 'g-'); hold on;
%     end
%     plot(pos(1), pos(2), 'ob'); hold off;
    
    
end