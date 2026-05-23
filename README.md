# Genetic and non-genetic determinants of vitamin D status: a polygenic score analysis in elite athletes

<!--
to be added after publication

[![DOI](https://img.shields.io/badge/DOI-10.3389%2Ffgene.2025.X-blue)](https://doi.org/10.3389/fgene.2026.X)
[![License: CC BY 4.0](https://img.shields.io/badge/License-CC_BY_4.0-blue.svg)](https://creativecommons.org/licenses/by/4.0/)
-->

> **Hacker, S., Reichert, L., Lenz, C., Henne, S., David, F., Heilmann-Heimbach, S., Zentgraf, K., & Krüger, K. (2026).** Genetic and non-genetic determinants of vitamin D status: a polygenic score analysis in elite athletes.
> *Frontiers in Genetics*

<!--, X(Y), PP–PP. https://doi.org/10.3389/fgene.2026.X -->

---

## Description

This repository contains data and analysis code for a study examining the association between a polygenic score (PGS) for vitamin D metabolism and serum 25-hydroxyvitamin D concentrations in 473 German national squad athletes. Using linear regression models, we assessed the relative contribution of genetic versus non-genetic determinants (supplementation, UVB exposure, age, sex, competition environment). Results indicate that non-genetic factors are the predominant predictors of vitamin D status, with the PGS contributing only a small incremental variance.

## Content

```
├── data/
│   ├── figures.xlsx                   
│   └── statistical-analysis.xlsx      
├── code/
│   ├── figures/                        
│   │   ├── figure-1.R
│   │   ├── figure-2.R
│   │   ├── figure-3.R
│   │   └── figure-4.R
│   └── statistical-analysis/        
│       ├── 01-regression.R
│       ├── 02-cross-validation.R
│       ├── 03-anova.R
│       └── 04-exploratory-interaction-analyses.R
├── output/
│   ├── figure-1.tiff        
│   ├── figure-2.tiff
│   ├── figure-3.tiff
│   └── figure-4.tiff
├── renv.lock
├── CITATION.cff        # will be added after publication
└── LICENSE
```

## Data

| File | Description | Format | Size |
|---|---|---|---|
| `data/figures.xlsx` | Data to reproduce figure 1–4 | .xlsx | ~610 KB |
| `data/statistical-analysis.xlsx` | Data to reproduce the statistical analysis (includes a data dictionary) | .xlsx | ~106 KB |

## Reproducing the analyses

All analyses were conducted in R (version 4.5.2). Package versions are managed via [`renv`](https://rstudio.github.io/renv).  
To restore the exact environment and reproduce all results:

```r
# 1. Clone the repository
# git clone https://github.com/leistungsphysiologie/hacker-2026-frontiers.git

# 2. Install renv (if not already installed)
install.packages("renv")

# 3. Restore all package versions
renv::restore()

# 4. Run the scripts sequentially (`01` → `04`)
source("code/statistical-analysis/01-regression.R")
source("code/statistical-analysis/02-cross-validation.R")
source("code/statistical-analysis/03-anova.R")
source("code/statistical-analysis/04-exploratory-interaction-analyses.R")

# 5. Reproduce the figures and save them as .tiff to `output/`
source("code/figures/figure-1.R")
source("code/figures/figure-2.R")
source("code/figures/figure-3.R")
source("code/figures/figure-4.R")
```

> **Note:** Results (e.g., model outputs, ANOVA results, and exploratory analyses) are printed directly to the R console during execution and are not written to separate output files.

## Contact

- **Sebastian Hacker** – sebastian.hacker@sport.uni-giessen.de
- Department of Exercise Physiology and Sports Therapy, Justus Liebig University Giessen

## License

- Data: [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)
- Code: [MIT License](LICENSE)
