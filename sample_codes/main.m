% The main loader file that calls all the codes in sequence

clear;

addpath('codes');

% Required inputs
year_list   = [1994 2017];
mode_list   = {'road','rail_pass','rail_good'};

% The input file that contains the coordinates of the origins and
% destinations.
input_fname = 'sample_input.csv';

% The output folder
outpath     = 'output';


% --------------------------------------------------
% Optional inputs
% --------------------------------------------------
% number of cores to use. Each core could use up to 6GB of memory. 
ncores      = 2;

% The speed to traverse empty pixels, in the unit of km/h.
empty_speed = 10;

% Drawing the location maps could be slow.
draw_loc    = true;


% First step, transform the coordinates into positions on the raster
% map.
loc_1(input_fname,outpath,draw_loc);

% Second step, compute distance using FMM.
for iyear = 1:length(year_list)
    for imode = 1:length(mode_list)
        year      = year_list(iyear);
        mode      = mode_list{imode};
        
        fprintf(1,'==================================================\n')
        fprintf(1,'%30s:%30s\n','Input Coordinates',input_fname);
        fprintf(1,'%30s:%30d\n','Year',year);
        fprintf(1,'%30s:%30s\n','Mode',mode);
        fprintf(1,'==================================================\n')

        compute_dist_fmm_2(input_fname,mode,year,outpath,ncores,empty_speed);
    end
end

% Ending matters
poolobj = gcp('nocreate');
delete(poolobj);
