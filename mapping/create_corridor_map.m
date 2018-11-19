function map = create_corridor_map(width_m, height_m, resolution, num_samples, inflation)
%% State
% 1. STRAIGHT segment origented left, following a #5 LEFT TURN
% 2. STRAIGHT segment origented up, following a #7 RIGHT TURN
% 3. STRAIGHT segment oriented up, following a #6 LEFT TURN
% 4. STRAIGHT segment oriented right, following a #8 RIGHT TURN
% 5. LEFT TURN segment, following a # 3 segment
% //This should be a right turn
% 6. LEFT TURN segment, following a #4 segment
% 7. RIGHT TURN segment, following a #1 STRAIGHT segment
% 8. RIGHT TURN segment, following a #2 STRAIGHT segment
% //This should be a left turn
%% Parameters
pst = 0.4;
ptt = 0;
corridor_width = 2;
corridor_length = 5;

%% Initialize
pss = 1 - pst;
pts = 1 - ptt;
fullgrid = ones(height_m*resolution, width_m*resolution);
map = robotics.BinaryOccupancyGrid(fullgrid, resolution);
% State tranisition matrix for hallways
T = [pss,   0,   0,   0,   0,   0, pst,   0;
       0, pss,   0,   0,   0,   0,   0, pst;
       0,   0, pss,   0, pst,   0,   0,   0;
       0,   0,   0, pss,   0, pst,   0,   0;
     pts,   0,   0,   0,   0,   0, ptt,   0;
       0,   0, pts,   0, ptt,   0,   0,   0;
       0, pts,   0,   0,   0,   0,   0, ptt;
       0,   0,   0, pts,   0, ptt,   0,   0];

% % Initialize statef
S = logical(zeros(num_samples, 8));
S(1, :) = getstate(1);

segment_pose = [0.5*corridor_width , 0.5*height_m, 0];
r = create_straight(segment_pose, corridor_length, corridor_width, resolution);
setOccupancy(map, r, 0);

for i=2:num_samples
    % Get the next state
    while true
        sample = rand();
        pS = cumsum(T(S(i-1, :), :)) > sample;
        find(pS, 1, 'first')
        S(i, :) = getstate(find(pS, 1, 'first'));
        sample_pose = transition_pos(S(i-1, :), S(i, :), segment_pose, corridor_width, corridor_length);
        if checkbounds(width_m, height_m, segment_pose, S(i-1, :), S(i, :), corridor_width, corridor_length)
            segment_pose = sample_pose;
            break;
        end
        if segment_pose(1) > 0.9*width_m
            break;
        end
    end
    if segment_pose(1) >= 35
            break;
    end
    if find(pS, 1, 'first') > 4
        r = create_corner(segment_pose, corridor_width, resolution);
    else
        r = create_straight(segment_pose, corridor_length, corridor_width, resolution);
    end
    setOccupancy(map, r, 0)
    show(map);    
end

map = set_strip(map, [0.9*width_m, 0.5*height_m], corridor_width, corridor_length, resolution);

end

function map = set_corner(map, segment_pose, corridor_width, corridor_length, resolution)
    segment_pose(3) = 0;
    r = create_straight(segment_pose, corridor_length, corridor_width, resolution);
    setOccupancy(map, r, 0);
    segment_pose(3) = 3*pi()/2;
    r = create_straight(segment_pose, corridor_length, corridor_width, resolution);
    setOccupancy(map, r, 0);

end

function map = set_strip(map, segment_pose, corridor_width, corridor_length, resolution)
    segment_pose(3) = -pi()/2;
    r = create_straight(segment_pose, 0.4*map.height, corridor_width, resolution);
    setOccupancy(map, r, 0);
    segment_pose(3) = pi()/2;
    r = create_straight(segment_pose, 0.4*map.height, corridor_width, resolution);
    setOccupancy(map, r, 0);

end

function r = create_straight(pose, length, width, resolution)
    origin = pose(1:2);
    theta = pose(3);
    r = [];
   
    for d=0:1/(2*resolution):length
        pos = origin + [d*cos(theta), d*sin(theta)];
        for h= -0.5*width:1/(2*resolution):0.5*width
            dpos = pos + [h*sin(theta), h*cos(theta)]; 
            r= [r; dpos];
        end
    end
    for d=0:1/(2*resolution):0.5*width
        pos = origin - [d*cos(theta), d*sin(theta)];
        for h= -0.5*width:1/(2*resolution):0.5*width
            dpos = pos + [h*sin(theta), h*cos(theta)]; 
            r= [r; dpos];
        end
    end

end

function r = create_corner(pose, width, resolution)
    origin = pose(1:2);
    theta = pose(3);
    r = [];
    length = width;
   
    for d=0:1/(2*resolution):length
        pos = origin + [d*cos(theta), d*sin(theta)];
        for h= -0.5*width:1/(2*resolution):0.5*width
            dpos = pos + [h*sin(theta), h*cos(theta)]; 
            r= [r; dpos];
        end
    end
    for d=0:1/(2*resolution):0.5*width
        pos = origin - [d*cos(theta), d*sin(theta)];
        for h= -0.5*width:1/(2*resolution):0.5*width
            dpos = pos + [h*sin(theta), h*cos(theta)]; 
            r= [r; dpos];
        end
    end

end


function mask = getstate(idx)
    state = logical(zeros(8, 1));
    state(idx) = true;
    mask = state;
end
 
function result = checkbounds(width, height, pose, state_prev, state, corridor_width, corridor_length)
    result = false;
    next_pose = transition_pos(state_prev, state, pose, corridor_width, corridor_length);
    if width > next_pose(1) && next_pose(1) > 0 && next_pose(2) > 0 && next_pose(2) < height
        result = true;
    end
end

function pose = transition_pos(state_prev, state, pose, corridor_width, corridor_length)

    yaw_step = [0, -pi()/2, pi()/2, 0, 0, pi()/2, -pi()/2, 0];
    dist_step1 = [corridor_length*ones(1, 4), corridor_width * ones(1,4)];
    pose(1:2) = [pose(1) + dist_step1(state_prev)*cos(pose(3)), pose(2) + dist_step1(state_prev)*sin(pose(3))];
    pose(3) = yaw_step(state);

end