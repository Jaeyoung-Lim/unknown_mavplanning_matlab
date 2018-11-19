function r = create_straight(pose, length, width, resolution)
    origin = pose(1:2);
    theta = pose(3);
    r = [];
   
    for d=0:1/(2*resolution):length
        pos = origin + [d*cos(theta), d*sin(theta)];
        for h= -0.5*width:1/(2*resolution):0.5*width
            dpos = pos + [h*sin(theta), h*cos(theta)]; 
            r= [r; dpos];
        end
    end
    for d=0:1/(2*resolution):0.5*width
        pos = origin - [d*cos(theta), d*sin(theta)];
        for h= -0.5*width:1/(2*resolution):0.5*width
            dpos = pos + [h*sin(theta), h*cos(theta)]; 
            r= [r; dpos];
        end
    end

end