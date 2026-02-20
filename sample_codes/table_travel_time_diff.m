% Compute differences in prefecture-to-prefecture travel time between
% consecutive years and between selected year pairs, then export
% summary-statistics tables and a detailed positive-change table
% as a fully compilable LaTeX document.

clear;

% Path to the pref_pair folder
pref_pair_path = fullfile('..', 'pref_pair');

% Modes to process
mode_list  = {'road', 'rail_pass', 'rail_good'};
mode_label = {'Road', 'Rail (Passenger)', 'Rail (Freight)'};

% Year pairs for which to compute the difference (end - start)
year_pairs = [1994 2024; 1994 2010; 2010 2024];

% Output folder
outpath = 'output';
if ~exist(outpath, 'dir'), mkdir(outpath); end

% ---------------------------------------------------------------
% Open a single LaTeX file for all tables
% ---------------------------------------------------------------
fid = fopen(fullfile(outpath, 'travel_time_diff_tables.tex'), 'w');

% LaTeX preamble
fprintf(fid, '\\documentclass[11pt]{article}\n');
fprintf(fid, '\\usepackage[margin=1in]{geometry}\n');
fprintf(fid, '\\usepackage{booktabs}\n');
fprintf(fid, '\\usepackage{caption}\n');
fprintf(fid, '\\usepackage{longtable}\n');
fprintf(fid, '\n');
fprintf(fid, '\\title{Summary Statistics of Prefecture-to-Prefecture Travel Time Differences}\n');
fprintf(fid, '\\author{}\n');
fprintf(fid, '\\date{}\n');
fprintf(fid, '\n');
fprintf(fid, '\\begin{document}\n');
fprintf(fid, '\\maketitle\n\n');

% Collect all positive-change records across modes for the detail table
% Each row: {mode_label, period_label, origin, destination, time_prev, time_curr}
pos_records = {};

for imode = 1:length(mode_list)
    mode = mode_list{imode};

    % Read the CSV file
    fname = fullfile(pref_pair_path, ...
                     ['time_cost_prefecture_pair_' mode '.csv']);
    T = readtable(fname);

    % Extract year columns
    all_cols  = T.Properties.VariableNames;
    is_year   = startsWith(all_cols, 'year_');
    year_cols = all_cols(is_year);
    years     = cellfun(@(s) str2double(s(6:end)), year_cols);
    time_mat  = T{:, is_year};   % rows = OD pairs, cols = years

    % Origin and destination codes
    origins      = T.origin;
    destinations = T.destination;

    % ==============================================================
    % Table 1: Consecutive-year differences
    % ==============================================================
    nYears = length(years);
    diff_consec = time_mat(:, 2:end) - time_mat(:, 1:end-1);

    % Summary statistics for each consecutive-year gap
    stats_mean   = mean(diff_consec, 1);
    stats_med    = median(diff_consec, 1);
    stats_sd     = std(diff_consec, 0, 1);
    stats_p25    = prctile(diff_consec, 25, 1);
    stats_p75    = prctile(diff_consec, 75, 1);
    stats_p95    = prctile(diff_consec, 95, 1);
    stats_p99    = prctile(diff_consec, 99, 1);
    stats_min    = min(diff_consec, [], 1);
    stats_max    = max(diff_consec, [], 1);
    stats_npos   = sum(diff_consec > 0, 1);

    fprintf(fid, '%% ====== %s — Consecutive-Year Differences ======\n', ...
            mode_label{imode});
    fprintf(fid, '\\begin{table}[htbp]\n');
    fprintf(fid, '\\centering\n');
    fprintf(fid, '\\caption{Summary Statistics of Consecutive-Year Travel Time Differences — %s}\n', ...
            mode_label{imode});
    fprintf(fid, '\\label{tab:consec_%s}\n', mode);
    fprintf(fid, '\\small\n');
    fprintf(fid, '\\begin{tabular}{lrrrrrrrrrr}\n');
    fprintf(fid, '\\hline\n');
    fprintf(fid, 'Period & Mean & Median & SD & P25 & P75 & P95 & P99 & Min & Max & N(+) \\\\\n');
    fprintf(fid, '\\hline\n');

    for j = 1:(nYears-1)
        label = sprintf('%d--%d', years(j), years(j+1));
        fprintf(fid, '%s & %.3f & %.3f & %.3f & %.3f & %.3f & %.3f & %.3f & %.3f & %.3f & %d \\\\\n', ...
                label, stats_mean(j), stats_med(j), stats_sd(j), ...
                stats_p25(j), stats_p75(j), stats_p95(j), stats_p99(j), ...
                stats_min(j), stats_max(j), stats_npos(j));
    end

    fprintf(fid, '\\hline\n');
    fprintf(fid, '\\end{tabular}\n');
    fprintf(fid, '\\end{table}\n\n');

    % Collect positive changes from consecutive years
    for j = 1:(nYears-1)
        pos_mask = diff_consec(:, j) > 0;
        idx_pos  = find(pos_mask);
        for k = 1:length(idx_pos)
            r = idx_pos(k);
            pos_records{end+1, 1} = mode_label{imode};
            pos_records{end, 2}   = sprintf('%d--%d', years(j), years(j+1));
            pos_records{end, 3}   = origins(r);
            pos_records{end, 4}   = destinations(r);
            pos_records{end, 5}   = time_mat(r, j);
            pos_records{end, 6}   = time_mat(r, j+1);
        end
    end

    % ==============================================================
    % Table 2: Selected year-pair differences
    % ==============================================================
    fprintf(fid, '%% ====== %s — Selected Year-Pair Differences ======\n', ...
            mode_label{imode});
    fprintf(fid, '\\begin{table}[htbp]\n');
    fprintf(fid, '\\centering\n');
    fprintf(fid, '\\caption{Summary Statistics of Travel Time Differences Between Selected Years — %s}\n', ...
            mode_label{imode});
    fprintf(fid, '\\label{tab:pair_%s}\n', mode);
    fprintf(fid, '\\small\n');
    fprintf(fid, '\\begin{tabular}{lrrrrrrrrrr}\n');
    fprintf(fid, '\\hline\n');
    fprintf(fid, 'Period & Mean & Median & SD & P25 & P75 & P95 & P99 & Min & Max & N(+) \\\\\n');
    fprintf(fid, '\\hline\n');

    for ip = 1:size(year_pairs, 1)
        y0 = year_pairs(ip, 1);
        y1 = year_pairs(ip, 2);

        idx0 = find(years == y0, 1);
        idx1 = find(years == y1, 1);
        if isempty(idx0) || isempty(idx1)
            warning('Year pair %d--%d not found for mode %s.', y0, y1, mode);
            continue;
        end

        d = time_mat(:, idx1) - time_mat(:, idx0);

        label = sprintf('%d--%d', y0, y1);
        fprintf(fid, '%s & %.3f & %.3f & %.3f & %.3f & %.3f & %.3f & %.3f & %.3f & %.3f & %d \\\\\n', ...
                label, mean(d), median(d), std(d), ...
                prctile(d,25), prctile(d,75), prctile(d,95), prctile(d,99), ...
                min(d), max(d), sum(d > 0));
    end

    fprintf(fid, '\\hline\n');
    fprintf(fid, '\\end{tabular}\n');
    fprintf(fid, '\\end{table}\n\n');
end

% ==============================================================
% Table 3: Detailed list of all positive consecutive-year changes
% ==============================================================
fprintf(fid, '\\clearpage\n');
fprintf(fid, '\\section*{Detailed Positive Consecutive-Year Changes}\n\n');

if isempty(pos_records)
    fprintf(fid, 'No positive consecutive-year changes were found.\n\n');
else
    fprintf(fid, 'The following table lists every prefecture pair whose travel time\n');
    fprintf(fid, 'increased between consecutive years. Total records: %d.\n\n', ...
            size(pos_records, 1));

    fprintf(fid, '\\begin{longtable}{llrrrrr}\n');
    fprintf(fid, '\\hline\n');
    fprintf(fid, 'Mode & Period & Origin & Destination & Time (prev) & Time (curr) & Change \\\\\n');
    fprintf(fid, '\\hline\n');
    fprintf(fid, '\\endfirsthead\n');
    fprintf(fid, '\\hline\n');
    fprintf(fid, 'Mode & Period & Origin & Destination & Time (prev) & Time (curr) & Change \\\\\n');
    fprintf(fid, '\\hline\n');
    fprintf(fid, '\\endhead\n');
    fprintf(fid, '\\hline\n');
    fprintf(fid, '\\endfoot\n');

    for i = 1:size(pos_records, 1)
        m_label  = pos_records{i, 1};
        p_label  = pos_records{i, 2};
        orig     = pos_records{i, 3};
        dest     = pos_records{i, 4};
        t_prev   = pos_records{i, 5};
        t_curr   = pos_records{i, 6};
        change   = t_curr - t_prev;
        fprintf(fid, '%s & %s & %d & %d & %.4f & %.4f & %.4f \\\\\n', ...
                m_label, p_label, orig, dest, t_prev, t_curr, change);
    end

    fprintf(fid, '\\hline\n');
    fprintf(fid, '\\end{longtable}\n\n');
end

% Close the document
fprintf(fid, '\\end{document}\n');

fclose(fid);
fprintf('Saved to %s\n', fullfile(outpath, 'travel_time_diff_tables.tex'));
