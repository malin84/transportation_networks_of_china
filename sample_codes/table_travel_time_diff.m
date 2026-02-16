% Compute differences in prefecture-to-prefecture travel time between
% consecutive years and between selected year pairs, then export
% summary-statistics tables in LaTeX format.

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
    stats_min    = min(diff_consec, [], 1);
    stats_max    = max(diff_consec, [], 1);

    fprintf(fid, '%% ====== %s — Consecutive-Year Differences ======\n', ...
            mode_label{imode});
    fprintf(fid, '\\begin{table}[htbp]\n');
    fprintf(fid, '\\centering\n');
    fprintf(fid, '\\caption{Summary Statistics of Consecutive-Year Travel Time Differences — %s}\n', ...
            mode_label{imode});
    fprintf(fid, '\\label{tab:consec_%s}\n', mode);
    fprintf(fid, '\\small\n');
    fprintf(fid, '\\begin{tabular}{lrrrrrrr}\n');
    fprintf(fid, '\\hline\n');
    fprintf(fid, 'Period & Mean & Median & SD & P25 & P75 & Min & Max \\\\\n');
    fprintf(fid, '\\hline\n');

    for j = 1:(nYears-1)
        label = sprintf('%d--%d', years(j), years(j+1));
        fprintf(fid, '%s & %.3f & %.3f & %.3f & %.3f & %.3f & %.3f & %.3f \\\\\n', ...
                label, stats_mean(j), stats_med(j), stats_sd(j), ...
                stats_p25(j), stats_p75(j), stats_min(j), stats_max(j));
    end

    fprintf(fid, '\\hline\n');
    fprintf(fid, '\\end{tabular}\n');
    fprintf(fid, '\\end{table}\n\n');

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
    fprintf(fid, '\\begin{tabular}{lrrrrrrr}\n');
    fprintf(fid, '\\hline\n');
    fprintf(fid, 'Period & Mean & Median & SD & P25 & P75 & Min & Max \\\\\n');
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
        fprintf(fid, '%s & %.3f & %.3f & %.3f & %.3f & %.3f & %.3f & %.3f \\\\\n', ...
                label, mean(d), median(d), std(d), ...
                prctile(d,25), prctile(d,75), min(d), max(d));
    end

    fprintf(fid, '\\hline\n');
    fprintf(fid, '\\end{tabular}\n');
    fprintf(fid, '\\end{table}\n\n');
end

fclose(fid);
fprintf('Saved to %s\n', fullfile(outpath, 'travel_time_diff_tables.tex'));
