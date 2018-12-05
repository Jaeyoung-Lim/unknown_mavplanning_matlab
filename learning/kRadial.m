function k = kRadial(x, x_hat, radius)

    x = reshape(x', [1, 2, size(x, 1)]);
    r = vecnorm(x-x_hat, 2, 2);
    
    k = exp(-0.5*(r.^2)/((0.5*radius)^2));
    k = squeeze(k);

end