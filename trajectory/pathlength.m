function length = pathlength(path)
    path_d = circshift(path, 1, 1);
    path_d(1, :) =  [0, 0];
    path_v = path - path_d;
    length = sum(vecnorm(path_v, 2, 2));
end