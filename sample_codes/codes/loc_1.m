function loc_1(file_type,year,outpath)
% ----------------------------------------------------------------------
% Map the coordinates into x-y positions of locations in the 8k maps
% ----------------------------------------------------------------------


% Define the path of the input and output files;
    run define_path;

    if ~exist(outpath,'dir')
        mkdir(outpath);
    end
    
    % outpath = 'output/';

    % Define the boundary
    long_min = 72;
    long_max = 135;

    lat_min  = 18;
    lat_max  = 124;

    % file_type = 'buyer';
    % year      = '2007';

    % Load the coordinates
    [long_ori lat_ori long_des lat_des id_ori] = textread(['input/firm-' file_type '_' year '.csv'],'%f %f %f %f %f','delimiter',',', 'headerlines',1);

    % Clean data;
    ind_drop = false(size(long_ori));
    
    ind_drop = ind_drop | long_ori < long_min;
    ind_drop = ind_drop | long_ori > long_max;
    ind_drop = ind_drop | lat_ori < lat_min;
    ind_drop = ind_drop | lat_ori > lat_max;

    ind_drop = ind_drop | long_des < long_min;
    ind_drop = ind_drop | long_des > long_max;
    ind_drop = ind_drop | lat_des < lat_min;
    ind_drop = ind_drop | lat_des > lat_max;

    fprintf(1,'============================================================\n')
    if any(ind_drop)
        fprintf(1,'%60s\n','Out of range records to be dropped:');
        list_drop = find(ind_drop);
        fprintf(1,'%14s,%14s,%14s,%14s \n','long_ori','lat_ori','long_des','lat_des');
        fprintf(1,'------------------------------------------------------------\n')
        for i = 1:length(list_drop)
            pos_drop = list_drop(i);
            fprintf(1,'%14.2f,%14.2f,%14.2f,%14.2f \n',long_ori(pos_drop),lat_ori(pos_drop),long_des(pos_drop),lat_des(pos_drop));
        end

        long_ori(ind_drop) = [];
        lat_ori(ind_drop)  = [];
        long_des(ind_drop) = [];
        lat_des(ind_drop)  = [];
        id_ori(ind_drop)   = [];
        
    else
        fprintf(1,'%60s\n','All coordinates within accessible range');
    end
    fprintf(1,'============================================================\n')
    
    

    
    % Define which projection to use: sphere (sph) or ellipsoid (ell);

    spec = 'sph';

    switch spec
      case 'sph'
        albers = @(x,y) albers_sph(x,y);
      case 'ell'
        albers = @(x,y) albers_ell(x,y);
    end


    % ----------------------------------------------------------------------
    % The origins
    % ----------------------------------------------------------------------

    % Do not use the provided ID. Generate a new ID. IC here is the variable that contains the ID at the record level.
    [coord_ori_unique ia ic] = unique([long_ori lat_ori],'rows');

    nloc = size(coord_ori_unique,1);
    long_unique = coord_ori_unique(:,1);
    lat_unique  = coord_ori_unique(:,2);


    id_ori = cell(nloc,1);
    for i = 1:nloc
        id_ori{i} = ['o_' num2str(i)];
    end

    fname_ori = [file_type '_' year '_ori' ];

    func_loc(long_unique,lat_unique,id_ori,fname_ori,outpath);

    % ----------------------------------------------------------------------
    % The destinations
    % ----------------------------------------------------------------------

    ndes   = length(ic);

    id_des = cell(ndes,1);

    for i = 1:ndes
        id_des{i} = ['d_' num2str(ic(i)) '_' num2str(i)];
    end

    fname_des = [file_type '_' year '_des' ];

    func_loc(long_des,lat_des,id_des,fname_des,outpath);
end