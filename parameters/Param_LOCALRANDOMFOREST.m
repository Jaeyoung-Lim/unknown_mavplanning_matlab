classdef Param_LOCALRANDOMFOREST
    properties
        
        visualization = 'summary';
        generate_data = true;
        
        map_type = 'randomforest';
        map_generate = true;
        mapping = 'local';
        
        % Gloabal Map parameters
        globalmap = struct('width', 20, ...
                            'height', 20, ...
                            'inflation', 0.4, ...
                            'resolution', 10, ...
                            'numsamples', 80 ...
                            );
        % Local Map parameters
        localmap = struct('width', 10, ...
                          'height', 10, ...
                          'resolution', 10);
                      
        hilbertmap = struct('enable', true, ...
                            'kernel', 'sparse', ...
                            'resolution', 2, ...
                            'radius', 1, ...
                            'max_iteration', 200, ...
                            'learningrate', 0.3, ...
                            'render', true, ...
                            'render_resolution', 10, ...
                            'plot', true);

        sensor = struct('fov', 0.5*pi(), ...
                        'maxrange', 5);
        
        mav = struct('size', 0.5);
        
        % Planner
        planner = 'chomp'
        plan_horizon = 5;
        update_rate = 1;        
        
        global_planner = 'optimistic';
        globalreplan = true;
        localgoal = 'random'
        
        start_point = [5.0 5.0];
        goal_point = [15.0 15.0];

        
    end 
    methods
    end
end