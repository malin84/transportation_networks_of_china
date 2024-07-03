function output = func_friction_map(mode,year,empty_speed)
% This function creates the friction map, the input to FMM, from the
% pixel level infrastructure data.
    
    if nargin < 1
        msg = 'mode = "road", "rail_pass", or "rail_good" is a required option';
        error(msg);
    else
        if ~ismember(mode, {'road','rail_pass','rail_good'})
            msg = 'mode must be a string variable that takes one of the three values: "road", "rail_pass", or "rail_good"';
            error(msg);
        end
    end

    
    if nargin < 2
        msg = '"year" can not be empty. It should be an integer between 1994 and 2017';
        error(msg);
    else
        if year < 1994 | year > 2017
            msg = '"year" should be an integer between 1994 and 2017';
            error(msg)
        end
    end
    
% Default option
    if nargin < 3
        empty_speed = 10;
        msg = ['no empty_speed provided, setting empty_speed to ' num2str(empty_speed) 'km/h.'];
        fprintf(1,'%s\n',msg);
    end
    
    run define_map_dimension;
    run define_path;
    
    fname_pixel = [pixel_data_path 'pixel_info_' mode '_' num2str(year) '.csv'];
    % Load the pixel data.
    if ~exist(fname_pixel,'file')
        msg = ['pixel file does not exist: ' fname_pixel];
        error(msg);
    else
        data_pixel = table2struct(readtable(fname_pixel),'toscalar',true);
    end
    
    sz = [ymax xmax];
    % Initialize outputs;
    
    % The simplifed distance matrix
    distance_output = distance_pixel * ones(sz);

    % Load the full distance matrix
    %load([root_path 'Data/maps/3_codes/output/distance_map.mat']);

    
    speed_output    = empty_speed * ones(sz);
    time_output     = ones(sz);
    
    speed_output(data_pixel.index) = data_pixel.speed;

    % The unit here is minutes
    time_output     = ((1 + sqrt(2))/2) * 60 * distance_output./speed_output;
    
    output          = time_output;
    
end
