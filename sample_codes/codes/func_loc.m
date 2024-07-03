function output = func_loc(long,lat,id,fname,outpath,draw_map)
% Converts the longitude and latitude into positions.  Two outputs: a
% file that contains the positions and (optional) a map that shows
% the positions.


    % The default option is to skip map drawing    
    if (nargin < 6)
        draw_map = false;
    end
    
    run define_path;
    run define_map_dimension;

    % pick which projection to use.
    albers = @(x,y) albers_sph(x,y);
    
    nloc   = length(long);
    fprintf(1,'%30s:%30g\n','Number of locations',nloc);


    albers_xy = zeros(nloc,2);
    albers_kh = zeros(nloc,2);

    for i = 1:nloc
        tmp = albers(long(i),lat(i));
        albers_xy(i,1) = tmp.x;
        albers_xy(i,2) = tmp.y;

        % The scales. K applies to X, and H applies to Y.
        albers_kh(i,1) = tmp.k;
        albers_kh(i,2) = tmp.h;

    end

    % A couple of points to back out the scales

    data_scale = [110 35 6955  4817;...
                  120 30 8831  5826;...
                  90  30 3219  5551; ...
                  115 40 7782  3692;...
                  70  45 959   1377;...
                  135 50 10497 1077;...
                  140 50 11189 879;...
                  105 20 5902  8070;...
                  125 30 9761  5712;...
                  135 30 11601 5342;...
                  125 20 10086 7860;...
                 ];

    tmp  = size(data_scale);
    npt  = tmp(1);

    scale_xy = zeros(npt,2);

    for i = 1:npt
        tmp = albers(data_scale(i,1),data_scale(i,2));
        scale_xy(i,1) = tmp.x;
        scale_xy(i,2) = tmp.y;
    end

    % X scale

    scale_out = [];

    for i = 1:npt
        for j = i+1:npt
            tmp_xy  = scale_xy(i,1) - scale_xy(j,1);
            tmp_map = data_scale(i,3) - data_scale(j,3);
            scale_out = cat(1,scale_out,[tmp_xy,tmp_map]);
            %fprintf(1,'i: %g; j:%g; xscale:%g\n',i,j, tmp_map/tmp_xy);
        end
    end

    scale_x = scale_out(:,2)./scale_out(:,1);

    scale_x = mean(scale_x);

    % Y scale

    scale_out = [];

    for i = 1:npt
        for j = i+1:npt
            tmp_xy  = scale_xy(i,2) - scale_xy(j,2);
            tmp_map = data_scale(j,4) -  data_scale(i,4);
            scale_out = cat(1,scale_out,[tmp_xy,tmp_map]);
            %fprintf(1,'i: %g; j:%g; yscale:%g\n',i,j, tmp_map/tmp_xy);
        end
    end

    scale_y = abs(scale_out(:,2)./scale_out(:,1));

    scale_y = mean(scale_y);

    pos_xy  = int16(size(albers_xy));

    for i = 1:nloc
        xy = albers_xy(i,:);
        
        kh = albers_kh(i,:);
        
        pos_x = round(xy(1) * scale_x) + center_x;
        pos_y = - round(xy(2) * scale_y) + center_y;

        pos_x = min(pos_x,xmax);
        pos_y = min(pos_y,ymax);

        pos = [pos_x,pos_y];

        pos_xy(i,:) = pos;
    end

    % ----------------------------------------------------------------------
    % This part is slow.
    % ----------------------------------------------------------------------
    
    if (draw_map)
        fprintf(1,'Drawing location maps. This could take a while.\n');
        loc_map = uint8(zeros(xmax,ymax));

        ind_xy = sub2ind([xmax,ymax],pos_xy(:,1),pos_xy(:,2));

        loc_map(ind_xy) = uint8(1);

        % Load the base map

        map_path = base_map_path;

        basemap = imread(map_path);

        city_color = [255 0 0];

        % Label each city on the map

        map_dots    = basemap;
        map_dots(:) = uint8(0);
        map_codes   = map_dots;


        dot_shift = int16(dot_set_diff(16));

        for i = 1:nloc
            pos = pos_xy(i,:);

            [pos_x pos_y];
            % The position here needs to be inversed
            % xmax = 8829
            % ymax = 12669
            pos_x = pos(2);
            pos_y = pos(1);
            
            xmax_map = 8829;
            ymax_map = 12669;

            % Draw a dot
            dot_set = [dot_shift(:,1) + pos_x, dot_shift(:,2) + pos_y];    
            
            ndot = length(dot_set);
            
            for j = 1:ndot
                dot_set(j,1) = min(xmax_map,dot_set(j,1));
                dot_set(j,1) = max(0,dot_set(j,1));

                dot_set(j,2) = min(ymax_map,dot_set(j,2));
                dot_set(j,2) = max(0,dot_set(j,2));
            end
            
            for j = 1:ndot
                dot_tmp = dot_set(j,:);
                
                basemap(dot_tmp(1),dot_tmp(2),:) = uint8(city_color);

                map_dots(dot_tmp(1),dot_tmp(2),:) = uint8(city_color);
                map_codes(dot_tmp(1),dot_tmp(2),:) = uint8(city_color);
            end

            loc_code = id{i};

            basemap   = insertText(basemap,[pos_y pos_x],loc_code,...
                                   'fontsize',18,'boxcolor','black',...
                                   'textcolor','white');
            
            fprintf(1,'%30s: %4d/%4d\r','Finished location:',i,nloc);
        end

        % the dot and check maps
        imwrite(map_dots,[outpath '/loc_dots_' fname '.jpg']);

        % the check map
        imwrite(basemap,[outpath '/loc_map_' fname '.jpg']);

    
    end 
    
    


    % Output to the csv

    fname = [outpath '/coordinates_' fname '.csv'];

    fid = fopen(fname,'w');

    fprintf(fid,'%12s, %12s, %12s, %12s, %12s, %12s, %12s\n','id','long','lat','pos_x','pos_y','k','h');
    for i = 1:nloc
        fprintf(fid,'%12s, %12.4f, %12.4f, %12d, %12d, %12.10f, %12.10f\n',...
                id{i},long(i),lat(i),pos_xy(i,:),albers_kh(i,:));
    end

    fclose(fid);

end
