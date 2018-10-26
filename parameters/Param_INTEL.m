classdef Param_INTEL
    properties
        
        visualization = true;
        
        map_type = 'image';
        map_path = '/home/jalim/dev/unknown_mavplanning_matlab/data/blobby_map.png';
        % Gloabal Map parameters
        globalmap = struct('width', 20, ...
                            'height', 20, ...
                            'inflation', 0.4, ...
                            'resolution', 1, ...
                            'numsamples', 80 ...
                            );
        % Local Map parameters
        localmap = struct('width', 100, ...
                          'height', 100, ...
                          'resolution', 1);

        sensor = struct('fov', 2*pi(), ...
                        'maxrange', 100);
                    
        
        % Planner
        planner = 'chomp'
        
        start_point = [150 150];
        goal_point = [190 190];
        
    end 
    methods
    end
end