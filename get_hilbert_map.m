function [map] = get_hilbert_map(binmap)



%% Learn Kernel function from true binary occupancy map

res = 0.5;
[X, Y] = meshgrid(0:res:(binmap.XWorldLimits(2)), 0:res:(binmap.YWorldLimits(2)));
X = X(:);
Y= Y(:);
xy = [X, Y];

y = double(binmap.getOccupancy(xy));
zero_mask = y < 1;
y(zero_mask) = -1;

%% Update weights
wt_1 = zeros(1600, 1);
record = [];
for i = 1:200
    
    wt = updateWeights(wt_1, xy, y, binmap);
    record = [record, wt];
    wt_1 = wt;
end
figure(1);
plot(vecnorm(record, 2, 1), 'bx-');

p = zeros(160, 160);
for i = 1:160
    for j = 1:160
        x = [i/40, j/40];
        p(i, j) = occupancyProb(wt, x, binmap);
    end
end

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
end

function wt = updateWeights(wt_1, X, Y, map)
    eta = 0.1; % Learning rate
    A = eye(size(10));
    wt = wt_1 - eta * A * grad_negativell(wt_1, X, Y, map); % A should be inv A
end

function grad_NLL = grad_negativell(w, X, Y, map)

grad_NLL = zeros(size(w));
for i = 1:size(Y, 1)
    phi_x = kernelFeatures(X(i, :), map, 'threshold');
    grad_NLL = grad_NLL -Y(i)* phi_x / ( 1 + exp(Y(i)*dot(w, phi_x)));
end

end

function p = occupancyProb(w, X, map)
    % Probability that y = 1
    p = 1-1/(1+exp(dot(w, kernelFeatures(X, map, 'threshold')))); 

end
%% Kernel Features
function phi_hat = kernelFeatures(x_query, map, option)
    % X : Query point
    % X_data : Sample points
    % Create data from binary occupancy points
    res = 1/map.Resolution;
    [X, Y] = meshgrid(res:res:map.XWorldLimits(2), res:res:map.YWorldLimits(2));
    X = X(:);
    Y= Y(:);
    xy = [X, Y];

   phi_hat = zeros(size(xy, 1), 1);
   
   switch option
       case 'sparse'
           for i = 1:size(xy, 1)     
               phi_hat(i) = kSparse(x_query, xy);
       
           end
       case 'threshold'
           phi_hat = kThreshold(x_query, xy);
   end

end

function k = kSparse(x, x_hat)
    k= 0;
    omega = eye(2); % Omega is positive semi definite
    
    r = sqrt((x-x_hat)*omega*(x-x_hat)');
    
    if r < 1
        k = 2 + cos(2*pi()*r)*(1-r)/3 + sin(2*pi()*r)/(2*pi());
        
    end
end

function k = kThreshold(x, x_hat)
    k= zeros(size(x_hat, 1), 1); 
    rth = 1.0;
    r = vecnorm(x-x_hat, 2, 2);
    
    thr_mask = r < rth;
    
    k(thr_mask) = (rth - r(thr_mask)) / rth;
        
end