function k = kSparse(x, x_hat, radius)
    k= zeros(size(x_hat, 1), 1, size(x, 1));
%     omega = eye(2); % Omega is positive semi definite
    rth = radius;
%     r = sqrt((x-x_hat)*omega*(x-x_hat)');
    x = x;
    x = reshape(x', [1, 2, size(x, 1)]);
    r =  (1/rth)*vecnorm(x-x_hat, 2, 2);
    
    mask = r < 1;
    k(mask) = (2 + cos(2*pi()*r(mask))/3).*(1-r(mask)) + (1/(2*pi()))*sin(2*pi()*r(mask));
    k = squeeze(k);

end