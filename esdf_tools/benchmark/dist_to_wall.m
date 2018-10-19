function [ dist ] = dist_to_wall( x, y )
%DIST_TO_WALL Summary of this function goes here
%   Detailed explanation goes here
% ax + by + c = 0
a = 2;
b = -1;
c = -2;

dist = -(a*x + b*y + c)/sqrt(a^2 + b^2);
end

