%% Parameters
directory = '/home/jalim/dev/unknown_mavplanning_matlab/data';
num_maps = 2000;

%% Generate and save maps
param = Param_LOCALMAP;

for j=1:num_maps
    map = generate_environment(param);
    ffilepath = strcat(directory ,'/fullmap/', int2str(j),'.jpg');
    imwrite(1-map.occupancyMatrix, ffilepath);
end