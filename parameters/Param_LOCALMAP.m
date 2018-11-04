classdef Param_LOCALMAP
    properties
                
        map_type = 'randomforest';
        mapping = 'local';
        
        % Gloabal Map parameters
        globalmap = struct('width', 5,...
                            'height', 5, ...
                            'inflation', 0.4, ...
                            'resolution', 5, ...
                            'numsamples', 5 ...
                            );
        
    end 
    methods
    end
end