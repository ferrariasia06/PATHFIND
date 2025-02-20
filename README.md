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
Raut, R. V., Snyder, A. Z., & Raichle, M. E. (2020). *Hierarchical dynamics as a macroscopic organizing principle of the human brain*. *Proceedings of the National Academy of Sciences*, 117(34), 20890-20897. DOI: [10.1073/pnas.2003383117](https://doi.org/10.1073/pnas.2003383117)

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

For questions or contributions, please contact [francesca.saviola@epfl.ch] or [asia.ferrari@unige.ch].

--- 
## **Requirements**
- MATLAB R2020b or later
- R 4.0.0 or later
- Bash shell (Unix-based system or Windows Subsystem for Linux)
- Gannet (https://markmikkelsen.github.io/Gannet-docs/index.html)
- R packages: dplyr, extrafont, gamlss, ggplot2, glmmTMB, knitr, kableExtra, lme4, MASS, readr, readxl, stats, survival, tidyr, viridis (install via `install.packages(c("dplyr", "extrafont", "gamlss", "ggplot2", "glmmTMB", "knitr", "kableExtra", "lme4", "MASS", "readr", "readxl", "stats", "survival", "tidyr", "viridis"))`)
