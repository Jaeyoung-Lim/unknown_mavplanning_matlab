function map = create_image_map(filepath)

image = imread(filepath);

grayimage = rgb2gray(image);
bwimage = grayimage < 122;

map = robotics.BinaryOccupancyGrid(bwimage);

end