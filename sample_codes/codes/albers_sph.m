function output = albers_sph(long,lat)

% Albers projection, assuming spherical earth.

lambda_0 = pi*110/180;
psi_0 = pi*35/180;
psi_1 = pi*25/180;
psi_2 = pi*47/180;

% Also as lambda
long = pi*long/180;

% Also as psi
lat  = pi*lat/180;


n     = 0.5 * (sin(psi_1) + sin(psi_2));

theta = n * (long  - lambda_0);

c  = (cos(psi_1))^2 + 2 * n * sin(psi_1);

rho = (1/n) * (sqrt(c - 2*n*sin(lat)));

rho_0 = (1/n) * (sqrt(c - 2*n*sin(psi_0)));

% Scale along the meridian, applies to Y
h = cos(lat) / sqrt(c - 2 * n * sin(lat));

% Scale along the parallels, applies to X;
k = 1/h;

output.x = rho * sin(theta);
output.y = rho_0 - rho * cos(theta);

output.h = h;
output.k = k;
