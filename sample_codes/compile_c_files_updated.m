% This script will compile all the C files of the registration methods
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
