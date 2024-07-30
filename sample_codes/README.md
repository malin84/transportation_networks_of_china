# Sample Codes on Computing Pixel-to-Pixel Distance
The files in this folder provide examples of computing the pixel-to-pixel distance on any mode in a given year using MATLAB. 

See [`main.m`](main.m) for more details. 

If you run into **negative values** in the distance, please see the [note](https://github.com/malin84/transportation_networks_of_china/tree/main/sample_codes#fast-marching) below on how to compile the Acurate Fast Marching Toolbox correctly.

## Input and Output

### Main Input
The user must provide the coordinates of the origins and destinations in the same format as in the file [`input/sample_input.csv`](input/sample_input.csv). Each row of the input file should contain an **origin-destination pair**.

In addition to the file name containing the input coordinates, the user should also specify the `mode` and `year` variables inside [`main.m`](main.m). The `mode` is a string variable that takes one of the following values: `road,` `rail_good,` or `rail_pass.` The variable `year` should be an integer between 1994 and 2017. 

The user should define the paths in `define_path.m` so that `pixel_data_path` points to the folder that stores the pixel-level dataset (for example, [`../pixel_info/`](../pixel_info/)) and `base_map_path` points to the scanned map with 8k-by-12k resolution (for example, [`input/base_8k.jpg`](input/base_8k.jpg)).

### Main Output
The main output files are stored in the folder [`output`](output/). Each mode-year combination has a separate output file named `output/t_mat_INPUT_MODE_YEAR.csv,` in which `INPUT` is the input file name that contains the coordinates, and MODE and YEAR are self-explanatory.

Each row in the output file refers to an **origin-destination pair**. The rows are sorted in the same order as in the input file. The output file contains the following columns:
1. `id_ori`: the auto-generated id for each origin.
2. `long_ori`: the longitude of the origin location.
3. `lat_ori`: the latitude of the origin location.
4. `long_des`: the longitude of the destination location.
5. `lat_des`: the latitude of the destination location.
6. `time_cost`: the time required (in hours) to go from origin to location on the MODE in a given YEAR. 

### Optional Input
The following options could be set inside [`main.m`](main.m):

1. `ncores` (positive integer): the number of cores to use in parallel when computing the distances. Fast Marching is memory-consuming with our map size. The rule of thumb is that **each core could use up to 6GB of memory**.
2. `empty_speed` (positive number): the speed when traversing an empty pixel without any infrastructure in the unit of km/h.
3. `draw_loc` (logical): whether to produce maps that show the locations of the origin and destinations. The files are stored in the output folder specified in `outpath`. See the next section for details of the maps.

### Auxiliary Output

The following auxiliary output files will be stored in the [`output`](output/) folder:

1. `coordinates_INPUT_des(ori).csv`: the coordinates and the map positions of each destination (origin) in the INPUT file. This file is always produced by calling [`loc_1.m`](codes/loc_1.m).
2. `loc_dots_INPUT_des(ori).jpg`: a simple map that shows all the destinations (origins) without any reference. This file will only be produced when `draw_loc = true` in [`main.m`](main.m).
3. `loc_map_INPUT_des(ori).jpg`: a map that overlays the simple map onto a published map of China. This map is for quality control purposes. This file will only be produced when `draw_loc = true` in [`main.m`](main.m).
 
 ## Fast Marching
In the file [`compute_dist_fmm_2.m`](codes/compute_dist_fmm_2.m), to implement the fast marching algorithm, we used the [Accurate Fast Marching](https://www.mathworks.com/matlabcentral/fileexchange/24531-accurate-fast-marching) package from the MATLAB File Exchange. Please refer to the help file on Mathworks for instructions on installing the package. From our experience, compiling the c-code with `mex` significantly improves performance. 

### Negative Distances in Output
The AFM package is an old package published in 2011, so you might run into dimension compatibility issues if you compile the package using newer versions of MATLAB. An incorrectly compiled package will deliver a negative distance as the output. In this case, please place the file `compile_c_files_updated.m` included in this package in the same folder as the `compile_c_files.m` file from the original AFM package and run the updated file to re-compile the source codes. The updated compilation file added the option "-compatibleArrayDims" to the `mex` command to ensure compatibility.  

## Tips on Improving Performance

FMM is computationally heavy to implement. From one origin, computing the distances to all pixels on the map takes around 120 seconds on a single core with compiled code. Here are some tips on improving the codes' performance.

1. **Reduce the number of unique origins**. Accurate Fast Marching automatically computes distances to all pixels on a map, conditional on an **origin**. Therefore, the computational time scales linearly with the number of origins. The number of destinations does not meaningfully affect computational time. Therefore, always use the coordinates with fewer unique locations as the origin. For example, if you are computing the distances from 10,000 firms to 300 destination cities, you should use cities as the origin, not the firms. Using cities as origin calls FMM 300 times, and using firms as origin requires 10,000 calls.
2. **Compile the Accurate Fast Marching Package**. Before using the FMM package, follow the instructions on Mathworks to compile it with `mex.` Compilation reduces computational time by about one order of magnitude.
3. **Parallel as much as possible if memory permits**. The sample code calls FMM in parallel to improve performance. However, be careful about memory usage. Due to the size of the map, each core requires roughly 6GB of memory. Too many parallel workers can easily crash MATLAB.      
