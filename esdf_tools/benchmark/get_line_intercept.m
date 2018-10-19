function [pos] = get_line_intercept(line1, line2)
% Input format: [m b], [m b] where y = mx + b for both lines.

x = (line2(2) - line1(2))/(line1(1) - line2(1));
y = line1(1) * x + line1(2);

pos = [x y];

end

