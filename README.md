# Genetic and non-genetic determinants of vitamin D status: a polygenic score analysis in elite athletes

[![DOI](https://img.shields.io/badge/DOI-10.3389%2Ffgene.2026.1838157-blue)](https://doi.org/10.3389/fgene.2026.1838157)
[![License: CC BY 4.0](https://img.shields.io/badge/License-CC_BY_4.0-blue.svg)](https://creativecommons.org/licenses/by/4.0/)

> **Hacker, S., Reichert, L., Lenz, C., Henne, S., David, F., Heilmann-Heimbach, S., Zentgraf, K., & Krüger, K. (2026).** Genetic and non-genetic determinants of vitamin D status: a polygenic score analysis in elite athletes.
> *Frontiers in Genetics, 17*. https://doi.org/10.3389/fgene.2026.1838157

---

## Description

This repository contains data and analysis code for a study examining the association between a polygenic score (PGS) for vitamin D metabolism and serum 25-hydroxyvitamin D concentrations in 473 German national squad athletes. Using linear regression models, we assessed the relative contribution of genetic versus non-genetic determinants (supplementation, UVB exposure, age, sex, competition environment). Results indicate that non-genetic factors are the predominant predictors of vitamin D status, with the PGS contributing only a small incremental variance.

## Content

```
├── data/
│   └── figures.xlsx                   
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
├── CITATION.cff
└── LICENSE
```

## Data

| File | Description | Format | Size |
|---|---|---|---|
| `data/figures.xlsx` | Data to reproduce figure 1–4 | .xlsx | ~610 KB |

> The datasets generated and/or analyzed during the current study are not fully publicly available due to ethical and legal restrictions, specifically concerning the raw genotype data of the participating athletes. Additional data may be available from the corresponding author upon reasonable request and subject to ethical approval and data protection guidelines.

## Reproducing the figures
During manuscript preparation `R version 4.5.2` was used. Package versions are managed via [`renv`](https://rstudio.github.io/renv). The renv lock file has since been updated to `R version 4.6.0`.  To restore the exact environment and reproduce the figures:

```r
# 1. Clone the repository
# git clone https://github.com/leistungsphysiologie/hacker-2026-frontiers.git

# 2. Install renv (if not already installed)
install.packages("renv")

# 3. Restore all package versions
renv::restore()

# 4. Reproduce the figures and save them as .tiff to `output/`
source("code/figures/figure-1.R")
source("code/figures/figure-2.R")
source("code/figures/figure-3.R")
source("code/figures/figure-4.R")
```

## Contact

- **Sebastian Hacker** – sebastian.hacker@sport.uni-giessen.de
- Department of Exercise Physiology and Sports Therapy, Justus Liebig University Giessen

## License

- Data: [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)
- Code: [MIT License](LICENSE)
