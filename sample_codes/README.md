# Sample Codes on Computing Pixel-to-Pixel Distance
The files in this folder provide examples of computing the pixel-to-pixel distance on any mode in a given year using MATLAB. ` See `main.m` for more details. 

## Input and Output

The user must provide the coordinates of the origins and destinations in the same format as in the file `input/sample_input.csv.`

Besides the file name containing the input coordinates, the user should also specify the `mode` and `year` variables inside `main.m`. The `mode` variable could be a string that takes one of the following values: `road,` `rail_good,` or `rail_pass.` The variable `year` should be an integer between 1994 and 2017. 

The output files are stored in the folder `output`. Each mode-year combination has a separate output file named as
`output/t_mat_INPUT_MODE_YEAR.csv,` in which `INPUT` is the input file name that contains the coordinates, and MODE and YEAR are self-explanatory.

Each row in the output file refers to an origin-destination pair. The rows are sorted in the same order as in the input file. The output file contains the following columns:
1. `id_ori`: the auto-generated id for each origin.
2. `long_ori`: the longitude of the origin location.
3. `lat_ori`: the latitude of the origin location.
4. `long_des`: the longitude of the destination location.
5. `lat_des`: the latitude of the destination location.
6. `time_cost`: the time required (in hours) to go from origin to location on the MODE in a given YEAR. 

 
 ## Fast Marching
In the file `compute_dist_fmm_2.m`, to implement the fast marching algorithm, we used the [Accurate Fast Marching](https://www.mathworks.com/matlabcentral/fileexchange/24531-accurate-fast-marching) package from the MATLAB File Exchange. Please refer to the help file there for instructions on how to install the package. From our experience, compiling the c-code with `mex` significantly improves performance. It takes around 120 seconds on a single core to compute the distance to all pixels on the map.  
