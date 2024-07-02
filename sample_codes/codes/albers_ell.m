function output = albers_ell(long,lat)

% Albers projection, assuming elliptical earth.

lambda_0 = pi*110/180;
psi_0 = pi*35/180;
psi_1 = pi*25/180;
psi_2 = pi*47/180;

a  = 6378206.4;
e  = 0.0822719;
e2 = 0.00676866; 

a  = 6378245;
iv = 298.3;
e2 = sqrt(iv/a);
e  = sqrt(e2);

% Also known as lambda
long = pi*long/180;

% Also as psi
lat  = pi*lat/180;
psi  = lat;

% M
m    = cos(psi)/sqrt(1 - e2 * (sin(psi))^2);
m_1  = cos(psi_1)/sqrt(1 - e2 * (sin(psi_1))^2);
m_2  = cos(psi_2)/sqrt(1 - e2 * (sin(psi_2))^2);

% q

q  = sin(psi)/ (1-e2 *(sin(psi))^2);
q  = q - (1/(2*e))*log((1 - e * sin(psi))/(1+e*sin(psi)));
q  = (1-e2)*abs(q);


q_0  = sin(psi_0)/ (1-e2 *(sin(psi_0))^2);
q_0  = q_0 - (1/(2*e))*log((1 - e * sin(psi_0))/(1+e*sin(psi_0)));
q_0  = (1-e2)*abs(q_0);

q_1  = sin(psi_1)/ (1-e2 *(sin(psi_1))^2);
q_1  = q_1 - (1/(2*e))*log((1 - e * sin(psi_1))/(1+e*sin(psi_1)));
q_1  = (1-e2)*abs(q_1);

q_2  = sin(psi_2)/ (1-e2 *(sin(psi_2))^2);
q_2  = q_2 - (1/(2*e))*log((1 - e * sin(psi_2))/(1+e*sin(psi_2)));
q_2  = (1-e2)*abs(q_2);


n   = (m_1^2 - m_2^2)/(q_2-q_1);
c   = m_1^2 + n * q_1;

theta = n * (long  - lambda_0);

rho = a * sqrt(c - n * q)/n;
rho_0 = a * sqrt(c - n * q_0)/n;


% Scale along the meridian, applies to Y
h = sqrt(c - n * q)/m;

% Scale along the parallels, applies to X;
k = 1/h;

output.x = rho * sin(theta);
output.y = rho_0 - rho * cos(theta);

output.h = h;
output.k = k;
