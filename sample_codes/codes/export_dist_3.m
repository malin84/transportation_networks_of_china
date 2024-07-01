function export_dist_3(file_type,year,outpath)

% ----------------------------------------------------------------------
% Compute the (weighted) average distance to cities of each village We
% can skip combine_dist_3.m and directly call this after
% compute_dist_village_2.m
% ----------------------------------------------------------------------


    run define_figure_spec.m

    % file_type    = 'buyer';
    % year         = '2007';

    dist_list   = {'rail_hsr_combined','nationalroad_highway_combined'};


    % ----------------------------------------------------------------------
    % Load the destination locations
    % ----------------------------------------------------------------------
    fname         = [outpath '/coordinates_loc_output_' file_type '_' year '_des.csv'];
    [id_des long_des lat_des pos_y_list_des pos_x_list_des k h] = textread(fname,'%s %f %f %d %d %f %f',...
                                                      'delimiter',',','headerlines',1);

    ndes          = length(id_des);

    % ----------------------------------------------------------------------
    % Load the origin locations
    % ----------------------------------------------------------------------

    fname          = [outpath '/coordinates_loc_output_' file_type '_' year '_ori.csv'];
    [id_ori long_ori lat_ori pos_y_list_ori pos_x_list_ori k h] = textread(fname,'%s %f %f %d %d %f %f',...
                                                      'delimiter',',','headerlines',1);

    nori       = length(id_ori);

    fname_in   = [outpath '/' file_type '_' year '_rail_hsr_combined_dist_fmm'];
    dist_rail  = load(fname_in);

    fname_in   = [outpath '/' file_type '_' year '_nationalroad_highway_combined_dist_fmm'];
    dist_road  = load(fname_in);


    time_rail_good = zeros(ndes,1);
    time_rail_pass = zeros(ndes,1);
    time_road      = zeros(ndes,1);
    id_ori_table   = cell(ndes,1);
    long_ori_table = zeros(ndes,1);
    lat_ori_table  = zeros(ndes,1);

    for ides = 1:ndes
        id = id_des{ides};
        split_str = split(id,'_');

        % Find out the row number of the origin location
        ori       = ['o_' split_str{2}];
        pos_ori   = find(strcmp(id_ori,ori));
        
        time_rail_good(ides) = dist_rail.dist_output_good(pos_ori,ides)/60;
        time_rail_pass(ides) = dist_rail.dist_output_pass(pos_ori,ides)/60;
        time_road(ides)      = dist_road.dist_output_good(pos_ori,ides)/60;

        id_ori_table{ides}   = id_ori{pos_ori};
        long_ori_table(ides) = long_ori(pos_ori);
        lat_ori_table(ides)  = lat_ori(pos_ori);
        
    end

    fname_out  = [outpath '/t_mat_' file_type '_' year '.csv'];

    % Convert to hours
    table_out = table(id_ori_table,long_ori_table,lat_ori_table,long_des,lat_des,time_rail_good,time_rail_pass,time_road,...
                      'VariableNames',{'id_ori','long_ori','lat_ori','long_des','lat_des','time_rail_good','time_rail_pass','time_road'}); 
    writetable(table_out,fname_out);


end