function output = circle_set(xpt,ypt,radi)
% Define the set of a dot around a given ini_pt, with a range of x
% pts. Different from dot_set.m, this routine only draws the
% boundary of the circle, not entirely filling it.


output = [];

for ix = -radi:radi
    for iy = -radi:radi
        xtmp = xpt + ix;
        ytmp = ypt + iy;

        dist = norm([xtmp ytmp] - [xpt ypt]);
        
        if dist < radi & dist >= radi - 1
            output = cat(1,output,[xtmp ytmp]);
        end
    end
end


