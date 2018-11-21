clc; clear all;
%% Generate and save maps
% Parameters
% directory = '/home/jalim/dev/unknown_mavplanning_matlab/data';
% num_maps = 2000;


% param = Param_LOCALMAP;
% 
% for j=1:num_maps
%     map = generate_environment(param);
%     ffilepath = strcat(directory ,'/fullmap/', int2str(j),'.jpg');
%     imwrite(1-map.occupancyMatrix, ffilepath);
% end

%% Generate data for hallway generation

parameterfile = Param_CORNER;
num_points = 10000;
corridor_width = 4;
corridor_length = 10;
X = [];
Y = [];

pose = [1.0, 1.0, 1.0];

% Use a static map and train around a single corner
[map, start_pos, goal_pos] = generate_envwithPos(parameterfile, parameterfile.start_point, parameterfile.goal_point);
map_obs = robotics.OccupancyGrid(double(map.occupancyMatrix), parameterfile.globalmap.resolution);
[~, map_obs] = get_localmap('increment', map, map_obs, parameterfile, pose);

for j=1:num_points
    sample_pos = [corridor_width * (rand()-0.5)+parameterfile.start_point(1), corridor_length * rand() + parameterfile.start_point(2)];
    sample_yaw = pi() * rand() + 0.5 * pi();
    sample_pose = [sample_pos, sample_yaw];
    [x, y] = getObservation(parameterfile, map_obs, sample_pose);
    X = [X, x];
    Y = [Y, y];
end

net = feedforwardnet(10);
net = configure(net, X, Y);
net = train(net,X,Y);

%% Navigate through environment with trained data

sample_pose = [sample_pos, sample_yaw];
[x, y] = getObservation(parameterfile, map_obs, sample_pose);
y_predicted = net(x);

disp('wtf');
function [X, Y] = getObservation(param, map, pose)
    scale_distance = 10;
    scale_angle = pi();
    scale_length = 15;
    
    o = getLaserScan(map, pose, param);
    % Decide wich region we are in and simulate both corners
    s = pose(3) - 0.5*pi();
    l = abs(pose(2) - 18);
    X = (o / scale_distance )';
    Y = [s / scale_angle; l / scale_length];
    
end