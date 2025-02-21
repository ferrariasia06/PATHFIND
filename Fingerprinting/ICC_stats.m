% This script processes Intraclass Correlation (ICC) values derived from functional connectivity (FC) matrices. 
% It performs statistical comparisons across different subject groups, applies Fisher's Z-transformation, 
% and visualizes the results using heatmaps of corrected p-values and effect sizes.  
% The analysis includes Kruskal-Wallis tests with post-hoc comparisons and further network-specific evaluations  
% for unimodal and transmodal networks.   
%  
% Code Authors: Asia Ferrari, Francesca Saviola  
% Version 1.0 (17 February, 2025)  

% Add utility functions to the MATLAB path
addpath(genpath(fullfile(project_dir, 'utilities', 'functions')));

%% Load the Data and Atlas
% Load the ICC (Intraclass Correlation Coefficient) data, adjusted by FS
load('ICC_ordered_Yeo_thr06.mat')

% Load the Glasser 60 parcels to Yeo 7-network atlas correspondence for functional connectivity analysis
load('yeo_RS7_Glasser360.mat')

% Define network labels (1 to 7) corresponding to the Yeo atlas
network_labels = 1:7; 

% Define group names and corresponding ICC data matrices
data_groups = {ICC_mat_AD_car_Yeo_thr06, ICC_mat_AD_nocar_Yeo_thr06, ...
               ICC_mat_CU_car_Yeo_thr06, ICC_mat_CU_nocar_Yeo_thr06};

num_groups = length(data_groups); % Number of groups
num_networks = length(network_labels); % Number of networks

%% Prepare Data for Kruskal-Wallis Test
% Initialize cell arrays to store network-wise data and corresponding group labels
network_data = cell(1, num_networks);
group_labels_network = cell(1, num_networks);

for n = 1:num_networks
    network_data{n} = [];
    group_labels_network{n} = [];
    
    for g = 1:num_groups
        % Extract ICC values for the current network
        network_mask = yeoROIs == n;
        network_values = data_groups{g}(network_mask, network_mask);
        
        % Apply Fisher's Z-transformation to stabilize variance
        z_transformed = 0.5 * log((1 + network_values) ./ (1 - network_values));
        
        % Store transformed data and corresponding group labels
        network_data{n} = [network_data{n}; z_transformed(:)];
        group_labels_network{n} = [group_labels_network{n}; g * ones(numel(z_transformed), 1)];
    end
end

%% Perform Kruskal-Wallis Test for Each Network
p_values = zeros(1, num_networks); % Store p-values
stats_networks = cell(1, num_networks); % Store statistical test results

for n = 1:num_networks
    % Kruskal-Wallis test to compare ICC values across groups
    [p_values(n), tbl, stats_networks{n}] = kruskalwallis(network_data{n}, group_labels_network{n}, 'off');
    disp(['Kruskal-Wallis test for Network ', num2str(n), ' - p-value: ', num2str(p_values(n))]);
    
    % Perform post-hoc pairwise comparisons
    c_networks{n} = multcompare(stats_networks{n}, 'Display', 'off');
    disp(['Post-hoc pairwise comparisons for Network ', num2str(n), ':']);
    disp(array2table(c_networks{n}, 'VariableNames', {'Group1', 'Group2', 'LowerCI', 'Difference', 'UpperCI', 'P-value'}));
end

%% Plot Heatmap of Corrected P-values and Effect Sizes
% Define colormap gradient from white to dark brown (#68412A)
start_color = [1, 1, 1];  % White
end_color = [0.572, 0.070, 0.164];  % RGB for #68412A

num_colors = 256; % Number of colors in colormap
map = zeros(num_colors, 3);

% Interpolate colors for gradient
for i = 1:3
    map(:, i) = linspace(start_color(i), end_color(i), num_colors);
end

% Define column labels for group comparisons
col_labels = {'AD-ɛ4+ > AD-ɛ4-', 'AD-ɛ4+ > CU-ɛ4+', 'AD-ɛ4+ > CU-ɛ4-', ...
              'AD-ɛ4- > CU-ɛ4+', 'AD-ɛ4- > CU-ɛ4-', 'CU-ɛ4+ > CU-ɛ4-'};

% Initialize matrices for p-values and effect sizes
p_values_matrix = zeros(num_networks, numel(col_labels));
effect_sizes_matrix = zeros(num_networks, numel(col_labels));

% Extract p-values and effect sizes for each network comparison
for n = 1:num_networks
    p_values_matrix(n, :) = c_networks{1,n}(:,6)';
    effect_sizes_matrix(n, :) = c_networks{1,n}(:,4)';
end

% Convert p-values to -log10 scale for visualization
pcolor_matrix = -log10(p_values_matrix);
imagesc(pcolor_matrix);
colormap(map);
colorbar;

% Customize axis labels and formatting
set(gca, 'XTick', 1:numel(col_labels), 'XTickLabel', col_labels, 'XTickLabelRotation', 45, 'FontSize', 12);
set(gca, 'YTick', 1:num_networks, 'YTickLabel', {'VIS', 'SMN', 'DAN', 'VAN', 'L', 'FPN', 'DMN'}, 'FontSize', 12);
ylabel('Networks');
title('Corrected P-values and Effect Sizes for Each Network', 'FontSize', 16);

% Overlay effect sizes and highlight significant results
for i = 1:size(pcolor_matrix, 1)
    for j = 1:size(pcolor_matrix, 2)
        effect_size_str = sprintf('%.2f', effect_sizes_matrix(i,j));
        if p_values_matrix(i,j) < 0.05
            text(j, i, effect_size_str, 'HorizontalAlignment', 'center', ...
                'VerticalAlignment', 'middle', 'Color', 'black', 'FontSize', 15, 'FontWeight', 'bold');
            rectangle('Position', [j-0.5, i-0.5, 1, 1], 'EdgeColor', [0.498, 0.498, 0.498], 'LineWidth', 2);
        else
            text(j, i, effect_size_str, 'HorizontalAlignment', 'center', ...
                'VerticalAlignment', 'middle', 'Color', 'black', 'FontSize', 15);
        end
    end
end

% Save the figure
saveas(gcf, 'Corrected_P_Values_Heatmap_7Networks.png');

%% Compute Average ICC for Unimodal and Transmodal Networks
% Define unimodal (sensorimotor-related) and transmodal (higher-order) networks
unimodal_labels = [1, 2, 3, 4]; % VIS, SMN, DAN, VAN
transmodal_labels = [5, 6, 7]; % L, FPN, DMN

% Compute network averages for each group
avg_data_groups = cell(1, num_groups);
for g = 1:num_groups
    avg_networks = compute_network_averages(data_groups{g}, yeoROIs);
    avg_data_groups{g} = 0.5 * log((1 + avg_networks) ./ (1 - avg_networks)); % Apply Fisher Z-transformation
end

%% Perform Kruskal-Wallis Test on Unimodal and Transmodal Networks
% This section calculates network-averaged Intraclass Correlation (ICC) values for unimodal and transmodal networks,  
% applies Fisher's Z-transformation, and performs a Kruskal-Wallis test to assess statistical differences across groups.  

% Compute network averages for each group and apply Fisher's Z-transformation  
avg_data_groups = cell(1, num_groups);
for g = 1:num_groups
    avg_networks = compute_network_averages(data_groups{g}, yeoROIs);
    avg_data_groups{g} = 0.5 * log((1 + avg_networks) ./ (1 - avg_networks)); % Fisher's Z-transformation
end

% Prepare data for Kruskal-Wallis test by extracting unimodal and transmodal values  
unimodal_data = [];
transmodal_data = [];
group_labels_unimodal = [];
group_labels_transmodal = [];

for g = 1:num_groups
    % Extract ICC values for unimodal and transmodal networks  
    unimodal_avg = avg_data_groups{g}(unimodal_labels, unimodal_labels);
    transmodal_avg = avg_data_groups{g}(transmodal_labels, transmodal_labels);
    
    % Flatten the matrices into column vectors  
    unimodal_data = [unimodal_data; unimodal_avg(:)];
    transmodal_data = [transmodal_data; transmodal_avg(:)];
    
    % Create corresponding group labels  
    group_labels_unimodal = [group_labels_unimodal; g * ones(numel(unimodal_avg), 1)];
    group_labels_transmodal = [group_labels_transmodal; g * ones(numel(transmodal_avg), 1)];
end

% Perform Kruskal-Wallis test to compare ICC values across groups  
[p_kw_unimodal, tbl_unimodal, stats_unimodal] = kruskalwallis(unimodal_data, group_labels_unimodal, 'off');
[p_kw_transmodal, tbl_transmodal, stats_transmodal] = kruskalwallis(transmodal_data, group_labels_transmodal, 'off');

% Display test results  
disp('Kruskal-Wallis test results (based on network averages):');
disp(['Unimodal networks - Chi-square: ', num2str(tbl_unimodal{2,5}), ', df: ', num2str(tbl_unimodal{2,3}), ...
      ', p-value: ', num2str(p_kw_unimodal)]);
disp(['Transmodal networks - Chi-square: ', num2str(tbl_transmodal{2,5}), ', df: ', num2str(tbl_transmodal{2,3}), ...
      ', p-value: ', num2str(p_kw_transmodal)]);

% Perform post-hoc pairwise comparisons for significant Kruskal-Wallis results  
disp('Post-hoc pairwise comparisons for unimodal networks:');
c_unimodal = multcompare(stats_unimodal, 'Display', 'off');
disp(array2table(c_unimodal, 'VariableNames', {'Group1', 'Group2', 'LowerCI', 'Difference', 'UpperCI', 'P-value'}));

% Identify and display significant differences in unimodal networks  
disp('Significant differences in unimodal networks:');
sig_unimodal = c_unimodal(c_unimodal(:,6) < 0.05, :);
for i = 1:size(sig_unimodal, 1)
    disp(['Group ', group_names{sig_unimodal(i,1)}, ' vs Group ', group_names{sig_unimodal(i,2)}, ' (p = ', num2str(sig_unimodal(i,6)), ')']);
end

% Repeat post-hoc analysis for transmodal networks  
disp('Post-hoc pairwise comparisons for transmodal networks:');
c_transmodal = multcompare(stats_transmodal, 'Display', 'off');
disp(array2table(c_transmodal, 'VariableNames', {'Group1', 'Group2', 'LowerCI', 'Difference', 'UpperCI', 'P-value'}));

% Identify and display significant differences in transmodal networks  
disp('Significant differences in transmodal networks:');
sig_transmodal = c_transmodal(c_transmodal(:,6) < 0.05, :);
for i = 1:size(sig_transmodal, 1)
    disp(['Group ', group_names{sig_transmodal(i,1)}, ' vs Group ', group_names{sig_transmodal(i,2)}, ' (p = ', num2str(sig_transmodal(i,6)), ')']);
end

% Compute mean ICC values (Fisher Z-transformed) for each group and network type  
mean_icc = zeros(num_groups, 2);
for g = 1:num_groups
    mean_icc(g, 1) = mean(avg_data_groups{g}(unimodal_labels, unimodal_labels), 'all');
    mean_icc(g, 2) = mean(avg_data_groups{g}(transmodal_labels, transmodal_labels), 'all');
end

% Display mean ICC values  
disp('Mean ICC values of network averages (Fisher Z-transformed):');
disp(array2table(mean_icc, 'RowNames', group_names, 'VariableNames', {'Unimodal', 'Transmodal'}));

%% Generate Heatmap of Corrected P-values and Effect Sizes  
% This section visualizes the results using a heatmap, where color intensity represents statistical significance (-log10 p-values),  
% and effect sizes are displayed within each cell.

% Define the start (white) and end colors (#68412A) for the custom colormap  
start_color = [1, 1, 1];  % White
end_color = [0.408, 0.255, 0.165];  % Brown (#68412A in RGB)

% Generate a colormap interpolating between the start and end colors  
num_colors = 256;
map = zeros(num_colors, 3);
for i = 1:3
    map(:, i) = linspace(start_color(i), end_color(i), num_colors);
end

% Define labels for group comparisons  
col_labels = {'AD-ɛ4+ > AD-ɛ4-', 'AD-ɛ4+ > CU-ɛ4+', 'AD-ɛ4+ > CU-ɛ4-', ...
              'AD-ɛ4- > CU-ɛ4+', 'AD-ɛ4- > CU-ɛ4-', 'CU-ɛ4+ > CU-ɛ4-'};

% Create a new figure for plotting  
figure('Position', [100, 100, 1200, 400]);

% Combine p-values and effect sizes for unimodal and transmodal networks  
p_values = [c_unimodal(:,6)'; c_transmodal(:,6)'];
effect_sizes = [c_unimodal(:,4)'; c_transmodal(:,4)'];

% Convert p-values to -log10 scale for visualization  
pcolor_matrix = -log10(p_values);
imagesc(pcolor_matrix);
colormap(map);  % Apply the custom colormap  

% Add a colorbar  
colorbar;

% Customize the plot axes  
set(gca, 'XTick', 1:numel(col_labels), 'XTickLabel', col_labels, 'XTickLabelRotation', 45, 'FontSize', 12);
set(gca, 'YTick', 1:2, 'YTickLabel', {'Unimodal', 'Transmodal'}, 'FontSize', 12);
ylabel('Network Type');

% Overlay effect sizes on the heatmap and highlight significant results  
for i = 1:size(pcolor_matrix, 1)
    for j = 1:size(pcolor_matrix, 2)
        effect_size_str = sprintf('%.2f', effect_sizes(i,j));
        if p_values(i,j) < 0.05
            text(j, i, effect_size_str, 'HorizontalAlignment', 'center', ...
                'VerticalAlignment', 'middle', 'Color', 'black', 'FontSize', 10, 'FontWeight', 'bold');
            rectangle('Position', [j-0.5, i-0.5, 1, 1], 'EdgeColor', 'red', 'LineWidth', 2);
        else
            text(j, i, effect_size_str, 'HorizontalAlignment', 'center', ...
                'VerticalAlignment', 'middle', 'Color', 'black', 'FontSize', 10);
        end
    end
end

% Adjust color limits based on the p-values  
max_value = max(pcolor_matrix(:));
caxis([0 max_value]);

% Add a title to the heatmap  
title('Corrected P-values and Effect Sizes for Unimodal and Transmodal Networks', 'FontSize', 16);

% Save the figure  
saveas(gcf, 'Corrected_P_Values_Heatmap_Unimodal_Transmodal_Flipped.png');

%% Function to Compute Network Averages  
% This helper function calculates the mean ICC values within each network, using Yeo 7-network parcellation.  
function avg_networks = compute_network_averages(data, yeoROIs)
    num_networks = max(yeoROIs);
    avg_networks = zeros(num_networks, num_networks);
    for i = 1:num_networks
        for j = 1:num_networks
            mask = (yeoROIs == i) & (yeoROIs == j)';
            avg_networks(i, j) = mean(data(mask));
        end
    end
end

