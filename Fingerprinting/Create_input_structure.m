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
project_dir = fullfile(pwd);
output_dir = 'input_matrices';
mkdir(fullfile(output_dir));


%% Process AD-ɛ4+ Group
load(fullfile(project_dir, 'data_AD', 'AD_INT.mat')); % Load INT values
AD_car = [5,6,9,10,11,15,17,20,22,25]; % Subject IDs for AD-ɛ4+
FC_INT_AD_car = cell(1, length(AD_car)); % Preallocate cell array

for idx = 1:length(AD_car)
    cur_sub = AD_car(idx);
    which_subject = sprintf('sub-%02d', cur_sub); % Format subject ID with leading zero if needed
    
    % Load FC matrices
    FC_test = load(fullfile(project_dir, 'data_AD', 'Glasser_half1_half2_FC', strcat(which_subject, '_Glasser_FC_half1_test.mat')));
    FC_test = double(FC_test.FC_1([3:381],[3:381]));
    FC_retest = load(fullfile(project_dir, 'data_AD', 'Glasser_half1_half2_FC', strcat(which_subject, '_Glasser_FC_half2_retest.mat')));
    FC_retest = double(FC_retest.FC_2([3:381],[3:381]));

    % Extract INT values and handle NaNs
    cur_INT = hwhms(:,:,cur_sub);
    cur_INT(isnan(cur_INT)) = 0;
    
    % Compute FC matrices weighted by INT values
    FC_static_conc = cat(3, FC_test .* cur_INT, FC_retest .* cur_INT);
    
    % Store in cell array
    FC_INT_AD_car{1, idx} = FC_static_conc;
end

save(fullfile(output_dir,'FC_INT_AD_car.mat'), "FC_INT_AD_car");

%% Process AD-ɛ4- Group
AD_nocar = [1,2,3,4,7,12,13,14,16,18,19,21,24,26,27,28]; % Subject IDs for AD-ɛ4-
FC_INT_AD_nocar = cell(1, length(AD_nocar));

for idx = 1:length(AD_nocar)
    cur_sub = AD_nocar(idx);
    which_subject = sprintf('sub-%02d', cur_sub); % Format subject ID with leading zero if needed
    
    % Load FC matrices
    FC_test = load(fullfile(project_dir, 'data_AD', 'Glasser_half1_half2_FC', strcat(which_subject, '_Glasser_FC_half1_test.mat')));
    FC_test = double(FC_test.FC_1([3:381],[3:381]));
    FC_retest = load(fullfile(project_dir, 'data_AD', 'Glasser_half1_half2_FC', strcat(which_subject, '_Glasser_FC_half2_retest.mat')));
    FC_retest = double(FC_retest.FC_2([3:381],[3:381]));

    % Extract INT values and handle NaNs
    cur_INT = hwhms(:,:,cur_sub);
    cur_INT(isnan(cur_INT)) = 0;
    
    % Compute FC matrices weighted by INT values
    FC_static_conc = cat(3, FC_test .* cur_INT, FC_retest .* cur_INT);
    
    % Store in cell array
    FC_INT_AD_nocar{1, idx} = FC_static_conc;
end

save(fullfile(output_dir,'FC_INT_AD_nocar.mat'), "FC_INT_AD_nocar");

%% Process CU-ɛ4+ Group
load(fullfile(project_dir, 'data_CU_car', 'CU_car_INT.mat')); % Load INT values
FC_INT_CU_car = cell(1, size(hwhms,3));
CU_car = [31:97];
counter = 1;

for idx = 1:size(CU_car,2)
    cur_sub = CU_car(idx);
    which_subject = sprintf('sub-%02d', cur_sub); % Format subject ID with leading zero if needed

    FC_test = fullfile(project_dir, 'data_CU_car', 'Glasser_half1_half2_FC', strcat(which_subject, '_Glasser_FC_half1_test.mat'));
    FC_retest = fullfile(project_dir, 'data_CU_car', 'Glasser_half1_half2_FC', strcat(which_subject, '_Glasser_FC_half2_retest.mat'));
    if isfile(FC_test) && isfile(FC_retest)
    
    % Load FC matrices
    FC_test = load(FC_test);
    FC_test = double(FC_test.FC_1([3:381],[3:381]));
    FC_retest = load(FC_retest);
    FC_retest = double(FC_retest.FC_2([3:381],[3:381]));

    % Extract INT values and handle NaNs
    cur_INT = hwhms(:,:,counter);
    cur_INT(isnan(cur_INT)) = 0;
    
    % Compute FC matrices weighted by INT values
    FC_static_conc = cat(3, FC_test .* cur_INT, FC_retest .* cur_INT);
    
    % Store in cell array
    FC_INT_CU_car{1, counter} = FC_static_conc;
    counter = counter+1;
    end
end

save(fullfile(output_dir,'FC_INT_CU_car.mat'), "FC_INT_CU_car");


%% Process CU-ɛ4- Group
load(fullfile(project_dir, 'data_CU_nocar', 'CU_nocar_INT.mat')); % Load INT values
FC_INT_CU_car = cell(1, size(hwhms,3));
CU_nocar = [29:78];
counter = 1;

for idx = 1:size(CU_nocar,2)
    cur_sub = CU_nocar(idx);
    which_subject = sprintf('sub-%02d', cur_sub); % Format subject ID with leading zero if needed

    FC_test = fullfile(project_dir, 'data_CU_nocar', 'Glasser_half1_half2_FC', strcat(which_subject, '_Glasser_FC_half1_test.mat'));
    FC_retest = fullfile(project_dir, 'data_CU_nocar', 'Glasser_half1_half2_FC', strcat(which_subject, '_Glasser_FC_half2_retest.mat'));
    if isfile(FC_test) && isfile(FC_retest)
    
    % Load FC matrices
    FC_test = load(FC_test);
    FC_test = double(FC_test.FC_1([3:381],[3:381]));
    FC_retest = load(FC_retest);
    FC_retest = double(FC_retest.FC_2([3:381],[3:381]));

    % Extract INT values and handle NaNs
    cur_INT = hwhms(:,:,counter);
    cur_INT(isnan(cur_INT)) = 0;
    
    % Compute FC matrices weighted by INT values
    FC_static_conc = cat(3, FC_test .* cur_INT, FC_retest .* cur_INT);
    
    % Store in cell array
    FC_INT_CU_nocar{1, counter} = FC_static_conc;
    counter = counter+1;
    end
end

save(fullfile(output_dir,'FC_INT_CU_nocar.mat'), "FC_INT_CU_nocar");

