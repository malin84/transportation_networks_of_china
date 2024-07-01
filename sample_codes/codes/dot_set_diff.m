function output = dot_set_diff(radi)
% Define the set of a dot around a given ini_pt, with a range of x
% pts. This only computes the difference matrix once, and then we
% apply this matrix directly to the point


output_x = zeros(radi*2 +1);
output_y = zeros(radi*2 +1);

for ix = 1:radi * 2 + 1
    output_x(ix,:) = ix - radi - 1;
end

output_y = output_x';

output   = [output_x(:) output_y(:)];

dist = sqrt(sum(output.^2,2));

ind = dist >= radi;

output(ind,:) = [];
