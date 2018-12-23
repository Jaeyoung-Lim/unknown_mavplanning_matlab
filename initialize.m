% Initialize figures
close all;
figure('name', 'Navigator', 'NumberTitle', 'off', 'Position', [100 800 400 400]);
figure('name', 'Hilbert Map', 'NumberTitle', 'off', 'Position', [600 800 1200 400]);
figure('name', 'Optimizer', 'NumberTitle', 'off', 'Position', [1900 800 400 400]);


% Initialize mav states
mav = struct('pose', [0.0, 0.0, 0.0], ...
             'velocity', [0.0, 0.0], ...
             'acceleration', [0.0, 0.0], ...
             'path', [], ...
             'path_vel', [], ...
             'path_acc', []);
hilbertmap = struct('enable', params.hilbertmap.enable, ...
                    'wt', [], ...
                    'xy', [], ...
                    'y', []);
                
occupancymap = struct('localmap', [], ... % Locally observed map
                      'incrementmap', [], ... % Global observed map
                      'truemap', []); % True binary occupancy map

         
% Initialize time
dt = 0.1;
T = 0;
failure = false;
xy = [];
y = [];

wt_1 = [];
wt = [];
failure = false;
regression_time = [];
global_start = params.start_point; % Set gloabl start and goal position
global_goal = params.goal_point;
init_yaw = pi()/2;
mav.pose = [global_start, init_yaw]; % Current position starts from global start
