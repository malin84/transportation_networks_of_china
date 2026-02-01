function dist_output = compute_city_city_dijkstra(time_mat, ind_list)
    % time_mat  : [ny, nx] per-pixel "time" value
    % ind_list  : linear indices (via sub2ind) of pixels where cities are located
    %
    % dist_output : ncity × ncity, dist_output(i,j) is the shortest travel time
    %               from city i to city j

    [ny, nx] = size(time_mat);
    npix    = ny * nx;

    % Valid pixels (finite time values)
    valid = isfinite(time_mat);

    % Linear index grid
    idxGrid = reshape(1:npix, ny, nx);

    % ===============================
    % 1) 4-neighborhood (up/down/left/right)
    % ===============================

    % Horizontal: left–right
    mask_h = valid(:,1:end-1) & valid(:,2:end);
    i_h    = idxGrid(:,1:end-1);
    j_h    = idxGrid(:,2:end);
    i_h    = i_h(mask_h);
    j_h    = j_h(mask_h);

    t_h = 0.5 * (time_mat(:,1:end-1) + time_mat(:,2:end));   % average time of two pixels
    t_h = t_h(mask_h);
    d_h = 1;                                                 % grid distance = 1 (orthogonal move)
    w_h = t_h * d_h;                                         % edge weight

    % Vertical: up–down
    mask_v = valid(1:end-1,:) & valid(2:end,:);
    i_v    = idxGrid(1:end-1,:);
    j_v    = idxGrid(2:end,:);
    i_v    = i_v(mask_v);
    j_v    = j_v(mask_v);

    t_v = 0.5 * (time_mat(1:end-1,:) + time_mat(2:end,:));
    t_v = t_v(mask_v);
    d_v = 1;
    w_v = t_v * d_v;

    % ===============================
    % 2) Diagonal directions (8-neighborhood)
    % ===============================

    % Down-right
    mask_dr = valid(1:end-1,1:end-1) & valid(2:end,2:end);
    i_dr    = idxGrid(1:end-1,1:end-1);
    j_dr    = idxGrid(2:end,2:end);
    i_dr    = i_dr(mask_dr);
    j_dr    = j_dr(mask_dr);

    t_dr = 0.5 * (time_mat(1:end-1,1:end-1) + time_mat(2:end,2:end));
    t_dr = t_dr(mask_dr);
    d_dr = sqrt(2);                                         % diagonal grid distance
    w_dr = t_dr * d_dr;

    % Down-left
    mask_dl = valid(1:end-1,2:end) & valid(2:end,1:end-1);
    i_dl    = idxGrid(1:end-1,2:end);
    j_dl    = idxGrid(2:end,1:end-1);
    i_dl    = i_dl(mask_dl);
    j_dl    = j_dl(mask_dl);

    t_dl = 0.5 * (time_mat(1:end-1,2:end) + time_mat(2:end,1:end-1));
    t_dl = t_dl(mask_dl);
    d_dl = sqrt(2);
    w_dl = t_dl * d_dl;

    % ===============================
    % 3) Assemble edges (undirected: add both directions)
    % ===============================
    ii = [i_h(:); j_h(:);  i_v(:); j_v(:);  i_dr(:); j_dr(:);  i_dl(:); j_dl(:)];
    jj = [j_h(:); i_h(:);  j_v(:); i_v(:);  j_dr(:); i_dr(:);  j_dl(:); i_dl(:)];
    ww = [w_h(:); w_h(:);  w_v(:); w_v(:);  w_dr(:); w_dr(:);  w_dl(:); w_dl(:)];

    valid_edges = isfinite(ww);
    ii = ii(valid_edges);
    jj = jj(valid_edges);
    ww = ww(valid_edges);

    % ===============================
    % 4) Build graph and use distances for multi-source shortest paths
    % ===============================
    G = graph(ii, jj, ww, npix);   % undirected, weighted, positive weights → Dijkstra

    % City indices ind_list are used both as sources and targets
    ind_u = unique(ind_list, 'stable');  
    D_u   = distances(G, ind_u, ind_u); 
    [~,ix]= ismember(ind_list, ind_u);  
    dist_output = D_u(ix, ix);         
end
