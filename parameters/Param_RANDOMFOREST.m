classdef Param_RANDOMFOREST
    properties
        
        visualization = 'summary';
        generate_data = true;
        
        map_type = 'randomforest';
        map_generate = false;
        mapping = 'increment';
        
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
                        'maxrange', 10);
        
        mav = struct('size', 0.5);
        
        % Planner
        planner = 'chomp'
        global_planner = 'optimistic';
        localgoal = 'random'
        
%         start_point = [5.0 5.0];
%         goal_point = [15.0 15.0];
        start_point = [];
        goal_point = [];

        
    end 
    methods
    end
end