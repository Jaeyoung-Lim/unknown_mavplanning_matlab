res = [0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0];
width = 18.0;
length = 7.0;
height = 6.0;

num_anchors = zeros(1, size(res, 2));

for i = 1:size(res, 2)
    num_anchors(i) = round(width/res(i)) * round(length/res(i)) * round(height/res(i));
end
