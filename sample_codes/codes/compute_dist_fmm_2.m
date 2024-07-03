function compute_dist_fmm_2(input_fname,mode,year,outpath,ncores,empty_speed)

% ----------------------------------------------------------------------
% This code computes the distance between some predefined locations
% in input_fname using FMM. The output is mode-year specific. Call loc_1.m
% to generate the coordinates of the pre-defined locations.
% ----------------------------------------------------------------------

    if nargin < 5
        ncores = 4;
        msg = ['No input on ncores; setting ncores to ' num2str(ncores)];
        fprintf(1,'%s\n',msg);
    end

    if nargin < 6
        empty_speed = 10;
        msg = ['no input on empty_speed; setting empty_speed to ' num2str(empty_speed)];
        fprintf(1,'%s\n',msg);
    end
    
    run define_path.m;
    run define_map_dimension.m;
    
    fname_split = split(input_fname,'.') ;

    % ----------------------------------------------------------------------
    % Load the destination locations
    % ----------------------------------------------------------------------
    fname         = [outpath '/coordinates_' fname_split{1} '_des.csv'];
    [id_des long_des lat_des pos_y_list_des pos_x_list_des k h] = textread(fname,'%s %f %f %d %d %f %f',...
                                                      'delimiter',',','headerlines',1);

    ndes          = length(id_des);
    ind_list_des  = sub2ind([ymax,xmax],pos_x_list_des,pos_y_list_des);

    % ----------------------------------------------------------------------
    % Load the origin locations
    % ----------------------------------------------------------------------
    fname          = [outpath '/coordinates_' fname_split{1} '_ori.csv'];
    [id_ori long_ori lat_ori pos_y_list_ori pos_x_list_ori k h] = textread(fname,'%s %f %f %d %d %f %f',...
                                                      'delimiter',',','headerlines',1);

    nori           = length(id_ori);

    % The index list of the origins
    ind_list_ori   = sub2ind([ymax,xmax],pos_x_list_ori,pos_y_list_ori);

    % FMM is memory hungry. Rule of thumb is 6gb per core.
    try
        mypool = parpool(ncores);               
    end

    % Reusing some legacy codes, and hence the renaming.    
    road = mode;
    
    % ==================================================
    % Create the friction matrix. The unit here is a minute
    % ==================================================

    time_output = func_friction_map(mode,year,empty_speed);
    dist_output = zeros(nori,ndes);

    % ======================================================================
    % Main code, looping over the origins
    % ======================================================================


    parfor iori = 1:nori

        pos_x = pos_x_list_ori(iori);
        pos_y = pos_y_list_ori(iori);

        % --------------------------------------------------
        % The units here are in minutes
        % --------------------------------------------------
        
        % Distance to all pixels, using Accurate Fast Marching from Mathworks.
        dist_map                 = (msfm(1./time_output, [pos_x;pos_y], true, true));

        % Select destination
        dist_vec                 = dist_map(ind_list_des);
        dist_output(iori,:)      = dist_vec; 
        
        fprintf(1,'==================================================\n')
        fprintf(1,'%30s:%30g\n',' Finished Origin',iori);
        fprintf(1,'==================================================\n')
        
    end 
    
    fname_output = [outpath '/dist_fmm_' fname_split{1} '_' road '_' num2str(year) '.csv'];

    time_table     = zeros(ndes,1);
    id_ori_table   = cell(ndes,1);
    long_ori_table = zeros(ndes,1);
    lat_ori_table  = zeros(ndes,1);

    % Arrange the output files in the same order as the input. 
    for ides = 1:ndes
        id = id_des{ides};
        split_str = split(id,'_');

        % Find out the row number of the origin location
        ori                  = ['o_' split_str{2}];
        pos_ori              = find(strcmp(id_ori,ori));

        % Convert the output to the unit of hours
        time_table(ides)     = dist_output(pos_ori,ides)/60;

        id_ori_table{ides}   = id_ori{pos_ori};
        long_ori_table(ides) = long_ori(pos_ori);
        lat_ori_table(ides)  = lat_ori(pos_ori);
        
    end

    fname_out  = [outpath '/t_mat_' fname_split{1} '_' road '_' num2str(year) '.csv'];

    % write to file
    table_out = table(id_ori_table,long_ori_table,lat_ori_table,long_des,lat_des,time_table,...
                      'VariableNames',{'id_ori','long_ori','lat_ori','long_des','lat_des','time_cost'}); 
    writetable(table_out,fname_out);

    
end
