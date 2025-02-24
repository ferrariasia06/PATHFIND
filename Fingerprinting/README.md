# **README - Functional Fingerprinting Analyses**

This guide outlines the steps and scripts required to perform functional fingerprinting analyses. Each script processes specific data and generates outputs for subsequent steps. File and folder names are highlighted for clarity.

---

## **1. `Extract_FC_matrices.m`**  
This script computes average time series for brain regions using pre-selected atlases (e.g., Glasser, Schaefer 100/200). It generates **Functional Connectivity (FC) matrices** from MRI/fMRI data.  

### **Input:**
- MRI/fMRI data in `.nii.gz` (zipped) or `.nii` (unzipped) formats.

### **Output:**
- Volume-per-volume parcellation files.
- FC matrices for further analysis.

---

## **2. `FC_matrices_preparation.m`**  
This script prepares the input structure for fingerprinting analysis by enriching FC matrices with INT values.

### **Input Files:**
- `*_FC_half1_test.mat`  
- `*_FC_half2_retest.mat`  
- `*_INT.mat`  

### **Output Files:**
- `input_matrices/FC_INT_*.mat`

---

## **3. `Fingerprinting.m`**  
This script calculates identifiability metrics and performs statistical analysis.

### **Metrics Computed:**
- Success rates, *Iself*, *Iothers*, *Idiff*, and ICC (Intraclass Correlation Coefficients).  

### **Statistical Tests:**
- Kruskal-Wallis tests with post-hoc comparisons.

### **Dependencies:**
- `f_load_mat.m`  
- `f_ICC_edgewise.m`

### **Input Files:**
- `input_matrices/FC_INT_*.mat`

### **Output Files:**
- `ICC/ICC_mat_*.mat`

---

## **4. `ICC_stats.m`**  
This script processes **Intraclass Correlation Coefficients (ICC)** from FC matrices and conducts group-level statistical comparisons.

### **Key Features:**
- Fisher's Z-transformation for group comparisons.
- Heatmaps of corrected p-values and effect sizes.
- Network-specific evaluations for unimodal and transmodal networks.

### **Input Files:**
- `ICC/ICC_mat_*.mat`

### **Output Files:**
- `Figure 4E`
- `Supplementary Figure 6`

---
