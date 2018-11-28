function localpos = global2localpos(params, globalpos, mav_pos)

    origin = [0.5*params.localmap.width, 0.5*params.localmap.height]; % For Robocentric Coordinates
    localpos = globalpos - mav_pos;
end