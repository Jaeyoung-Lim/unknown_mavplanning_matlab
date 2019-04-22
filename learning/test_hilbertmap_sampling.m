%%
clc; close all;

params = Param_TINYRANDOMFOREST;
num_obstacles = 5;
num_samples = 20;

test_resolution = [5, 4, 3, 2, 1];
test_radius = [0.4, 0.4, 0.5, 0.6, 1];
thresholds = [0.2, 0.4, 0.6, 0.8];
N = size(test_resolution, 2)+1;

image_mse = [];

%%
figure('name', 'Navigator', 'NumberTitle', 'off', 'Position', [100 800 400 400]);
figure('name', 'Optimizer', 'NumberTitle', 'off', 'Position', [1900 800 400 400]);
figure('name', 'Prediction Results', 'NumberTitle', 'off', 'Position', [600 800 1200 400]);

occupancymap = struct('localmap', [], ... % Locally observed map
                      'incrementmap', [], ... % Global observed map
                      'truemap', []); % True binary occupancy map

hilbertmap = struct('enable', params.hilbertmap.enable, ...
                        'wt', [], ...
                        'xy', [], ...
                        'y', []);

map = create_random_map(4, 4, 10, num_obstacles, 0.4);
occupancymap.truemap = map;
occupancymap.localmap = initlocalmap(params);
binmap = occupancymap.truemap;

X = rand(num_samples, 1) * 1.0 *map.XWorldLimits(2);
Y = rand(num_samples, 1) * 1.0 *map.YWorldLimits(2);
xy =  [X(:), Y(:)];

y = double(map.getOccupancy(xy));
zero_mask = y < 1;
y(zero_mask) = -1;

hilbertmap.xy = xy;
hilbertmap.y = y;
hilbertmap.wt = [];

params.hilbertmap.pattern = 'grid';
hilbertmap_grid = learn_hilbert_map(params, occupancymap, hilbertmap);

%%
subplot(2, 3, 1);
ground_truth = double(occupancymap.truemap.occupancyMatrix)';
imagesc(binmap.XWorldLimits, fliplr(binmap.YWorldLimits), flipud(ground_truth'));

colorbar('Ticks',[]);
title('Ground Truth');
xlabel('X [meters]'); ylabel('Y [meters]');
xticks(1:binmap.XWorldLimits(2)); yticks(1:binmap.YWorldLimits(2));

ground_truth_v = ground_truth(:);

for j = 2:N
    
    hilbertmap.xy = xy;
    hilbertmap.y = y;
    hilbertmap.wt = [];
    params.hilbertmap.resolution = test_resolution(j-1);
    params.hilbertmap.radius = test_radius(j -1);
    hilbertmap_grid = learn_hilbert_map(params, occupancymap, hilbertmap);


    subplot(2, 3, j);
    params.hilbertmap.pattern = 'grid';
    map = render_hilbertmap(params, hilbertmap_grid.wt, binmap);
    
    image_mse(j-1) = immse(map, ground_truth);

    mask_true = ground_truth_v > 0.5;


    for k = 1:size(thresholds, 2)
        mask_positive = map(:) >= thresholds(k);
        % Calculate False Positive
        fp(k, j-1) = sum(ground_truth_v(mask_positive) < 0.5 )/ sum(mask_positive);
        % Calculate True Positive
        tp(k, j-1) = sum(ground_truth_v(mask_positive) >= 0.5) / sum(mask_positive);

        mask_negative = ~mask_positive;
        % Calculate False Negative
        fn(k, j-1) = sum(ground_truth_v(mask_negative) >= 0.5)/ sum(mask_negative);
        % Calculate True Negative
        tn(k, j-1) = sum(ground_truth_v(mask_negative) < 0.5)/ sum(mask_negative);
        
    end
    
    % Visualize map
    imagesc(binmap.XWorldLimits, fliplr(binmap.YWorldLimits), flipud(map'));
    set(gca, 'Ydir', 'normal'); hold on;
    
    if ~isempty(xy)
        plot(xy((y > 0), 1), xy((y > 0), 2), 'xr'); hold on;
        plot(xy((y < 0), 1), xy((y < 0), 2), 'xb'); hold on;
    end

    colormap(gca, 'jet');
    colorbar('Ticks', [0.0, 0.5, 1.0]);
    title(sprintf('Resolution %1.0f', test_resolution(j-1)));
    xlabel('X [meters]'); ylabel('Y [meters]');
    xticks(1:binmap.XWorldLimits(2)); yticks(1:binmap.YWorldLimits(2));
    
end


%% Plot Results
% figure(7);
% plot(test_resolution, fp(3, :)); hold on;
% plot(test_resolution, fn(3, :)); hold on;
% legend('false positive', 'false negative');

figure(8);
plot(test_resolution, fp(1, :), '-o'); hold on;
plot(test_resolution, fp(2, :), '-o'); hold on;
plot(test_resolution, fp(3, :), '-o'); hold on;
plot(test_resolution, fp(4, :), '-o'); hold on;
legend('0.2', '0.4', '0.6', '0.8');
% ylim([0.5, 1.0]);
xlabel('Resolution [pixels/m]');
ylabel('False Positive Rate');
title('False Positive vs Resolution');

figure(9);
plot(test_resolution, fn(1, :), '-o'); hold on;
plot(test_resolution, fn(2, :), '-o'); hold on;
plot(test_resolution, fn(3, :), '-o'); hold on;
plot(test_resolution, fn(4, :), '-o'); hold on;
% ylim([0.0, 0.5]);
legend('0.2', '0.4', '0.6', '0.8');
xlabel('Resolution [pixels/m]');
ylabel('False Negative Rate');
title('False Negative vs Resolution');