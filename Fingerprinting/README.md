## **README - How to perform functional fingerprinting analyses**

### **1. `Extract_FC_matrices.m`**  
- Computes average time series for brain regions using pre-selected atlases (e.g., Glasser, Schaefer 100/200).  
- Generates FC matrices from MRI/fMRI data (zipped `.nii.gz` or unzipped `.nii`).  
- Outputs include volume-per-volume parcellation and/or FC matrices for further analysis.

---

### **2. `FC_matrices_preparation.m`**  
- Creates the input structure for the fingerprinting analysis by enriching FC matrices with INT values.

Input files:
- *_FC_half1_test.mat
- *_FC_half2_retest.mat
- *_INT.mat

Output files:
- input_matrices/FC_INT_*.mat

---

### **3. Fingerprinting.m**  
- Calculates identifiability metrics (e.g., success rates, *Iself*, *Iothers*, *Idiff*, ICC).  
- Performs statistical analysis using Kruskal-Wallis tests and post-hoc comparisons.  
- Requires `f_load_mat.m` and `f_ICC_edgewise.m`.

Input files:
- input_matrices/FC_INT_*.mat

Output files:
- ICC/ICC_mat_*.mat

---

### **4. ICC_stats.m**  
- Processes **Intraclass Correlation Coefficients (ICC)** from FC matrices.  
- Conducts statistical comparisons across groups with Fisher's Z-transformation.  
- Visualizes results using heatmaps of corrected p-values and effect sizes.  
- Includes network-specific evaluations for unimodal and transmodal networks.

Input files:
- ICC/ICC_mat_*.mat

Output files:
- Figure 4E
- Supplementary Figure 6 
