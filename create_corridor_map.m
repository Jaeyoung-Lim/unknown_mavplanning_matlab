function map = create_corridor_map(width_m, height_m, resolution, num_samples, inflation)
%% State
% 1. STRAIGHT segment origented left, following a #5 LEFT TURN
% 2. STRAIGHT segment origented up, following a #7 RIGHT TURN
% 3. STRAIGHT segment oriented up, following a #6 LEFT TURN
% 4. STRAIGHT segment oriented right, following a #8 RIGHT TURN
% 5. LEFT TURN segment, following a # 3 segment
% 6. LEFT TURN segment, following a #4 segment
% 7. RIGHT TURN segment, following a #1 STRAIGHT segment
% 8. RIGHT TURN segment, following a #2 STRAIGHT segment
%% Parameters
pst = 0.4;
ptt = 0;
corridor_width = 4;
corridor_length = 14;

%% Initialize
% pss = 1 - pst;
% pts = 1 - ptt;
% segment_pose = [0.5*corridor_width , 0.5*height_m, 0];

fullgrid = ones(height_m*resolution, width_m*resolution);
map = robotics.BinaryOccupancyGrid(fullgrid, resolution);

% plot(segment_pose(1), segment_pose(2), 'xr'); hold on;
% xlim([0, 20]); ylim([0, 20]); 
% 
% % Initialize statef
% S = logical(zeros(num_samples, 8));
% S(1, :) = getstate(2);
% 
% T = [pss,   0,   0,   0,   0,   0, pst,   0;
%        0, pss,   0,   0,   0,   0,   0, pst;
%        0,   0, pss,   0, pst,   0,   0,   0;
%        0,   0,   0, pss,   0, pst,   0,   0;
%      pts,   0,   0,   0,   0,   0, ptt,   0;
%        0,   0, pts,   0, ptt,   0,   0,   0;
%        0, pts,   0,   0,   0,   0,   0, ptt;
%        0,   0,   0, pts,   0, ptt,   0,   0];
%%
% segment_pose = transition_pos(S(1, :), segment_pose, corridor_width, corridor_length);
% for i=2:num_samples
%     % Get the next state
%     while true
%         pS = cumsum(T(S(i-1, :), :)) > rand();
%         S(i, :) = getstate(find(pS, 1, 'first'));
%         segment_pose = transition_pos(S(i, :), segment_pose, corridor_width, corridor_length);
%         if checkbounds(width_m, height_m, segment_pose)
%             break;
%         end
%         if segment_pose(1) > 0.9*width_m
%             break;
%         end
%     end
%     if segment_pose(1) > 0.9*width_m
%             break;
%     end
% %     map = set_corridor(map, S(i, :), segment_pose, corridor_width, corridor_length, resolution);
% end
segment_pose = [4, 16, 0];
map = set_corner(map, segment_pose, corridor_width, corridor_length, resolution);

end

function map = set_corner(map, segment_pose, corridor_width, corridor_length, resolution)
    segment_pose(3) = 0;
    r = create_straight(segment_pose, corridor_length, corridor_width, resolution);
    setOccupancy(map, r, 0);
    segment_pose(3) = 3*pi()/2;
    r = create_straight(segment_pose, corridor_length, corridor_width, resolution);
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

% function mask = getstate(idx)
%     state = logical(zeros(8, 1));
%     state(idx) = true;
%     mask = state;
% end
% 
% function result = checkbounds(width, height, pose)
%     if width >= pose(1) && pose(1) >= 0 && pose(2) >= 0 && pose(2) <= height
%         result = true;
%     else
%         result = false;
%     end
% end
% 
% function map = set_corridor(map, state, pose, corridor_width, corridor_length, resolution)
%     if find(state, 1, 'first') < 5
%         length = corridor_length;
%         width = corridor_width;
%     else
%         length =  corridor_width;
%         width = corridor_width;
%     end
%     vector = [corridor_length, 0];
%     row_min = min(pose(1), pose(1) + vector(1)*cos(pose(3)));
%     row_max = max(pose(1), pose(1) + vector(1)*cos(pose(3)));
%     row = row_min:1/resolution:row_max;
%     col_min = min(pose(2), pose(2) + vector(1)*sin(pose(3)));
%     col_max = max(pose(2), pose(2) + vector(1)*sin(pose(3)));
%     col = col_min:1/resolution:col_max;
%     r = zeros(numel(row)*numel(col), 2);
%     for i = 1:size(row, 2)
%         for j = 1:size(col, 2)
%             r(numel(col)*(i-1) + j, :) = [row(i), col(j)];
%         end
%     end
%     setOccupancy(map, r, 0);
%     show(map)
% end
% 
% function pose = transition_pos(state, pose, corridor_width, corridor_length)
% 
%     yaw_step = [0, 0, 0, 0, pi()/2, pi()/2, -pi()/2, -pi()/2];
%     dist_step = [corridor_length * ones(1, 4), corridor_width * ones(1,4)];
%     pose(3) = pose(3) + yaw_step(state);
%     pose(1:2) = [pose(1) + dist_step(state)*cos(pose(3)), pose(2) + dist_step(state)*sin(pose(3))];
%     plot(pose(1), pose(2), 'xr'); hold on; axis equal;
%     xlim([0, 40]); ylim([0, 20]); 
% 
% end