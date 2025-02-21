# **README** - **How to perform general linear models analyses**

### **1. MRS_linear_models.Rmd**  
- Analyzes relationships between neuropsychological test scores and neuroimaging variables.  
- Performs preprocessing, normality testing, and regression modeling using zero-inflated Gamma regression.  
- Visualizes results with histograms, Q-Q plots, and linear regression plots.

Input files:
- Database_AD_MRS.xlsx

Output files:
- MRS_linear_model.html

---

### **2. INT_linear_models.Rmd**  
- Explores relationships between neuroimaging data and predictors (e.g., gender, MMSE, group).  
- Conducts mixed-effects modeling (*GLMM*, Weibull, Log-Normal) with AIC/BIC-based model comparisons.  
- Visualizes fixed effects through scatter plots.

Input files:
- Database_AD_ApoE_DMN.xlsx

Output files:
- INT_linear_models.html

---
