% This script calculates average time series for different brain regions (parcels)
% defined by the pre-selected atlas, and computes Functional Connectivity (FC) matrices.
% The script starts from zipped (nii.gz) or unzipped (nii) MRI/fMRI data;
% it handles various atlases (e.g., Glasser, Schaefer 100, Schaefer 200)
% and saves the results (volume per volume parcellation and/or FC matrices)
% in specified output directories for further analysis.
%
% Code Authors: Asia Ferrari, Barbara Cassone, Francesca Saviola
% version 1.0 (7 February, 2025)

clc;
close all;
clear;

%% Set analysis preferences
selected_atlas = 1; % 1 for Glasser, 2 for Schaefer 100, 3 for Schaefer 200
fsl_flag = 1; % 1 to use FSL for parcellation instead of Matlab
matrix_flag = 1; % 1 to save volume per volume parcellation (if fsl_flag = 1, matrix_flag = 1 by default)

%% Define root directories for the project and datasets
project_dir = pwd; % Root project directory
dataset_dir = fullfile(project_dir, 'dataset'); % Directory containing the fMRI data
data_files = dir(fullfile(dataset_dir, '*bold_rest*nii*')); % List of fMRI file names

% Add utility functions to the MATLAB path
addpath(genpath(fullfile(project_dir, 'utilities', 'functions')));

%% Define the atlas name based on the selected flag
if selected_atlas == 1
    atlas_name = 'Glasser'; % Glasser atlas
    atlas_filename = 'Glasser_Subcortical_2mm_MNI.nii.gz';
elseif selected_atlas == 2
    atlas_name = 'Schaefer100'; % Schaefer 100 atlas
    atlas_filename = 'Schaefer100_Subcortical_2mm_MNI.nii.gz';
elseif selected_atlas == 3
    atlas_name = 'Schaefer200'; % Schaefer 200 atlas
    atlas_filename = 'Schaefer200_Subcortical_2mm_MNI_reslice_RS.nii';
end

% Load brain atlas based on the selected atlas flag
atlas_dir = fullfile(project_dir, 'utilities', 'atlas'); % Atlas directory

% Load the selected atlas into the workspace
atlas_file = load_nii(fullfile(atlas_dir, atlas_filename));
atlas_data = double(atlas_file.img); % Get atlas data as a double matrix

%% Create output directory for results, including the atlas name
output_dir = fullfile(project_dir, 'results', strcat('FC_static_', atlas_name));
mkdir(output_dir); % Ensure the output directory for the selected atlas exists
folder1 = fullfile(output_dir, strcat(atlas_name, '_parcellation'));
if fsl_flag == 1 || matrix_flag == 1
    mkdir(folder1); % Create directory for saving time series
end
folder2 = fullfile(output_dir, strcat(atlas_name, '_half1_half2_FC'));
mkdir(folder2); % Create directory for FC matrices (time series split in two)
folder3 = fullfile(output_dir, strcat(atlas_name, '_FC'));
mkdir(folder3); % Create directory for FC matrices

% Initialise a variable to randomly label the fMRI time series halves as test or retest
% (Svaldi et al., 2021, doi: 10.1002/hbm.25448)
n_sample = length(data_files);
n_half_sample = round(n_sample/2);
tmp = [ones(1,n_half_sample) zeros(1,n_sample-n_half_sample)];
random_vec = tmp(randperm(n_sample));

%% Loop over each subject in the dataset
for subject_idx = 1:n_sample % Loop over all subjects
    
    % Get the subject name from the list of files
    subject_name = data_files(subject_idx).name;
    fMRI_filename = strcat(subject_name);
        
    % Use FSL for automatic parcellation
    if fsl_flag == 1
        avg_time_series_filename = strcat('sub', num2str(subject_idx), '_', atlas_name, '_parcellation');
        fslcmd = ['fslmeants -i ', char(fullfile(dataset_dir, fMRI_filename)), ' -o ', fullfile(folder1, strcat(avg_time_series_filename,'.csv')), ' --label=', fullfile(atlas_dir, atlas_filename)];
        system(fslcmd);
        
        % Load FSL output (volume per volume parcellation)
        avg_time_series = readtable(fullfile(folder1, strcat(avg_time_series_filename,'.csv')));
        atlas_parcels = unique(atlas_data); % Get unique regions in the atlas
        atlas_parcels = atlas_parcels(2:end); % Remove background (0)
        avg_time_series = avg_time_series{:,atlas_parcels};
        
    % Otherwise, start the parcellation using Matlab commands only
    else
        % Load the subject's resting-state fMRI data
        fMRI_load = load_nii(fullfile(dataset_dir, fMRI_filename)); % Load the fMRI data
        fMRI_data = double(fMRI_load.img); % Convert to double precision for processing
        
        % Initialize a matrix for the average time series of the parcels
        region_values = unique(atlas_data); % Get the region values from the atlas
        region_values = region_values(2:end); % Remove background (0)
        avg_time_series = zeros(size(fMRI_data, 4), length(region_values)); % Initialize time series matrix
        
        % Calculate the average time series for each ROI
        for timepoint_idx = 1:size(avg_time_series, 1)  % Iterate over timepoints
            for region_idx = 1:length(region_values)  % Iterate over regions (parcels)
                region_indices = find(atlas_data == region_values(region_idx)); % Get indices for current region
                if ~isempty(region_indices)
                    avg_time_series(timepoint_idx, region_idx) = mean(fMRI_data(region_indices + (timepoint_idx - 1) * numel(atlas_data)));
                end
            end
        end
        
        % Save the computed average time series for the subject
        if matrix_flag == 1
            avg_time_series_filename = strcat('sub', num2str(subject_idx), '_', atlas_name, '_parcellation');
            save(fullfile(folder1, avg_time_series_filename), 'avg_time_series');
        end
    end
    
    % Compute FC matrices for halves of the time series and the full data
    half_timepoints = round(size(avg_time_series, 1) / 2); % Split the time series into two halves
    first_half = avg_time_series(1:half_timepoints, :); % First half of the time series
    second_half = avg_time_series(half_timepoints + 1:end, :); % Second half of the time series
    FC_first_half = corrcoef(first_half); % Compute correlation coefficient for first half
    FC_second_half = corrcoef(second_half); % Compute correlation coefficient for second half
    FC_all = corrcoef(avg_time_series); % Compute correlation coefficient for entire time series
    
    % Save the FC matrices
    if random_vec(subject_idx) == 0
        FC_filename_1 = strcat('sub', num2str(subject_idx), '_', atlas_name, '_FC_half1_test');
        FC_filename_2 = strcat('sub', num2str(subject_idx), '_', atlas_name, '_FC_half2_retest');
    else
        FC_filename_1 = strcat('sub', num2str(subject_idx), '_', atlas_name, '_FC_half1_retest');
        FC_filename_2 = strcat('sub', num2str(subject_idx), '_', atlas_name, '_FC_half2_test');
    end
    FC_filename_all = strcat('sub', num2str(subject_idx), '_', atlas_name, '_FC');
    
    save(fullfile(folder2, FC_filename_1), 'FC_first_half'); % Save first half FC
    save(fullfile(folder2, FC_filename_2), 'FC_second_half'); % Save second half FC
    save(fullfile(folder3, FC_filename_all), 'FC_all'); % Save full FC matrix
end