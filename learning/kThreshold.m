function k = kThreshold(x, x_hat, radius)
    k= zeros(size(x_hat, 1), 1, size(x, 1)); 
    rth = radius;
    x = reshape(x', [1, 2, size(x, 1)]);
    r = vecnorm(x-x_hat, 2, 2);
    
    thr_mask = r < rth;
    
    k(thr_mask) = (rth - r(thr_mask)) / rth;
    k = squeeze(k);
end