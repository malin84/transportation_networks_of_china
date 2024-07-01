% Check the distance results at the village-city level, instead of the village level.

clear;

clear;

run define_figure_spec.m

year_list   = [1994:2017];

dist_list   = {'rail_hsr_combined','nationalroad_highway_combined'};

vol_list    = {'pass'};

tab_fig_path = ['tab_fig/'];
% Load the city-level info.

% The index of 279 cities in the 291 list.
ind_279  = csvread('input/dzcode_mapping_291_279.csv',1,0);

% The basic info of cities, used as weights.
cityinfo = table2struct(readtable('input/cityinfo_279.csv'));

ncity    = length(cityinfo);
for i = 1:ncity
    cityinfo(i).ones = 1;
end

% The basic info of the villages

villageinfo = table2struct(readtable('input/data_location.csv'));

nvillage    = length(villageinfo);

% top4_list
top4_list = [1101 3101 4401 4403];
ind_top4  = false(length(cityinfo),1);
for i     = 1:length(top4_list)
    pos   = find([cityinfo.dzcode] == top4_list(i));
    ind_top4(pos) = true;
end

ori_list = [1 2 3];

des_list = [1 55 66 186 222 278];

% Load the data
for idist = 1:length(dist_list)
    for ivol = 1:length(vol_list)

        dist_all = [];
        for iyear = 1:length(year_list)
            year       = year_list(iyear);
            dist       = dist_list{idist};
            fname_in   = ['output/' num2str(year) '_' dist  '_dist_village_fmm.mat'];
            load(fname_in);
            vol   = vol_list{ivol};

            % The rest works on dist_tmp: a 450-by-291 matrix.
            cmd   = ['dist_tmp = dist_output_' vol ';'];
            eval(cmd);

            % Reduce to 450-by-279
            dist_tmp = dist_tmp(:,find(ind_279));

            dist_all = cat(3,dist_all,dist_tmp);
        end
    
        
        for iori = 1:length(ori_list)
            pos_ori  = ori_list(iori);
            dist_mat = transpose(squeeze(dist_all(pos_ori,des_list,:)));

            
            for ides = 1:length(des_list)
                dist_mat(:,ides) = dist_mat(:,ides) / dist_mat(1,ides);
            end
            
            plot(year_list, dist_mat);
            grid on;
            xlabel('Year','fontsize',fontsize,'interpreter','latex');
            ylabel('Distance, Normalized','fontsize',fontsize,'interpreter','latex');

            set(gca,'fontsize',fontsize_s,'xlim',[year_list(1),2020]);

            for i = 1:length(des_list)
                pos = des_list(i);
                lab = num2str(cityinfo(pos).dzcode);
                text(2017,dist_mat(end,i),lab,'fontsize',8,'interpreter','latex');
            end

            fname = [tab_fig_path 'dist_ori_v' num2str(pos_ori,'%03d') '_' dist '_' vol];
            print(fname,printer);

            
            
        end
    end
end
