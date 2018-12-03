% Initialize mav states
mav = struct('pose', [0.0, 0.0, 0.0], ...
             'velocity', [0.0, 0.0], ...
             'acceleration', [0.0, 0.0], ...
             'path', [], ...
             'path_vel', [], ...
             'path_acc', []);
% Initialize time
dt = 0.1;
T = 0;
failure = false;
hilbert_map = [];
xy = [];
y = [];
wt_1 = [];
failure = false;
regression_time = [];
