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

## Dijkstra

In [`compute_dist_dijkstra_0.m`], travel time along the road network is computed using a multi-source Dijkstra algorithm. Because multi-source Dijkstra does not allow repeated source/target points, we remove duplicates in the code to avoid redundant computation; this has no effect on the results.
