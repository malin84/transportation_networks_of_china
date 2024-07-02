# Sample Codes on Computing Pixel-to-Pixel Distance
The files in this folder provide examples of computing the pixel-to-pixel distance on any mode in a given year using MATLAB. The user must provide the coordinates of the origins and destinations in the same format as in the file `input/sample_input.csv.` See `main.m` for more details. 



 
 ## Fast Marching
In the file `compute_dist_fmm_2.m`, to implement the fast marching algorithm, we used the [Accurate Fast Marching](https://www.mathworks.com/matlabcentral/fileexchange/24531-accurate-fast-marching) package from the MATLAB File Exchange. Please refer to the help file there for instructions on how to install the package. From our experience, compiling the c-code with `mex` significantly improves performance. It takes around 120 seconds on a single core to compute the distance to all pixels on the map.  
