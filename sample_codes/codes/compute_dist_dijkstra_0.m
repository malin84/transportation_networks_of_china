% ----------------------------------------------------------------------
% Compute origin-to-destination travel time using multi-source Dijkstra on raster.
% ----------------------------------------------------------------------
function compute_dist_dijkstra_0(input_fname, mode, year, outpath, ncores, empty_speed)

    if nargin < 5 || isempty(ncores)
        ncores = 4;
        fprintf(1,'No input on ncores; setting ncores to %d\n', ncores);
    end

    if nargin < 6
        empty_speed = 10;
        fprintf(1,'No input on empty_speed; setting empty_speed to 10 (unused in Dijkstra)\n');
    end

    run define_path.m;
    run define_map_dimension.m;

    % -------------------------
    % Parse prefix from input_fname
    % -------------------------
    fname_split = split(input_fname, '.');
    prefix = fname_split{1};

    % -------------------------
    % Load destination locations
    % -------------------------
    fname_des = fullfile(outpath, ['coordinates_' prefix '_des.csv']);
    if ~exist(fname_des, 'file')
        error('Destination coordinate file not found: %s', fname_des);
    end

    [id_des, long_des, lat_des, pos_y_des, pos_x_des, k_des, h_des] = textread( ...
        fname_des, '%s %f %f %d %d %f %f', 'delimiter', ',', 'headerlines', 1);

    ndes = length(id_des);
    ind_list_des = sub2ind([ymax, xmax], pos_x_des, pos_y_des);

    % -------------------------
    % Load origin locations
    % -------------------------
    fname_ori = fullfile(outpath, ['coordinates_' prefix '_ori.csv']);
    if ~exist(fname_ori, 'file')
        error('Origin coordinate file not found: %s', fname_ori);
    end

    [id_ori, long_ori, lat_ori, pos_y_ori, pos_x_ori, k_ori, h_ori] = textread( ...
        fname_ori, '%s %f %f %d %d %f %f', 'delimiter', ',', 'headerlines', 1);

    nori = length(id_ori);
    ind_list_ori = sub2ind([ymax, xmax], pos_x_ori, pos_y_ori);

    % -------------------------
    % Start parallel pool
    % -------------------------
    try
        parpool(60);
    catch
    end

    % -------------------------
    % Load time matrices
    % -------------------------
    fname_input = fullfile(outpath, ['time_' mode '_' num2str(year) '.mat']);
    time_output = func_friction_map(mode, year, empty_speed);
    time_output_good = time_output;
    time_output_pass = time_output;
    save(fname_input, 'time_output_good', 'time_output_pass', '-v7.3');
    
    fprintf(1,'==================================================\n');
    fprintf(1,'%30s:%30g\n','Year',year);
    fprintf(1,'%30s:%30s\n','Mode',mode);
    fprintf(1,'%30s:%30s\n','Time file (overwritten)',fname_input);
    fprintf(1,'%30s:%30s\n','Out path',outpath);
    fprintf(1,'==================================================\n');

    % -------------------------
    % Dijkstra: build one point list then slice (ori -> des)
    % -------------------------
    ind_all = [ind_list_ori; ind_list_des];

    tic;
    fprintf(1,'Building graph and computing distances (Goods)...\n');
    Dg_all = compute_city_city_dijkstra_allow_duplicate(time_output_good, ind_all);
    toc;

    tic;
    fprintf(1,'Building graph and computing distances (Pass)...\n');
    Dp_all = compute_city_city_dijkstra_allow_duplicate(time_output_pass, ind_all);
    toc;

    % Slice origin-to-destination block
    dist_output_good = Dg_all(1:nori, nori+1:end);
    dist_output_pass = Dp_all(1:nori, nori+1:end);

    % -------------------------
    % Save output
    % -------------------------
    fname_output = fullfile(outpath, ['dist_city_' mode '_' num2str(year) '_dijkstra.mat']);
    save(fname_output, ...
        'dist_output_pass', 'dist_output_good', ...
        'id_ori', 'long_ori', 'lat_ori', ...
        'id_des', 'long_des', 'lat_des');

    fprintf(1,'Saved output: %s\n', fname_output);

end
