function map = generate_envwithPos(params, start_pos, goal_pos)

while true
    switch params.map_type
        case 'randomforest'
            map = create_random_map(params.globalmap.width, params.globalmap.height, params.globalmap.resolution, params.globalmap.numsamples, params.globalmap.inflation);

        case 'image'
            map = create_image_map(params.map_path);

        otherwise
            print('map generation option is not valid');
    end
    map_inflate = copy(map);
    map_inflate.inflate(0.4);
    if ~map_inflate.getOccupancy(start_pos) && ~map_inflate.getOccupancy(goal_pos)
        break;
    end

end

end