classdef Param_LOCALCORRIDOR
    properties
        
        visualization = 'summary';
        generate_data = true;
        
        map_type = 'corridor';
        map_generate = true;
        mapping = 'local';
        
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
                      
        hilbertmap = struct('enable', true, ...
                        'kernel', 'threshold', ...
                        'resolution', 10, ...
                        'radius', 1, ...
                        'max_iteration', 20, ...
                        'learningrate', 0.3, ...
                        'render', true, ...
                        'render_resolution', 10, ...
                        'plot', true);

        sensor = struct('fov', 0.5*pi(), ...
                        'maxrange', 10);
        
        mav = struct('size', 0.5);
        
        % Planner
        planner = 'chomp'
        plan_horizon = 5;
        update_rate = 1;        
        
        global_planner = 'disable';
        globalreplan = true;
        localgoal = 'nextbestview'
        
        start_point = [5.0 5.0];
        goal_point = [15.0 15.0];

        
    end 
    methods
    end
end