# **README - Magnetic Resonance Spectroscopy (MRS) Analyses**

This guide outlines the steps and scripts required to perform Magnetic Resonance Spectroscopy (MRS) analyses. File and script names are highlighted for clarity.

---

## **5. `Batch_data_sharing_T0.m`**  
This script provides an example batch process for Siemens 3T MEGA-PRESS data, including water reference scans and structural images.

### **Key Requirements:**
- Ensure `GannetPreInitialise.m` is correctly configured for your dataset.

---

## **6. `MRS_linear_models.Rmd`**  
This script analyzes relationships between neuropsychological test scores and neuroimaging variables.

### **Features:**
- Preprocessing and normality testing.
- Regression modeling using **zero-inflated Gamma regression**.
- Visualization of results with histograms, Q-Q plots, and linear regression plots.

### **Input File:**
- `Database_AD_MRS.xlsx`

### **Output File:**
- `MRS_linear_model.html`

---
