function localmap_obs = initlocalmap(params)
    switch params.mapping
        case 'local'
            localmap_obs = robotics.OccupancyGrid(params.localmap.width, params.localmap.height, params.localmap.resolution);
        case 'increment'
            localmap_obs = robotics.OccupancyGrid(params.globalmap.width, params.globalmap.height, params.globalmap.resolution);
    end
end