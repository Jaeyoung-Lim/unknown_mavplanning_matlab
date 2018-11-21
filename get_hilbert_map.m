function [map] = get_hilbert_map(binmap)
%% Learn Kernel function from true binary occupancy map

% res = 0.5;
% [X, Y] = meshgrid(0:res:(binmap.XWorldLimits(2)), 0:res:(binmap.YWorldLimits(2)));
% X = X(:);
% Y= Y(:);
% xy = [X, Y];
X = rand(81, 1) * 4;
Y = rand(81, 1) * 4;
xy = [X(:), Y(:)];

y = double(binmap.getOccupancy(xy));
zero_mask = y < 1;
y(zero_mask) = -1;

%% Update weights
wt_1 = zeros(1600, 1);
record = [];
for i = 1:100
    
    wt = updateWeights(wt_1, xy, y, binmap);
    record = [record, wt];
    wt_1 = wt;
end

% figure(1);
% plot(vecnorm(record, 2, 1), 'bx-');

p = 0.5*ones(160, 160);
for i = 1:160
    for j = 1:160
        x = [i/40, j/40];
        p(i, j) = occupancyProb(wt, x, binmap);
    end
end

%% Visualization
figure(2);
subplot(1, 2, 2);
imshow(flipud(p'));
colormap jet;
colorbar('Ticks',[]);
title('Hilbert Map');
xlabel('X [meters]'); ylabel('Y [meters]');
xticks(1:4); yticks(1:4);
subplot(1, 2, 1);
show(binmap); hold on;
plot(xy(:, 1), xy(:, 2), 'xr');
% render_hilbertmap()
map = p;
end
