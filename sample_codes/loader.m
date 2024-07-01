% The loader file that calls all the codes in sequence

clear;


year_list = [2007:2016];

file_type = 'supplier';
ncores    = 24;
outpath   = 'output';


for iyear = 1:length(year_list)
    year      = num2str(year_list(iyear));

    loc_1(file_type,year,outpath);
    compute_dist_fmm_2(file_type,year,outpath,ncores);
    export_dist_3(file_type,year,outpath);

end

