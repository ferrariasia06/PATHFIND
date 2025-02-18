% Example batch script for Siemens 3T MEGA-PRESS data with accompanying water references and structural images
% Remember to check GannetPreInitialise.m has the appropriate settings for your data
%
% Code Authors: Asia Ferrari, Francesca Saviola
% version 1.0 (17 February, 2025)

% Clear the workspace
clc;
clear all;

% Set the variables
data_dir = '/path/to/your/data'; % Generic directory, replace with actual path when running the script
nsubj = 22;
metab_dir = cell(1, nsubj); % Initialize as cell arrays
water_dir = cell(1, nsubj);
anat_dir = cell(1, nsubj);

% Create file names starting from subj-01
for sub = 1:nsubj
    % Generate new subject folder names (subj-01, subj-02, ...)
    subj_name = sprintf('subj-%02d', sub);
    
    % New file names for metab, water, and anat (using generic naming starting from subj-01)
    metab_sub = sprintf('%s_metab.IMA', subj_name);
    water_sub = sprintf('%s_water.IMA', subj_name);
    anat_sub = sprintf('%s_anat.nii', subj_name);
    
    % Construct the full paths (replace with actual structure directories when sharing)
    subj_dir = fullfile(data_dir, subj_name);
    metab_dir{sub} = fullfile(subj_dir, 'metab', metab_sub); 
    water_dir{sub} = fullfile(subj_dir, 'wr', water_sub);
    anat_dir{sub} = fullfile(subj_dir, 'anat', anat_sub);
    
    % Debugging: Check the types and contents of the variables
    disp(['metab_dir{sub}: ', metab_dir{sub}]); % Display the full path
    disp(['water_dir{sub}: ', water_dir{sub}]); % Display the full path
    disp(['Type of metab_dir{sub}: ', class(metab_dir{sub})]); % Check the type
    disp(['Type of water_dir{sub}: ', class(water_dir{sub})]); % Check the type
    
    % Load the MRS data (assuming the files are placed in the correct paths)
    MRS = GannetLoad(cellstr(metab_dir{sub}), cellstr(water_dir{sub})); % Convert to char if needed
    
    % Fit the MRS data
    MRS = GannetFit(MRS);
    
    % Co-register the MRS data with anatomical images
    MRS = GannetCoRegister(MRS, cellstr(anat_dir{sub}));
    
    % Segment the MRS data
    MRS = GannetSegment(MRS);
    
    % Quantify the MRS data
    MRS = GannetQuantify(MRS);
    
    % Save the MRS structure for the current subject
    save_filename = fullfile(subj_dir, sprintf('MRS_%s.mat', subj_name));
    save(save_filename, 'MRS'); % Save the MRS structure
    MRS_allsubj{sub} = MRS;
end

% Save the MRS structure for all subjects
save_filename = fullfile(data_dir, 'MRS_allsubj.mat');
save(save_filename, 'MRS'); % Save the MRS structure for all subjects
