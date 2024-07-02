function loc_1(input_fname,outpath,draw_loc)
% ----------------------------------------------------------------------
% Map the coordinates into x-y positions of locations in the 8k maps
% ----------------------------------------------------------------------

% Default option: do not draw the location maps as it is slow.
    if nargin < 3
        draw_loc = false;
    end
    
    

% Define the path of the input and output files;

    if ~exist(outpath,'dir')
        mkdir(outpath);
    end

    % Define the boundary to be within China
    long_min = 72;
    long_max = 135;

    lat_min  = 18;
    lat_max  = 124;

    % Load the input files
    [long_ori lat_ori long_des lat_des] = textread(['input/' input_fname],'%f %f %f %f','delimiter',',', 'headerlines',1);

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

    % Generate a new ID. IC here is the variable that contains the ID at the record level.
    [coord_ori_unique ia ic] = unique([long_ori lat_ori],'rows');

    nloc = size(coord_ori_unique,1);
    long_unique = coord_ori_unique(:,1);
    lat_unique  = coord_ori_unique(:,2);
    nori_unique = nloc;

    id_ori = cell(nloc,1);
    for i = 1:nloc
        id_ori{i} = ['o_' num2str(i)];
    end

    fname_split = split(input_fname,'.') ;
    
    fname_ori = [fname_split{1} '_ori' ];

    func_loc(long_unique,lat_unique,id_ori,fname_ori,outpath,draw_loc);

    % ----------------------------------------------------------------------
    % The destinations
    % ----------------------------------------------------------------------

    ndes   = length(ic);

    id_des = cell(ndes,1);

    for i = 1:ndes
        id_des{i} = ['d_' num2str(ic(i)) '_' num2str(i)];
    end

    fname_des = [fname_split{1} '_des' ];

    func_loc(long_des,lat_des,id_des,fname_des,outpath,draw_loc);


    [coord_des_unique ia ic] = unique([long_des lat_des],'rows');

    ndes_unique = size(coord_des_unique,1);
    
    [nori_unique ndes_unique];
    
    if nori_unique > ndes_unique
        msg = ['number of unique origins (' num2str(nori_unique) ') is greater than the number of unique destinations (' num2str(ndes_unqiue) '). Switching origin and destination could speed up the code.'];
        warning(msg)
    end
end