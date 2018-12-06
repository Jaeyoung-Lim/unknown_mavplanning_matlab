function [t, path, path_vel, path_acc] = primitive(binary_occupancygrid, start_position, goal_position, start_velocity, goal_velocity, start_acceleration)
    if nargin < 4
        initvel = [0.0, 0.0];
        finalvel = [0.0, 0.0];
        initacc = [0.0, 0.0];
    elseif nargin < 5
        finalvel = [0.0, 0.0];
        initacc = [0.0, 0.0];
    elseif nargin < 6
        initacc = [0.0, 0.0];
    end
    K = size(start_position, 2); % Number of dimensions.
    N = 11;
    v_max = 10.0;
    a_max = 10.0;
    j_max = 1.0;
    T = 1;
    t = 0:0.1:T;

    trajectory = create_trajectory(K, N);
    coeffs = zeros(K, 3);
    goal_acceleration = zeros(1, K);
    
    for i = 1:K
       coeffs(i, :) = getCoeffs(T, start_position(i), goal_position(i), start_velocity(i), goal_velocity(i), start_acceleration(i), goal_acceleration(i));
       path(:, i) = coeffs(i, 1) / 120 * t.^5 + coeffs(i, 2) / 24 * t.^4 + coeffs(i, 3) / 6 * t.^3 + start_acceleration(i) / 2 * t.^2 + start_velocity(i) * t + start_position(i);
       path_vel(:, i) =  (1/24)*coeffs(i, 1) * t.^4 +  (1/6) * coeffs(i, 2) * t.^3 + (1/2) * coeffs(i, 3) * t.^2 + start_acceleration(i) * t + start_velocity(i);
       path_acc(:, i) = coeffs(i, 1) / 6 * t.^3 + coeffs(i, 2) / 2 * t.^2 + coeffs(i, 3) * t + start_acceleration(i);
    end  
end

function coeffs = getCoeffs(T, p0, pf, v0, vf, a0, af)
    delta_p = pf - p0 - v0* T - 0.5*a0*T^2;
    delta_v = vf - v0 - a0 * T;
    delta_a = af - a0;
    
    coeffs = (1/(T^5)) * [    720,  -360*T,  60*T^2;
                         -360*T, 168*T^2, -24*T^3;
                         60*T^2, -24*T^3,   3*T^4]*[delta_p, delta_v, delta_a]';
 
end