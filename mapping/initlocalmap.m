function localmap_obs = initlocalmap(params)
    localmap_obs = robotics.OccupancyGrid(params.globalmap.width, params.globalmap.height, params.globalmap.resolution);
end