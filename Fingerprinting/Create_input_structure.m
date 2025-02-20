% The script loads precomputed Intrinsic Neural TImescale (INT; Raut et al., 2020) values and FC matrices 
% for each subject, handles missing data, and constructs group-specific FC matrices enriched by INT.
% The final FC matrices, adjusted by INT values, are saved for further analysis.
% The script supports multiple datasets (AD, ApoE, HC), ensuring consistency across different subject groups.
%
% Code Authors: Asia Ferrari, Francesca Saviola
% version 1.0 (17 February, 2025)

%% Clear workspace and set project directory
clear all; 
clc;
project_dir = fullfile(pwd, '..');

%% Process AD-ɛ4+ Group
load(fullfile(project_dir, 'Final_T0_AD', 'Output_intrinsic_timescale_AD', 'Subject_final_T0_fMRI.mat')); % Load INT values
AD_car = [5,6,9,10,11,15,17,20,22,25]; % Subject IDs for AD-ɛ4+
FC_INT_AD_car = cell(1, length(AD_car)); % Preallocate cell array

for idx = 1:length(AD_car)
    cur_sub = AD_car(idx);
    which_subject = sprintf('sub-%02d', cur_sub); % Format subject ID with leading zero if needed
    
    % Load FC matrices
    FC_test = load(fullfile(project_dir, 'Final_T0_AD', 'Glasser_half1_half2_FC', strcat(which_subject, '_Glasser_FC_half1_test.mat')));
    FC_retest = load(fullfile(project_dir, 'Final_T0_AD', 'Glasser_half1_half2_FC', strcat(which_subject, '_Glasser_FC_half2_retest.mat')));
    
    % Extract INT values and handle NaNs
    cur_INT = hwhms(:,:,cur_sub);
    cur_INT(isnan(cur_INT)) = 0;
    
    % Compute FC matrices weighted by INT values
    FC_static_conc = cat(3, FC_test .* cur_INT, FC_retest .* cur_INT);
    
    % Store in cell array
    FC_INT_AD_car{1, idx} = FC_static_conc;
end

save('FC_INT_AD_car.mat', "FC_INT_AD_car");

%% Process AD-ɛ4- Group
AD_nocar = [1,2,3,4,7,12,13,14,16,18,19,21,24,26,27,28]; % Subject IDs for AD-ɛ4-
FC_INT_AD_nocar = cell(1, length(AD_nocar));

for idx = 1:length(AD_nocar)
    cur_sub = AD_nocar(idx);
    which_subject = sprintf('sub-%02d', cur_sub);
    
    % Load FC matrices
    FC_test = load(fullfile(project_dir, 'Final_T0_AD', 'Glasser_half1_half2_FC', strcat(which_subject, '_Glasser_FC_half1_test.mat')));
    FC_retest = load(fullfile(project_dir, 'Final_T0_AD', 'Glasser_half1_half2_FC', strcat(which_subject, '_Glasser_FC_half2_retest.mat')));
    
    % Extract INT values and handle NaNs
    cur_INT = hwhms(:,:,cur_sub);
    cur_INT(isnan(cur_INT)) = 0;
    
    % Compute FC matrices weighted by INT values
    FC_static_conc = cat(3, FC_test .* cur_INT, FC_retest .* cur_INT);
    
    % Store in cell array
    FC_INT_AD_nocar{1, idx} = FC_static_conc;
end

save('FC_INT_AD_nocar.mat', "FC_INT_AD_nocar");

%% Process CU-ɛ4+ Group
load(fullfile(project_dir, 'Final_ApoE', 'Output_intrinsic_timescale_ApoE', 'Subject_final_ApoE.mat')); % Load INT values
FC_INT_CU_car = cell(1, length(Subject_final_ApoE));

for idx = 1:length(Subject_final_ApoE)
    cur_sub = CU_car(idx);
    which_subject = sprintf('sub-%02d', cur_sub);
    
    % Load FC matrices
    FC_test = load(fullfile(project_dir, 'Final_ApoE', 'Glasser_half1_half2_FC', strcat(which_subject, '_Glasser_FC_half1_test.mat')));
    FC_retest = load(fullfile(project_dir, 'Final_ApoE', 'Glasser_half1_half2_FC', strcat(which_subject, '_Glasser_FC_half2_retest.mat')));
    
    % Extract INT values and handle NaNs
    cur_INT = hwhms(:,:,cur_sub);
    cur_INT(isnan(cur_INT)) = 0;
    
    % Compute FC matrices weighted by INT values
    FC_static_conc = cat(3, FC_test .* cur_INT, FC_retest .* cur_INT);
    
    % Store in cell array
    FC_INT_CU_car{1, idx} = FC_static_conc;
end

save('FC_INT_CU_car.mat', "FC_INT_CU_car");

%% Process CU-ɛ4- Group
load(fullfile(project_dir, 'Final_HC', 'Output_intrinsic_timescale_HC', 'Subject_final_HC.mat')); % Load INT values
FC_INT_CU_nocar = cell(1, length(Subject_final_HC));

for idx = 1:length(Subject_final_HC)
    cur_sub = CU_car(idx);
    which_subject = sprintf('sub-%02d', cur_sub);
    
    % Load FC matrices
    FC_test = load(fullfile(project_dir, 'Final_HC', 'Glasser_half1_half2_FC', strcat(which_subject, '_Glasser_FC_half1_test.mat')));
    FC_retest = load(fullfile(project_dir, 'Final_HC', 'Glasser_half1_half2_FC', strcat(which_subject, '_Glasser_FC_half2_retest.mat')));
    
    % Extract INT values and handle NaNs
    cur_INT = hwhms(:,:,cur_sub);
    cur_INT(isnan(cur_INT)) = 0;
    
    % Compute FC matrices weighted by INT values
    FC_static_conc = cat(3, FC_test .* cur_INT, FC_retest .* cur_INT);
    
    % Store in cell array
    FC_INT_CU_nocar{1, idx} = FC_static_conc;
end

save('FC_INT_CU_nocar.mat', "FC_INT_CU_nocar");
