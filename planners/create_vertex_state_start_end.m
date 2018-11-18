function [ vertex ] = create_vertex_state_start_end( p, v, a, N )
%add_vertex_position Summary of this function goes here
%   Detailed explanation goes here

vertex.constraints = zeros((N+1)/2);
vertex.constraints(1) = p;
vertex.constraints(2) = v;
vertex.constraints(3) = a;
vertex.isFixed = zeros((N+1)/2);
vertex.isFixed(1:5) = 1;
vertex.num_fixed = 5;
end