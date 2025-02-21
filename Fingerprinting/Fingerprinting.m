% This script calculates identifiability metrics by correlating test and retest FC data. Key computations include success rates, 
% Iself, Iothers, Idiff, and Intraclass Correlation Coefficients (ICC). Statistical analysis using the Kruskal-Wallis test and 
% post-hoc comparisons is performed to evaluate group differences. 
%
% Code Authors: Asia Ferrari, Francesca Saviola
% version 1.0 (17 February, 2025)

%% Initialize environment
% Clear all variables, close all figures, and clear command window for a fresh start.
clearvars
clc
close all;

% Add utility functions to the MATLAB path
addpath(genpath(fullfile(project_dir, 'utilities', 'functions')));

%% Load AD_car (functional connectivity) resting-state data
% Load sample data for Alzheimer's disease (AD) with car condition.
% The data consists of a cell array where each cell represents a subject.
% Each subject's data is a 3D matrix: brain regions x brain regions x test/re-test.
load('FC_INT_AD_car.mat');
data_test_AD_car = FC_INT_AD_car;

% Extract number of subjects and regions of interest (ROI)
n_subj_AD_car = size(data_test_AD_car,2);
n_roi = size(data_test_AD_car{1},1);

%% Convert matrices into arrays for further processing
% Create an upper triangular mask to extract unique connectivity values.
mask_ut = triu(true(n_roi,n_roi),1);
[AD_cars_test, AD_cars_retest] = f_load_mat(data_test_AD_car, mask_ut);
mask_diag = logical(eye(size(AD_cars_test,1))); % Create a diagonal mask

%% Compute identifiability matrix
% Correlate test and retest data to measure individual identifiability.
Ident_mat_AD_car = corr(AD_cars_test', AD_cars_retest');
Ident_mat_1_AD_car = Ident_mat_AD_car;

%% Compute success rate
% Success rate: Count how many times an individual's self-identifiability score 
% is greater than other individuals' scores within the same test-retest scenario.
sr1_AD_car = zeros(1,n_subj_AD_car);
for i = 1:length(Ident_mat_AD_car)
    sr1_AD_car(i) = sum(Ident_mat_AD_car(i,i) > Ident_mat_AD_car(i,:)) + ...
                    sum(Ident_mat_AD_car(i,i) > Ident_mat_AD_car(:,i));
end
sr_indiv_AD_car = sr1_AD_car * 100 / (length(Ident_mat_AD_car) * 2 - 2);
sr_mean_AD_car = mean(sr_indiv_AD_car,2);

%% Compute self and others' identifiability parameters
Iself_AD_car = zeros(1,n_subj_AD_car); % Self-identifiability
Iothers_AD_car = zeros(1,n_subj_AD_car); % Others-identifiability
Idiff_indiv_AD_car = zeros(1,n_subj_AD_car); % Difference between self and others
Idiff_AD_car = nanmean(Ident_mat_AD_car(mask_diag)) - nanmean(Ident_mat_AD_car(~mask_diag));
for s = 1:n_subj_AD_car
    Iself_AD_car(s) = Ident_mat_AD_car(s,s);
    Ident_mat_AD_car(s,s) = nan;
    Iothers_AD_car(s) = 0.5 * (nanmean(Ident_mat_AD_car(s,:)) + nanmean(Ident_mat_AD_car(:,s))');
    Idiff_indiv_AD_car(s) = Iself_AD_car(s) - Iothers_AD_car(s);
end

%% Plot identifiability matrix
figure;
subplot(1,2,1);
imagesc(Ident_mat_1_AD_car);
axis square;
set(gca, 'XTick', [], 'YTick', []);
colorbar;
caxis([0.3 0.9]);
title('Identifiability Matrix AD_car group');
xlabel('Test AD_car');
ylabel('Retest AD_car');

%% Compute Intraclass Correlation Coefficient (ICC)
% ICC highlights which regions contribute most to identifiability.
ICC_threshold = 0.68;
disp('Computing ICC..');

% Compute ICC values for test and retest data
ICC_struct_AD_car = f_ICC_edgewise(AD_cars_test(:,:)', AD_cars_retest(:,:)');

% Initialize ICC matrix
ICC_mat_AD_car = zeros(n_roi, n_roi);

% Fill upper and lower triangle of the matrix
ICC_mat_AD_car(mask_ut) = ICC_struct_AD_car;
ICC_mat_AD_car = triu(ICC_mat_AD_car) + triu(ICC_mat_AD_car, 1)';

% Plot ICC matrix
subplot(1,2,2);
imagesc(ICC_mat_AD_car);
axis square;
set(gca, 'XTick', [], 'YTick', []);
colorbar;
title('ICC Matrix AD_car group');
xlabel('360 roi');
ylabel('360 roi');

%% Load AD_nocar (functional connectivity) resting-state data
% Load sample data for Alzheimer's disease (AD) with car condition.
% The data consists of a cell array where each cell represents a subject.
% Each subject's data is a 3D matrix: brain regions x brain regions x test/re-test.
load('FC_INT_AD_nocar.mat');
data_test_AD_nocar = FC_INT_AD_nocar;

% Extract number of subjects and regions of interest (ROI)
n_subj_AD_nocar = size(data_test_AD_nocar,2);
n_roi = size(data_test_AD_nocar{1},1);

%% Convert matrices into arrays for further processing
% Create an upper triangular mask to extract unique connectivity values.
mask_ut = triu(true(n_roi,n_roi),1);
[AD_nocars_test, AD_nocars_retest] = f_load_mat(data_test_AD_nocar, mask_ut);
mask_diag = logical(eye(size(AD_nocars_test,1))); % Create a diagonal mask

%% Compute identifiability matrix
% Correlate test and retest data to measure individual identifiability.
Ident_mat_AD_nocar = corr(AD_nocars_test', AD_nocars_retest');
Ident_mat_1_AD_nocar = Ident_mat_AD_nocar;

%% Compute success rate
% Success rate: Count how many times an individual's self-identifiability score 
% is greater than other individuals' scores within the same test-retest scenario.
sr1_AD_nocar = zeros(1,n_subj_AD_nocar);
for i = 1:length(Ident_mat_AD_nocar)
    sr1_AD_nocar(i) = sum(Ident_mat_AD_nocar(i,i) > Ident_mat_AD_nocar(i,:)) + ...
                    sum(Ident_mat_AD_nocar(i,i) > Ident_mat_AD_nocar(:,i));
end
sr_indiv_AD_nocar = sr1_AD_nocar * 100 / (length(Ident_mat_AD_nocar) * 2 - 2);
sr_mean_AD_nocar = mean(sr_indiv_AD_nocar,2);

%% Compute self and others' identifiability parameters
Iself_AD_nocar = zeros(1,n_subj_AD_nocar); % Self-identifiability
Iothers_AD_nocar = zeros(1,n_subj_AD_nocar); % Others-identifiability
Idiff_indiv_AD_nocar = zeros(1,n_subj_AD_nocar); % Difference between self and others
Idiff_AD_nocar = nanmean(Ident_mat_AD_nocar(mask_diag)) - nanmean(Ident_mat_AD_nocar(~mask_diag));
for s = 1:n_subj_AD_nocar
    Iself_AD_nocar(s) = Ident_mat_AD_nocar(s,s);
    Ident_mat_AD_nocar(s,s) = nan;
    Iothers_AD_nocar(s) = 0.5 * (nanmean(Ident_mat_AD_nocar(s,:)) + nanmean(Ident_mat_AD_nocar(:,s))');
    Idiff_indiv_AD_nocar(s) = Iself_AD_nocar(s) - Iothers_AD_nocar(s);
end

%% Plot identifiability matrix
figure;
subplot(1,2,1);
imagesc(Ident_mat_1_AD_nocar);
axis square;
set(gca, 'XTick', [], 'YTick', []);
colorbar;
caxis([0.3 0.9]);
title('Identifiability Matrix AD_nocar group');
xlabel('Test AD_nocar');
ylabel('Retest AD_nocar');

%% Compute Intraclass Correlation Coefficient (ICC)
% ICC highlights which regions contribute most to identifiability.
ICC_threshold = 0.68;
disp('Computing ICC..');

% Compute ICC values for test and retest data
ICC_struct_AD_nocar = f_ICC_edgewise(AD_nocars_test(:,:)', AD_nocars_retest(:,:)');

% Initialize ICC matrix
ICC_mat_AD_nocar = zeros(n_roi, n_roi);

% Fill upper and lower triangle of the matrix
ICC_mat_AD_nocar(mask_ut) = ICC_struct_AD_nocar;
ICC_mat_AD_nocar = triu(ICC_mat_AD_nocar) + triu(ICC_mat_AD_nocar, 1)';

% Plot ICC matrix
subplot(1,2,2);
imagesc(ICC_mat_AD_nocar);
axis square;
set(gca, 'XTick', [], 'YTick', []);
colorbar;
title('ICC Matrix AD_nocar group');
xlabel('360 roi');
ylabel('360 roi');

%% Load CU_car (functional connectivity) resting-state data
% Load sample data for Alzheimer's disease (AD) with car condition.
% The data consists of a cell array where each cell represents a subject.
% Each subject's data is a 3D matrix: brain regions x brain regions x test/re-test.
load('FC_INT_CU_car.mat');
data_test_CU_car = FC_INT_CU_car;

% Extract number of subjects and regions of interest (ROI)
n_subj_CU_car = size(data_test_CU_car,2);
n_roi = size(data_test_CU_car{1},1);

%% Convert matrices into arrays for further processing
% Create an upper triangular mask to extract unique connectivity values.
mask_ut = triu(true(n_roi,n_roi),1);
[CU_cars_test, CU_cars_retest] = f_load_mat(data_test_CU_car, mask_ut);
mask_diag = logical(eye(size(CU_cars_test,1))); % Create a diagonal mask

%% Compute identifiability matrix
% Correlate test and retest data to measure individual identifiability.
Ident_mat_CU_car = corr(CU_cars_test', CU_cars_retest');
Ident_mat_1_CU_car = Ident_mat_CU_car;

%% Compute success rate
% Success rate: Count how many times an individual's self-identifiability score 
% is greater than other individuals' scores within the same test-retest scenario.
sr1_CU_car = zeros(1,n_subj_CU_car);
for i = 1:length(Ident_mat_CU_car)
    sr1_CU_car(i) = sum(Ident_mat_CU_car(i,i) > Ident_mat_CU_car(i,:)) + ...
                    sum(Ident_mat_CU_car(i,i) > Ident_mat_CU_car(:,i));
end
sr_indiv_CU_car = sr1_CU_car * 100 / (length(Ident_mat_CU_car) * 2 - 2);
sr_mean_CU_car = mean(sr_indiv_CU_car,2);

%% Compute self and others' identifiability parameters
Iself_CU_car = zeros(1,n_subj_CU_car); % Self-identifiability
Iothers_CU_car = zeros(1,n_subj_CU_car); % Others-identifiability
Idiff_indiv_CU_car = zeros(1,n_subj_CU_car); % Difference between self and others
Idiff_CU_car = nanmean(Ident_mat_CU_car(mask_diag)) - nanmean(Ident_mat_CU_car(~mask_diag));
for s = 1:n_subj_CU_car
    Iself_CU_car(s) = Ident_mat_CU_car(s,s);
    Ident_mat_CU_car(s,s) = nan;
    Iothers_CU_car(s) = 0.5 * (nanmean(Ident_mat_CU_car(s,:)) + nanmean(Ident_mat_CU_car(:,s))');
    Idiff_indiv_CU_car(s) = Iself_CU_car(s) - Iothers_CU_car(s);
end

%% Plot identifiability matrix
figure;
subplot(1,2,1);
imagesc(Ident_mat_1_CU_car);
axis square;
set(gca, 'XTick', [], 'YTick', []);
colorbar;
caxis([0.3 0.9]);
title('Identifiability Matrix CU_car group');
xlabel('Test CU_car');
ylabel('Retest CU_car');

%% Compute Intraclass Correlation Coefficient (ICC)
% ICC highlights which regions contribute most to identifiability.
ICC_threshold = 0.68;
disp('Computing ICC..');

% Compute ICC values for test and retest data
ICC_struct_CU_car = f_ICC_edgewise(CU_cars_test(:,:)', CU_cars_retest(:,:)');

% Initialize ICC matrix
ICC_mat_CU_car = zeros(n_roi, n_roi);

% Fill upper and lower triangle of the matrix
ICC_mat_CU_car(mask_ut) = ICC_struct_CU_car;
ICC_mat_CU_car = triu(ICC_mat_CU_car) + triu(ICC_mat_CU_car, 1)';

% Plot ICC matrix
subplot(1,2,2);
imagesc(ICC_mat_CU_car);
axis square;
set(gca, 'XTick', [], 'YTick', []);
colorbar;
title('ICC Matrix CU_car group');
xlabel('360 roi');
ylabel('360 roi');

%% Load CU_nocar (functional connectivity) resting-state data
% Load sample data for Alzheimer's disease (AD) with car condition.
% The data consists of a cell array where each cell represents a subject.
% Each subject's data is a 3D matrix: brain regions x brain regions x test/re-test.
load('FC_INT_CU_nocar.mat');
data_test_CU_nocar = FC_INT_CU_nocar;

% Extract number of subjects and regions of interest (ROI)
n_subj_CU_nocar = size(data_test_CU_nocar,2);
n_roi = size(data_test_CU_nocar{1},1);

%% Convert matrices into arrays for further processing
% Create an upper triangular mask to extract unique connectivity values.
mask_ut = triu(true(n_roi,n_roi),1);
[CU_nocars_test, CU_nocars_retest] = f_load_mat(data_test_CU_nocar, mask_ut);
mask_diag = logical(eye(size(CU_nocars_test,1))); % Create a diagonal mask

%% Compute identifiability matrix
% Correlate test and retest data to measure individual identifiability.
Ident_mat_CU_nocar = corr(CU_nocars_test', CU_nocars_retest');
Ident_mat_1_CU_nocar = Ident_mat_CU_nocar;

%% Compute success rate
% Success rate: Count how many times an individual's self-identifiability score 
% is greater than other individuals' scores within the same test-retest scenario.
sr1_CU_nocar = zeros(1,n_subj_CU_nocar);
for i = 1:length(Ident_mat_CU_nocar)
    sr1_CU_nocar(i) = sum(Ident_mat_CU_nocar(i,i) > Ident_mat_CU_nocar(i,:)) + ...
                    sum(Ident_mat_CU_nocar(i,i) > Ident_mat_CU_nocar(:,i));
end
sr_indiv_CU_nocar = sr1_CU_nocar * 100 / (length(Ident_mat_CU_nocar) * 2 - 2);
sr_mean_CU_nocar = mean(sr_indiv_CU_nocar,2);

%% Compute self and others' identifiability parameters
Iself_CU_nocar = zeros(1,n_subj_CU_nocar); % Self-identifiability
Iothers_CU_nocar = zeros(1,n_subj_CU_nocar); % Others-identifiability
Idiff_indiv_CU_nocar = zeros(1,n_subj_CU_nocar); % Difference between self and others
Idiff_CU_nocar = nanmean(Ident_mat_CU_nocar(mask_diag)) - nanmean(Ident_mat_CU_nocar(~mask_diag));
for s = 1:n_subj_CU_nocar
    Iself_CU_nocar(s) = Ident_mat_CU_nocar(s,s);
    Ident_mat_CU_nocar(s,s) = nan;
    Iothers_CU_nocar(s) = 0.5 * (nanmean(Ident_mat_CU_nocar(s,:)) + nanmean(Ident_mat_CU_nocar(:,s))');
    Idiff_indiv_CU_nocar(s) = Iself_CU_nocar(s) - Iothers_CU_nocar(s);
end

%% Plot identifiability matrix
figure;
subplot(1,2,1);
imagesc(Ident_mat_1_CU_nocar);
axis square;
set(gca, 'XTick', [], 'YTick', []);
colorbar;
caxis([0.3 0.9]);
title('Identifiability Matrix CU_nocar group');
xlabel('Test CU_nocar');
ylabel('Retest CU_nocar');

%% Compute Intraclass Correlation Coefficient (ICC)
% ICC highlights which regions contribute most to identifiability.
ICC_threshold = 0.68;
disp('Computing ICC..');

% Compute ICC values for test and retest data
ICC_struct_CU_nocar = f_ICC_edgewise(CU_nocars_test(:,:)', CU_nocars_retest(:,:)');

% Initialize ICC matrix
ICC_mat_CU_nocar = zeros(n_roi, n_roi);

% Fill upper and lower triangle of the matrix
ICC_mat_CU_nocar(mask_ut) = ICC_struct_CU_nocar;
ICC_mat_CU_nocar = triu(ICC_mat_CU_nocar) + triu(ICC_mat_CU_nocar, 1)';

% Plot ICC matrix
subplot(1,2,2);
imagesc(ICC_mat_CU_nocar);
axis square;
set(gca, 'XTick', [], 'YTick', []);
colorbar;
title('ICC Matrix CU_nocar group');
xlabel('360 roi');
ylabel('360 roi');

%% Statistical Analysis using Kruskal-Wallis Test

% Combine all individual difference (Idiff) data into a single array
total_Idiff = [Idiff_indiv_AD_car, Idiff_indiv_AD_nocar, Idiff_indiv_ApoE, Idiff_indiv_HC];

% Define group labels for each dataset
% Group 1: AD with car (10 subjects)
% Group 2: AD without car (16 subjects)
% Group 3: ApoE (35 subjects)
% Group 4: Healthy Controls (34 subjects)
group = [repmat(1, 1, 10), repmat(2, 1, 16), repmat(3, 1, 35), repmat(4, 1, 34)];

% Perform Kruskal-Wallis test to check for statistical differences between groups
[p, tbl, stats] = kruskalwallis(total_Idiff, group);

% Perform multiple comparisons (post-hoc test) to identify significant group differences
multcompare(stats);

% ---- Repeat the same process for Iself variable ----

% Combine all self-related data (Iself) into a single array
total_Iself = [Iself_AD_car, Iself_AD_nocar, Iself_ApoE, Iself_HC];

% Define the same group labels as above
group = [repmat(1, 1, 10), repmat(2, 1, 16), repmat(3, 1, 35), repmat(4, 1, 34)];

% Perform Kruskal-Wallis test for self-related data
[p, tbl, stats] = kruskalwallis(total_Iself, group);

% Perform multiple comparisons to identify significant group differences
multcompare(stats);

% ---- Repeat the same process for Iothers variable ----

% Combine all other-related data (Iothers) into a single array
total_Iothers = [Iothers_AD_car, Iothers_AD_nocar, Iothers_ApoE, Iothers_HC];

% Define the same group labels as above
group = [repmat(1, 1, 10), repmat(2, 1, 16), repmat(3, 1, 35), repmat(4, 1, 34)];

% Perform Kruskal-Wallis test for other-related data
[p, tbl, stats] = kruskalwallis(total_Iothers, group);

% Perform multiple comparisons to identify significant group differences
multcompare(stats);

