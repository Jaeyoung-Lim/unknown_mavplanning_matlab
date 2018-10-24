options = {};
options.plotting = true;
options.map = 'image';
options.planner = 'chomp';

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

    case 'image'
%         % For intel 
%         % Gloabal Map parameters
%         width_m = 20;
%         height_m = 20;
%         inflation_m = 0.4;
%         resolution_m = 1;
%         numsamples_m = 80;
% 
%         start_point = [150 150];
%         goal_point = [190 190];
% 
%         % Local Map parameters
%         width_subm = 100;
%         height_subm = 100;
        
        %For blobby
        width_m = 20;
        height_m = 20;
        inflation_m = 0.4;
        resolution_m = 1;
        numsamples_m = 80;

        start_point = [20.0 20.0];
        goal_point = [190.0 190.0];

        % Local Map parameters
        width_subm = 20;
        height_subm = 20;

end

% Sensor parameters
maxrange = 100;
fov = 2*pi();
