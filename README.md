# PATHFIND
PATHFIND: Paths to Alzheimer's THrough Fingerprinting and Intrinsic Neural Dynamics

This repository provides tools and resources for conducting intrinsic neural timescale (INT; Raut et al., 2020) correlations with behavioral data and functional connectivity fingerprinting analysis (Amico & Goni, 2018) in clinical populations using advanced neuroimaging techniques. The aim is to identify and analyze unique patterns of functional brain connectivity that can serve as biomarkers for various neurological and psychiatric conditions.

1. extract_FC_matrices.m
This script calculates average time series for different brain regions (parcels) defined by the pre-selected atlas, and computes Functional Connectivity (FC) matrices. It starts from zipped (nii.gz) or unzipped (nii) MRI/fMRI data; it handles various atlases (e.g., Glasser, Schaefer 100, Schaefer 200) and saves the results (volume per volume parcellation and/or FC matrices) in specified output directories for further analysis.

2. Create_input_structure.m 
This script performs Principal Component Analysis (PCA) on Functional Connectivity (FC) matrices. It also includes a quality check step and can perform a bootstrap procedure for statistical reliability. The script supports PCA on the whole sample or on individual subgroups and can perform a bootstrap procedure.

3. Fingerprinting_metrics.m


4. ICC_stats.m


5. INT_linear_model.Rmd
This R script performs various statistical analyses, including data preprocessing, outlier removal, normality testing, and model fitting to explore the relationship between neuroimaging data and predictors such as gender, MMSE, and group. It uses mixed-effects models (e.g., GLMM, Weibull, Log-Normal) and provides model comparisons based on AIC/BIC, followed by visualization of fixed effects with scatter plots.

6. MRS_linear_model.Rmd
This R script performs data preprocessing, normality testing, and regression modeling to analyze the relationship between neuropsychological test scores and neuroimaging variables. It uses zero-inflated Gamma regression models and visualizes results through histograms, Q-Q plots, and linear regression plots.
