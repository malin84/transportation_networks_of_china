% ----------------------------------------------------------------------
% Compute origin-to-destination travel time using multi-source Dijkstra on raster.
% ----------------------------------------------------------------------
function compute_dist_dijkstra_0(input_fname, mode, year, outpath, ncores, empty_speed)

    if nargin < 5 || isempty(ncores)
        ncores = 4;
        fprintf(1,'No input on ncores; setting ncores to %d\n', ncores);
    end

    if nargin < 6 || isempty(empty_speed)
        empty_speed = 10;
        fprintf(1,'No input on empty_speed; setting empty_speed to 10 (unused in Dijkstra)\n');
    end

    old = maxNumCompThreads(ncores);
    c = onCleanup(@() maxNumCompThreads(old));

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

    [id_des, long_des, lat_des, pos_y_des, pos_x_des, k, h] = textread( ...
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

    [id_ori, long_ori, lat_ori, pos_y_ori, pos_x_ori, k, h] = textread( ...
        fname_ori, '%s %f %f %d %d %f %f', 'delimiter', ',', 'headerlines', 1);

    nori = length(id_ori);
    ind_list_ori = sub2ind([ymax, xmax], pos_x_ori, pos_y_ori);


    % -----------------------------------------------------
    % Create the friction matrix. The unit here is a minute
    % -----------------------------------------------------
    time_output = func_friction_map(mode,year,empty_speed);

    % -------------------------------------------------------
    % Dijkstra: build one point list then slice (ori -> des)
    % -------------------------------------------------------
    ind_all = [ind_list_ori; ind_list_des];

    tic;
    fprintf(1,'Building graph and computing distances...\n');
    D_all = compute_city_city_dijkstra_allow_duplicate(time_output, ind_all);
    toc;

    % Slice origin-to-destination block
    dist_output = D_all(1:nori, nori+1:end);

    % ---------------
    % Arrange output
    % ---------------
    time_table     = zeros(ndes,1);
    id_ori_table   = cell(ndes,1);
    long_ori_table = zeros(ndes,1);
    lat_ori_table  = zeros(ndes,1);

    for ides = 1:ndes
        id = id_des{ides};         
        split_str = split(id,'_');

        % Find origin row: ori id = 'o_' + split_str{2}
        ori = ['o_' split_str{2}];
        pos_ori = find(strcmp(id_ori, ori), 1);

        % Convert minutes -> hours
        time_table(ides) = dist_output(pos_ori, ides) / 60;

        id_ori_table{ides}   = id_ori{pos_ori};
        long_ori_table(ides) = long_ori(pos_ori);
        lat_ori_table(ides)  = lat_ori(pos_ori);
    end

    fname_out = fullfile(outpath, ['t_mat_' prefix '_' mode '_' num2str(year) '.csv']);

    table_out = table(id_ori_table, long_ori_table, lat_ori_table, long_des, lat_des, time_table, ...
        'VariableNames', {'id_ori','long_ori','lat_ori','long_des','lat_des','time_cost'});

    writetable(table_out, fname_out);
    fprintf(1,'Saved output: %s\n', fname_out);

end
