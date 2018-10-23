options = {};
options.plotting = true;
options.map = 'corridor';

switch options.map
    case 'randomforest'        
        % Gloabal Map parameters
        width_m = 20;
        height_m = 20;
        inflation_m = 0.4;
        resolution_m = 10;
        numsamples_m = 80;

        start_point = [5.0 5.0];
        goal_point = [15.0 15.0];

        % Local Map parameters
        width_subm = 5;
        height_subm = 5;

    case 'corridor'
        % Gloabal Map parameters
        width_m = 20;
        height_m = 20;
        inflation_m = 0.4;
        resolution_m = 1;
        numsamples_m = 80;

        start_point = [20 20];
        goal_point = [190 190];

        % Local Map parameters
        width_subm = 20;
        height_subm = 20;
end

% Sensor parameters
maxrange = 20;
fov = 2*pi();
