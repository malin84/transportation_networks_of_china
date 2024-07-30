% This script will compile all the C files of the registration methods in the package Accurate Fast Marching
% 
% This is the updated version that added the option "-compatibleArrayDims" 
% so the files could be compiled correctly in newer versions of Matlab.
% Please use this file to replace "compile_c_files.m" in the original package, 
% and call this file to recompile the source codes. 
% Incorrectly compiled source code will deliver negative values when computing distance.

cd('functions');
files=dir('*.c');
clear msfm2d
mex -compatibleArrayDims msfm2d.c
clear msfm3d
mex -compatibleArrayDims msfm3d.c
cd('..');

cd('shortestpath');
clear rk4
mex -compatibleArrayDims rk4.c
cd('..')
