# **README** - **How to perform functional fingerprinting analyses**

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
