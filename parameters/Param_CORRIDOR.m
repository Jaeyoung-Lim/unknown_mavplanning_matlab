classdef Param_CORRIDOR
    properties
        
        visualization = 'summary';
        generate_data = true;
        
        map_type = 'corridor';
        map_generate = true;
        mapping = 'increment';
        
        % Gloabal Map parameters
        globalmap = struct('width', 40, ...
                            'height', 43, ...
                            'inflation', 0.4, ...
                            'resolution', 5, ...
                            'numsamples', 100 ...
                            );
        % Local Map parameters
        localmap = struct('width', 5, ...
                          'height', 5, ...
                          'resolution', 10);

        sensor = struct('fov', 0.1*pi(), ...
                        'maxrange', 10);
        
        mav = struct('size', 0.5);
        
        % Planner
        planner = 'chomp'
        plan_horizon = 5;
        update_rate = 1;        
        
        global_planner = 'optimistic';
        globalreplan = true;
        localgoal = 'nextbestview'
        
        start_point = [5.0 5.0];
        goal_point = [15.0 15.0];

        
    end 
    methods
    end
end