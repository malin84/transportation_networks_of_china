% The loader file that calls all the codes in sequence

clear;

addpath('codes');

year_list   = [2007:2009];
ncores      = 8;
outpath     = 'output';
input_fname = 'sample_input.csv';

% Drawing the location maps could be slow.
draw_loc    = true;

loc_1(input_fname,outpath,draw_loc);


for iyear = 1:length(year_list)
    year      = num2str(year_list(iyear));

    % compute_dist_fmm_2(file_type,year,outpath,ncores);
    % export_dist_3(file_type,year,outpath);

end

