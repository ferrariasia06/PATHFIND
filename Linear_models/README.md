# **README - General Linear Models Analyses**

This guide provides instructions for performing general linear model analyses using the provided R Markdown scripts. Each script processes specific datasets and generates outputs for analysis and visualization. File and folder names are highlighted for clarity.

---

## **1. `MRS_linear_models.Rmd`**  
This script analyzes the relationships between neuropsychological test scores and neuroimaging variables. It includes preprocessing, normality testing, and regression modeling using **zero-inflated Gamma regression**.

### **Features:**
- Preprocessing of input data.
- Normality testing with histograms and Q-Q plots.
- Regression modeling with visualizations of results (e.g., linear regression plots).

### **Input File:**
- `Database_AD_MRS.xlsx`

### **Output File:**
- `MRS_linear_model.html`

---

## **2. `INT_linear_models.Rmd`**  
This script explores the relationships between neuroimaging data and predictors such as gender, MMSE scores, and group membership. It performs **generalized linear mixed-effects modeling (GLMM)** with model comparisons based on AIC/BIC criteria.

### **Features:**
- Mixed-effects modeling using Weibull and Log-Normal distributions.
- Model selection based on AIC/BIC values.
- Visualization of fixed effects through scatter plots.

### **Input File:**
- `Database_AD_ApoE_DMN.xlsx`

### **Output File:**
- `INT_linear_models.html`

---

