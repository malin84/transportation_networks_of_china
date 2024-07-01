function compute_dist_fmm_2(file_type,year,outpath,ncores)

% ----------------------------------------------------------------------
% This code computes the distance between some predefined locations
% and cities using FMM. The output is mode-year specific. The city
% location comes from the econ-geography project. call loc_1.m to
% generate the coordinate of the pre-defined locations.
% ----------------------------------------------------------------------

    run define_path.m;

    % The scale info for the 8k map
    load('scale_info');

    road_list    = {'nationalroad_highway_combined','rail_hsr_combined'};

    % ----------------------------------------------------------------------
    % Load the destination locations
    % ----------------------------------------------------------------------
    fname         = [outpath '/coordinates_loc_output_' file_type '_' year '_des.csv'];
    [id_des long_des lat_des pos_y_list_des pos_x_list_des k h] = textread(fname,'%s %f %f %d %d %f %f',...
                                                      'delimiter',',','headerlines',1);

    ndes          = length(id_des);

    ind_list_des  = sub2ind([ymax,xmax],pos_x_list_des,pos_y_list_des);

    % ----------------------------------------------------------------------
    % Load the origin locations
    % ----------------------------------------------------------------------

    fname          = [outpath '/coordinates_loc_output_' file_type '_' year '_ori.csv'];
    [id_ori long_ori lat_ori pos_y_list_ori pos_x_list_ori k h] = textread(fname,'%s %f %f %d %d %f %f',...
                                                      'delimiter',',','headerlines',1);

    nori           = length(id_ori);

    % The index list of the origins
    ind_list_ori   = sub2ind([ymax,xmax],pos_x_list_ori,pos_y_list_ori);

    % FMM is memory hungry. Rule of thumb is 6gb per core.
    try
        mypool = parpool(ncores);               
    end

    for iroad = 1:length(road_list)
        
        road = road_list{iroad};
        
        fprintf(1,'==================================================\n')
        fprintf(1,'%30s:%30s\n','Year',year);
        fprintf(1,'%30s:%30s\n','File Type',file_type);
        fprintf(1,'%30s:%30s\n','Mode',road);
        fprintf(1,'==================================================\n')

        % ==================================================
        % Create the friction matrix. The unit here is minute
        % ==================================================

        fname_input = [aligned_map_path 'time_' road '_' year];

        load(fname_input,'time_output_good','time_output_pass');

        dist_output_good = zeros(nori,ndes);
        dist_output_pass = zeros(nori,ndes);

        % ======================================================================
        % Main code, looping over the pre-defined locations
        % ======================================================================


        parfor iori = 1:nori

            pos_x = pos_x_list_ori(iori);
            pos_y = pos_y_list_ori(iori);

            % --------------------------------------------------
            % Goods. The units here is in minutes
            % --------------------------------------------------
            
            % Distance to all pixels
            dist_map                 = (msfm(1./time_output_good, [pos_x;pos_y], true, true));

            % Select destination
            dist_vec                      = dist_map(ind_list_des);
            dist_output_good(iori,:)      = dist_vec; 
            
            fprintf(1,'==================================================\n')
            fprintf(1,'%30s:%30g\n','Goods, Finished Location',iori);
            fprintf(1,'==================================================\n')

            
            % --------------------------------------------------
            % Passengers. The units here is in minutes. Only do it for
            % railroads.
            % --------------------------------------------------
            switch road
              case 'rail_hsr_combined'
                % Distance to all pixels
                dist_map                 = (msfm(1./time_output_pass, [pos_x;pos_y], true, true));

                % Select destination
                dist_vec                      = dist_map(ind_list_des);
                dist_output_pass(iori,:)      = dist_vec; 
                
                fprintf(1,'==================================================\n')
                fprintf(1,'%30s:%30g\n','Passengers, Finished Location',iori);
                fprintf(1,'==================================================\n')
                
              case 'nationalroad_highway_combined'
                % No need to recompute anything, as we assume that 
                dist_output_pass(iori,:)      = dist_output_good(iori,:);
              otherwise
                msg = ['unknown road type: ' road];
                error(msg);
            end
            
            
        end 
        
        fname_output = [outpath '/' file_type '_' year '_' road '_dist_fmm'];
        save(fname_output,'dist_output_good','dist_output_pass');
    end


    poolobj = gcp('nocreate');
    delete(poolobj);
end