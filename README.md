# **PATHFIND**  
**Paths to Alzheimer's Through Fingerprinting and Intrinsic Neural Dynamics**

This repository provides tools and resources for analyzing **intrinsic neural timescales** (*Raut et al., 2020*) and conducting **functional connectivity (FC) fingerprinting** (*Amico & Goñi, 2018*) in clinical populations using advanced neuroimaging techniques. The goal is to uncover unique patterns of brain connectivity that can serve as biomarkers for neurological and psychiatric conditions.

---

## **Repository Contents**

This repository contains the scripts used for the study "Unveiling paths to Alzheimer’s disease: excitation-inhibition ratio shapes hierarchical dynamics". It implements the analysis to investigate the relationships between EIB, neural fluctuations, and cognitive performance to identify markers sensitive to disease progression.

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
