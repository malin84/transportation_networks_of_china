% --------------------------------------------------
% This block of codes define the map dimensions
% --------------------------------------------------

xmax = 12669;
xmin = 1;
ymax = 8829;
ymin = 1;
% The mode of the compute distance map. The map is too large to store
% and load every time, and the variations across pixels are small.
distance_pixel = 0.509651956221723;

% Some parameters used to recompute the distance at the pixel level,
% if needed: the scales and center of the projection.
scale_x  = 1.258151200840857e+04;
scale_y  = 1.244998253976599e+04;

center_x = 6955;
center_y = 4817;
