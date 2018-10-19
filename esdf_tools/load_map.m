function map = get_map(resolution_m)
%map = robotics.BinaryOccupancyGrid(width_m, height_m, resolution_m);
image = imread('data/blobby_map.png');

% Convert to grayscale and then black and white image based on arbitrary
% threshold.
grayimage = rgb2gray(image);
bwimage = grayimage < 0.5;

% Use black and white image as matrix input for binary occupancy grid
map = robotics.BinaryOccupancyGrid(bwimage, resolution_m);

end