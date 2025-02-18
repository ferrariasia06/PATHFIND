# PATHFIND
PATHFIND: Paths to Alzheimer's THrough Fingerprinting and Intrinsic Neural Dynamics

This repository provides tools and resources for conducting intrinsic neural timescale (Raut et al., 2020) correlations with behavioral data and functional connectivity fingerprinting analysis (Amico & Goni, 2018) in clinical populations using advanced neuroimaging techniques. The aim is to identify and analyze unique patterns of functional brain connectivity that can serve as biomarkers for various neurological and psychiatric conditions.

1. Extract_FC_matrices.m:
This script calculates average time series for different brain regions (parcels) defined by the pre-selected atlas, and computes Functional Connectivity (FC) matrices.
It starts from zipped (nii.gz) or unzipped (nii) MRI/fMRI data; it handles various atlases (e.g., Glasser, Schaefer 100, Schaefer 200) and saves the results (volume per volume parcellation and/or FC matrices) in specified output directories for further analysis.

2. FC_matrices_preparation.m:
This script performs Principal Component Analysis (PCA) on Functional Connectivity (FC) matrices. It also includes a quality check step and can perform a bootstrap procedure for statistical reliability. The script supports PCA on the whole sample or on individual subgroups and can perform a bootstrap procedure.

3. Fingerprinting.m:
This script calculates identifiability metrics by correlating test and retest FC data. Key computations include success rates, Iself, Iothers, Idiff, and Intraclass Correlation Coefficients (ICC). Statistical analysis using the Kruskal-Wallis test and post-hoc comparisons is performed to evaluate group differences. CHeck to have f_load_mat.m and f_ICC_edgewise.m.

4. ICC_stats.m:
This script processes Intraclass Correlation (ICC) values derived from functional connectivity (FC) matrices. It performs statistical comparisons across different subject groups, applies Fisher's Z-transformation, and visualizes the results using heatmaps of corrected p-values and effect sizes. The analysis includes Kruskal-Wallis tests with post-hoc comparisons and further network-specific evaluations for unimodal and transmodal networks.

5. Batch_data_sharing_T0.m: Example batch script for Siemens 3T MEGA-PRESS data with accompanying water references and structural images. Remember to check GannetPreInitialise.m has the appropriate settings for your data.

6. MRS_linear_models.Rmd: This R script performs data preprocessing, normality testing, and regression modeling to analyze the relationship between neuropsychological test scores and neuroimaging variables. It uses zero-inflated Gamma regression models and visualizes results through histograms, Q-Q plots, and linear regression plots.

7. INT_linear_models.Rmd: This R script performs various statistical analyses, including data preprocessing, outlier removal, normality testing, and model fitting to explore the relationship between neuroimaging data and predictors such as gender, MMSE, and group. It uses mixed-effects models (e.g., GLMM, Weibull, Log-Normal) and provides model comparisons based on AIC/BIC, followed by visualization of fixed effects with scatter plots.



# **PATHFIND**  
**Paths to Alzheimer's Through Fingerprinting and Intrinsic Neural Dynamics**

This repository provides tools and resources for analyzing **intrinsic neural timescales** (*Raut et al., 2020*) and conducting **functional connectivity (FC) fingerprinting** (*Amico & Goñi, 2018*) in clinical populations using advanced neuroimaging techniques. The goal is to uncover unique patterns of brain connectivity that can serve as biomarkers for neurological and psychiatric conditions.

---

## **Repository Contents**

### **1. Extract_FC_matrices.m**  
- Computes average time series for brain regions using pre-selected atlases (e.g., Glasser, Schaefer 100/200).  
- Generates FC matrices from MRI/fMRI data (zipped `.nii.gz` or unzipped `.nii`).  
- Outputs include volume-per-volume parcellation and/or FC matrices for further analysis.

---

### **2. FC_matrices_preparation.m**  
- Performs **Principal Component Analysis (PCA)** on FC matrices.  
- Includes quality checks and optional bootstrap procedures for statistical reliability.  
- Supports PCA on the entire sample or subgroups.

---

### **3. Fingerprinting.m**  
- Calculates identifiability metrics (e.g., success rates, *Iself*, *Iothers*, *Idiff*, ICC).  
- Performs statistical analysis using Kruskal-Wallis tests and post-hoc comparisons.  
- Requires `f_load_mat.m` and `f_ICC_edgewise.m`.

---

### **4. ICC_stats.m**  
- Processes **Intraclass Correlation Coefficients (ICC)** from FC matrices.  
- Conducts statistical comparisons across groups with Fisher's Z-transformation.  
- Visualizes results using heatmaps of corrected p-values and effect sizes.  
- Includes network-specific evaluations for unimodal and transmodal networks.

---

### **5. Batch_data_sharing_T0.m**  
- Example batch script for Siemens 3T MEGA-PRESS data with water references and structural images.  
- Ensure `GannetPreInitialise.m` is configured correctly for your dataset.

---

### **6. MRS_linear_models.Rmd**  
- Analyzes relationships between neuropsychological test scores and neuroimaging variables.  
- Performs preprocessing, normality testing, and regression modeling using zero-inflated Gamma regression.  
- Visualizes results with histograms, Q-Q plots, and linear regression plots.

---

### **7. INT_linear_models.Rmd**  
- Explores relationships between neuroimaging data and predictors (e.g., gender, MMSE, group).  
- Conducts mixed-effects modeling (*GLMM*, Weibull, Log-Normal) with AIC/BIC-based model comparisons.  
- Visualizes fixed effects through scatter plots.

---

## **Full Citation**
Amico E, Goñi J (2018). *The quest for identifiability in human functional connectomes*. *Scientific Reports*, 8:1–14. DOI: [10.1038/s41598-018-25089-1](https://www.nature.com/articles/s41598-018-25089-1)

---

## **Usage Notes**
1. Ensure all dependencies are installed before running scripts.
2. Verify compatibility of input data formats with the respective scripts.
3. Review script-specific instructions for configuration details.

---

## **Acknowledgments**
This repository builds on methodologies from:  
- *Raut et al., 2020*: Intrinsic neural timescale correlations with behavior.  
- *Amico & Goñi, 2018*: Functional connectivity fingerprinting analysis.

For questions or contributions, please contact [francesca.saviola].

--- 

