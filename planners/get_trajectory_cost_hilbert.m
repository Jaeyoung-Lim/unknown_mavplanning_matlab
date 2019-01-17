function [cost, gradient] = get_trajectory_cost_hilbert(x0, trajectory, map, cost_map, cost_map_x, cost_map_y, Ms, D_Fs, A_invs, R_unordereds, localmap, hilbertmap, param)
%GET_TRAJECTORY_COST Summary of this function goes here
%   Detailed explanation goes here

%x0

w_der = param.planner.cost_der;
w_coll = param.planner.cost_coll;
w_goal = param.planner.cost_goal;
w_entropy = param.planner.cost_entropy;

%w_der = 0.01;
%w_coll = 10;

%% Fill in D_Ps{k} from x0 or from the trajectory.
% If x0 is not empty, convert x0 to D_Ps{k}.
% If x0 is empty, get it from the trajectory itself.
if isempty(x0)
  for k = 1:trajectory.K
    n = trajectory.N + 1;
    for i = 1:length(trajectory.segments)
      p((i-1)*n+1:i*n, 1) = trajectory.segments(i).coefficients(:, k);
    end
    total_num_fixed = trajectory.vertices_structs(k).num_fixed;
    M = Ms{k};
    A_inv = A_invs{k};
    D_P = inv(M)*inv(A_inv)*p;
    D_P = D_P(total_num_fixed+1:n);
    D_Ps{k} = D_P;
    disp('SHOULD NEVER GET HERE');
  end
else
  current_index = 1;
  for k = 1:trajectory.K
    num_fixed = trajectory.vertices_structs(k).num_fixed;
    num_free = size(Ms{k}, 2) - num_fixed;
    D_Ps{k} = x0(current_index : current_index + num_free - 1)';
    current_index = current_index + num_free;
  end
end

% Fill in the derivative function.
% Make diagonal.
single_A_block = diag(1:11, 1);
% Create the matrix.
A_der = single_A_block;
for i = 1:length(trajectory.segments)-1
  A_der = blkdiag(A_der, single_A_block);
end

%% First compute the derivative costs.
J_der = 0;
for k = 1:trajectory.K
  M = Ms{k};
  R_unordered = R_unordereds{k};
  A_inv = A_invs{k};
  D_F = D_Fs{k};
  R = M'*R_unordered*M;
  [m, n] = size(R);
  total_num_fixed = trajectory.vertices_structs(k).num_fixed;

  % R_FP = R_PF' but... watev.
  R_FF = R(1:total_num_fixed,1:total_num_fixed);
  R_FP = R(1:total_num_fixed,total_num_fixed+1:n);
  R_PF = R(total_num_fixed+1:n,1:total_num_fixed);
  R_PP = R(total_num_fixed+1:m,total_num_fixed+1:n);
  
  % Extract D_P from the trajectory itself.
  %for i = 1:length(trajectory.segments)
  %  p((i-1)*n+1:i*n, 1) = trajectory.segments(i).coefficients(:, k);
  %end
  %D_P = inv(M)*inv(A_inv)*p;
  % Take the subset that's not fixed.
  %D_P = D_P(total_num_fixed+1:n);
  %D_Ps{k} = D_P;
  D_P = D_Ps{k};
  J_ders(k) = D_F'*R_FF*D_F + D_F'*R_FP*D_P + D_P'*R_PF*D_F + D_P'*R_PP*D_P;
  grad_ders{k} = 2*D_F'*R_FP + 2*D_P'*R_PP;
end

J_der = sum(J_ders);

%% Get the collision costs.
% Gonna have to rewrite all of this to pack and repack into a vector...

% Integrate along the path to get the arclength -- probably easiest is just
% sample and then pick closest points to the desired distance.
dt = 0.01;
map_res = 0;% 1/map.Resolution;

% Okay let's go from D_F{k}...
% We need to get the coefficients back out.
p = [];
t = [];
segment_index = [];
p_ind = 1;
for i = 1 : length(trajectory.segments)
  segment_time = trajectory.segments(i).time;
    
  t1 = (0:dt:segment_time)';
  % Append the last sample again? Might be between samples. :/
  %t1 = [t1 segment_time];
  % Iterate over all dimensions.
  for k = 1 : trajectory.K
    % Get the coeffs for this axis...
    coeffs = A_invs{k}*Ms{k}*[D_Fs{k};D_Ps{k}];
    coeffs_segment = coeffs((i-1)*(trajectory.N+1)+1:(i)*(trajectory.N+1));
    % Need to reverse order. :)
    p_coeffs = flipud(coeffs_segment);
    pos1 = polyval(p_coeffs, t1);
    p(p_ind:p_ind + size(pos1, 1)-1, k) = pos1;
  end
  t = [t; t1];
  segment_index = [segment_index; i*ones(size(t1))];
  p_ind = p_ind + length(t1);
end

%[t, p] = sample_trajectory(trajectory, dt);

times = [t(1)];
current_dist = 0;

J_coll = 0;
J_entropy = 0;

grad_coll = {};

% Calculate L11, L22 from block matrices for both dimensions.
for k = 1:trajectory.K
  L = A_invs{k} * Ms{k};
  num_fixed = trajectory.vertices_structs(k).num_fixed;
  % Only really need L22 - IF WE ONLY HAVE ONE SEGMENT.
  L22s{k} = L(:, num_fixed+1:end);
  grad_map{k} = L22s{k};
end

% Select a vector of ts to evaluate at and evaluate collision costs while
% at it.
grad_coll{1} = [];
grad_coll{2} = [];
grad_entropy{1} = [];
grad_entropy{2} = [];
delta_t = 0;
for i = 2:length(t)
  current_dist = current_dist + norm(p(i)-p(i-1));

  delta_t = delta_t + dt;
  if (current_dist > map_res)
    times(end+1) = t(i);
    current_time = t(i);
    %delta_t = (t(i) - times(end-1));
    
    % Get the matrix that when multiplied by p gets you a position at any
    % given time.
    grad_time = zeros(1, (trajectory.N+1) * (trajectory.num_elements-1));
    
    grad_time((segment_index(i)-1)*(trajectory.N+1)+1:(segment_index(i))*(trajectory.N+1)) = ...
      [current_time^0 current_time^1 current_time^2 ...
      current_time^3 current_time^4 current_time^5 current_time^6 ...
      current_time^7 current_time^8 current_time^9 current_time^10 ...
      current_time^11];
    
    % Now evalute the collision cost.
    %J_coll = J_coll + current_dist*(p(i, 1)^2 + p(i, 2)^2);

    % Get cost map gradients.
    %cost_map_grad(1) = current_dist * (2*p(i, 1));
    %cost_map_grad(2) = current_dist * (2*p(i, 2));
    
    % Figure out norm of the velocity in both directions.
    %vel_norm = 0;
    for k = 1:trajectory.K
      % Term 1 - collision term.
      coeffs = A_invs{k}*Ms{k}*[D_Fs{k};D_Ps{k}];
      vel(k) = grad_time * A_der * coeffs;
    end
    vel_norm = norm(vel);
    %disp(sprintf('Distance: %f, vel_norm * delta_t: %f', current_dist, vel_norm * delta_t));
    %dist_norm = delta_t * vel_norm;
    
    %% Get collision cost and gradients from ESDF
%     % Now evalute the collision cost.
%     collision_cost = get_table_value_at_pos(p(i, :), map, cost_map);
%     %disp(sprintf('%f: [%f %f] c: %f',  t(i), p(i, 1), p(i, 2), collision_cost));
%     J_coll = J_coll + delta_t * vel_norm * collision_cost;
%  
%     % Get cost map gradients.
%     cost_map_grad(1) = get_table_value_at_pos(p(i, :), map, cost_map_x, 0);
%     cost_map_grad(2) = get_table_value_at_pos(p(i, :), map, cost_map_y, 0);
    %% Get collision cost and gradients from hilbert map
    % Now evalute the collision cost.
    switch param.mapping
        case 'local'
            [dphi, phi] = diff_kernelFeatures(param, p(i, :) - p(1, :), localmap, param.hilbertmap.kernel);
        otherwise
            [dphi, phi] = diff_kernelFeatures(param, p(i, :), localmap, param.hilbertmap.kernel);
    end
    occ_prob = 1-1/(1+exp(dot(hilbertmap.wt, phi)));
    docc_prob = occ_prob*(1-occ_prob)*(hilbertmap.wt)'*dphi;
    %disp(sprintf('%f: [%f %f] c: %f',  t(i), p(i, 1), p(i, 2), collision_cost));
    collision_cost = occ_prob;
    J_coll = J_coll + delta_t * vel_norm * collision_cost;
 
    % Get cost map gradients.
    cost_map_grad(1) = docc_prob(1);
    cost_map_grad(2) = docc_prob(2);    
    
    for k = 1:trajectory.K
      % Get the gradients for this axis.
      grad_p_dp = grad_time * grad_map{k};

      % Term 1 - collision term.
      coeffs = A_invs{k}*Ms{k}*[D_Fs{k};D_Ps{k}];
      vel(k) = grad_time * A_der * coeffs;
      grad_vel_p = grad_time * A_der;
      %grad_term_1 = collision_cost * delta_t^2 / current_dist * vel * grad_vel_p * grad_map{k};
      if (vel_norm < 0.001)
        grad_term_1 = 0;
      else
        grad_term_1 = collision_cost * delta_t / vel_norm * vel(k) * grad_vel_p * grad_map{k};
      end
      % Term 2 - derivative of collision cost term.
      grad_term_2 = delta_t * vel_norm * cost_map_grad(k) * grad_p_dp;
      
      if (collision_cost > 0)
        breakpoint_here = 0;
      end
      
      if (~isempty(grad_coll) && ~isempty(grad_coll{k}))
        grad_coll{k} = grad_coll{k} + grad_term_1 + grad_term_2;
      else
        grad_coll{k} = grad_term_1 + grad_term_2;
      end
    end
    %% Get Uncertainty cost and gradients from hilbertmap
    if occ_prob <= 1e-5
        occ_prob = 1e-5; % Handle exception where occ_prob = 0
    end
    occ_entropy = (-(1-occ_prob) * log2(1-occ_prob) - occ_prob * log2(occ_prob));
    docc_entropy = log2((1-occ_prob)/occ_prob)*docc_prob;
    entropy_cost = occ_entropy;
    J_entropy = J_entropy + delta_t * vel_norm * entropy_cost;
    cost_entropy_grad(1) = docc_entropy(1);
    cost_entropy_grad(2) = docc_entropy(2);
    
    for k = 1:trajectory.K
      % Get the gradients for this axis.
      grad_p_dp = grad_time * grad_map{k};

      % Term 1 - collision term.
      coeffs = A_invs{k}*Ms{k}*[D_Fs{k};D_Ps{k}];
      vel(k) = grad_time * A_der * coeffs;
      grad_vel_p = grad_time * A_der;
      %grad_term_1 = collision_cost * delta_t^2 / current_dist * vel * grad_vel_p * grad_map{k};
      if (vel_norm < 0.001)
        grad_term_1 = 0;
      else
        grad_term_1 = entropy_cost * delta_t / vel_norm * vel(k) * grad_vel_p * grad_map{k};
      end
      % Term 2 - derivative of collision cost term.
      grad_term_2 = delta_t * vel_norm * cost_entropy_grad(k) * grad_p_dp;
      
      if (entropy_cost > 0)
        breakpoint_here = 0;
      end
      
      if (~isempty(grad_entropy) && ~isempty(grad_entropy{k}))
        grad_entropy{k} = grad_entropy{k} + grad_term_1 + grad_term_2;
      else
        grad_entropy{k} = grad_term_1 + grad_term_2;
      end
    end

  current_dist = 0;
  delta_t = 0;
  end
end

%% Get Goal Cost
J_goal = 0;
goal = param.goal_point;
traj_end = p(end, :);
% Naive goal cost
% J_goal = norm(goal - traj_end);
% dJ_goal = traj_end - goal;
% Saled goal cost
r = 0.01;
dg = norm(goal - p(1, :)) + r;
J_goal = (norm(goal - traj_end) - dg)/dg;
dJ_goal = (1/dg) * (traj_end - goal);

for k = 1:trajectory.K
    grad_p_dp = grad_time * grad_map{k};
    grad_goal{k} = dJ_goal(k)* grad_p_dp;
end


%%

x0;
times;

% IMPORTANT TO DO: make this work for multiple segments! Have to get
% within-segment time. Set grad_watev to 0 outside the segment. Then it's
% easy and everything works out.

J_der;
J_coll;

grad_coll{1}';

grad_coll{2}';

% TODO: add weights.
cost = w_der * J_der + w_coll * J_coll + w_goal * J_goal + w_entropy * J_entropy;

% Stack the gradients back.
gradient = [];
current_index = 0;
for k = 1:trajectory.K
  gradient(current_index+1:current_index + length(grad_coll{k})) = w_der * grad_ders{k} + w_coll * grad_coll{k} + w_goal * grad_goal{k} + w_entropy * grad_entropy{k};
  current_index = current_index + length(grad_coll{k});
end
figure(findobj('name', 'Optimizer'));
plot(p(1, 1), p(1, 2), 'go'); hold on;
plot(p(:, 1), p(:, 2), 'g-'); hold on;
plot(p(end, 1), p(end, 2), 'gx'); hold on;
end