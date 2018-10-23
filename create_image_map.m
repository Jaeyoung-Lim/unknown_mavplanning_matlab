function map = create_image_map(filepath)

image = imread(filepath);

grayimage = rgb2gray(image);
bwimage = grayimage < 0.5;

map = robotics.BinaryOccupancyGrid(bwimage);

end