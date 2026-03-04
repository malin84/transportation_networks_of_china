% Plot median, 25th percentile, and 75th percentile of
% prefecture-to-prefecture travel time over years, for each mode.

clear;

% Path to the pref_pair folder
pref_pair_path = fullfile('..', 'pref_pair');

% Modes to plot
mode_list  = {'road', 'rail_pass', 'rail_good'};
mode_label = {'Road', 'Rail (Passenger)', 'Rail (Freight)'};

figure('Position', [100, 100, 1200, 400]);

for imode = 1:length(mode_list)
    mode = mode_list{imode};

    % Read the CSV file
    fname = fullfile(pref_pair_path, ['time_cost_prefecture_pair_' mode '.csv']);
    T = readtable(fname);

    % Extract year columns (all columns starting with 'year_')
    year_cols = T.Properties.VariableNames;
    is_year   = startsWith(year_cols, 'year_');
    year_cols = year_cols(is_year);

    % Parse years from column names
    years = cellfun(@(s) str2double(s(6:end)), year_cols);

    % Extract the travel time matrix (rows = OD pairs, cols = years)
    time_mat = T{:, is_year};

    % Compute percentiles across all OD pairs for each year
    p25    = prctile(time_mat, 25, 1);
    p50    = prctile(time_mat, 50, 1);
    p75    = prctile(time_mat, 75, 1);

    % Plot
    subplot(1, 3, imode);
    hold on;

    % Shaded band for 25th-75th percentile
    fill([years, fliplr(years)], [p25, fliplr(p75)], ...
         [0.8 0.85 1], 'EdgeColor', 'none', 'FaceAlpha', 0.5);

    plot(years, p50, '-b',  'LineWidth', 2);
    plot(years, p25, '--b', 'LineWidth', 1);
    plot(years, p75, '--b', 'LineWidth', 1);

    hold off;

    xlabel('Year');
    ylabel('Travel Time (hours)');
    title(mode_label{imode});
    legend('25th-75th pctl', 'Median', '25th pctl', '75th pctl', ...
           'Location', 'best');
    grid on;
    xlim([min(years) max(years)]);
end

sgtitle('Prefecture-to-Prefecture Travel Time Over Time');

% Save
print('output/travel_time_trend.png', '-dpng', '-r200');
fprintf('Saved to output/travel_time_trend.png\n');
