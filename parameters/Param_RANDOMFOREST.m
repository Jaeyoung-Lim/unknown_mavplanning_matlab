classdef Param_RANDOMFOREST
    properties
        
        visualization = true;
        
        map_type = 'randomforest';
        % Gloabal Map parameters
        globalmap = struct('width', 20, ...
                            'height', 20, ...
                            'inflation', 0.4, ...
                            'resolution', 10, ...
                            'numsamples', 80 ...
                            );
        % Local Map parameters
        localmap = struct('width', 5, ...
                          'height', 5, ...
                          'resolution', 10);

        sensor = struct('fov', 2*pi(), ...
                        'maxrange', 100);
                    
        
        % Planner
        planner = 'chomp'
        
        start_point = [5.0 5.0];
        goal_point = [15.0 15.0];
        
    end 
    methods
    end
end