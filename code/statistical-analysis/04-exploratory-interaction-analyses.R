## set seed for reproducibility -----------------------------------------------
set.seed(20032025)

## load packages --------------------------------------------------------------
library(tidyverse)
library(here)
library(lmtest)

## import data ----------------------------------------------------------------
data <- readxl::read_xlsx(
  here("data", "statistical-analysis.xlsx"),
  sheet = "total population"
) %>%
  mutate(
    vitamin_d_nmol_status = factor(
      vitamin_d_nmol_status,
      levels = c(0, 1, 2),
      labels = c("deficient", "insufficient", "sufficient")
    )
  )

## exploratory interaction analyses -------------------------------------------
# pgs x cw uvb ----
pgs_cw_uvb_model <- lm(
  vitamin_d_nmol ~
    scale(pgs) *
    scale(cw_uvb) +
    factor(sex) +
    scale(age) +
    factor(competition_environment) +
    factor(supplement) +
    scale(pc1) +
    scale(pc2) +
    scale(pc3),
  data = data
)

pgs_cw_uvb_model_summary <- summary(pgs_cw_uvb_model)
# print(pgs_cw_uvb_model_summary)

# ---- check assumptions
# # visual inspection
# performance::check_model(pgs_cw_uvb_model)

# # test normality of residuals
# shapiro.test(residuals(pgs_cw_uvb_model))

# # test homoskedasticity
# lmtest::bptest(pgs_cw_uvb_model)

# # test multicollinearity
# car::vif(pgs_cw_uvb_model)

# # test high leverage
# which(hatvalues(pgs_cw_uvb_model) > 0.5)

# cooks_d <- cooks.distance(pgs_cw_uvb_model)
# which(cooks_d > 4 / length(cooks_d))

# robust standard errors
robust_pgs_cw_uvb_model <- lmtest::coeftest(
  pgs_cw_uvb_model,
  vcov = sandwich::vcovHC(pgs_cw_uvb_model, type = "HC4")
)

cli::cli_h1("PGS x cw-D-UVB model summary (w/ robust standard errors)")
print(robust_pgs_cw_uvb_model)

# confidence intervals (with robust standard errors)
robust_pgs_cw_uvb_model_ci <- confint(robust_pgs_cw_uvb_model) %>%
  as_tibble(rownames = "term") %>%
  mutate(
    formatted_text = paste0(
      round(`2.5 %`, 2),
      ", ",
      round(`97.5 %`, 2)
    )
  )

cli::cli_h1(
  "PGS x cw-D-UVB model 95% confidence intervals (w/ robust standard errors)"
)
print(robust_pgs_cw_uvb_model_ci)

# pgs x competition environment ----
pgs_place_model <- lm(
  vitamin_d_nmol ~
    scale(pgs) *
    factor(competition_environment) +
    scale(cw_uvb) +
    factor(sex) +
    scale(age) +
    factor(supplement) +
    scale(pc1) +
    scale(pc2) +
    scale(pc3),
  data = data
)

pgs_place_model_summary <- summary(pgs_place_model)
# print(pgs_place_model_summary)

# ---- check assumptions
# # visual inspection
# performance::check_model(pgs_place_model)

# # test of normality of residuals
# shapiro.test(residuals(pgs_place_model))

# # test homoskedasticity
# lmtest::bptest(pgs_place_model)

# # test multicollinearity
# car::vif(pgs_place_model)

# # test high leverage
# which(hatvalues(pgs_place_model) > 0.5)

# cooks_d <- cooks.distance(pgs_place_model)
# which(cooks_d > 4 / length(cooks_d))

# robust standard errors
robust_pgs_place_model <- lmtest::coeftest(
  pgs_place_model,
  vcov = sandwich::vcovHC(pgs_place_model, type = "HC4")
)

cli::cli_h1(
  "PGS x competition environment model summary (w/ robust standard errors)"
)
print(robust_pgs_place_model)

# confidence intervals (with robust standard errors)
robust_pgs_place_model_ci <- confint(robust_pgs_place_model) %>%
  as_tibble(rownames = "term") %>%
  mutate(
    formatted_text = paste0(
      round(`2.5 %`, 2),
      ", ",
      round(`97.5 %`, 2)
    )
  )

cli::cli_h1(
  "PGS x competition environment model 95% confidence intervals (w/ robust standard errors)"
)
print(robust_pgs_place_model_ci)

# pgs x supplementation
pgs_supplement_model <- lm(
  vitamin_d_nmol ~
    scale(pgs) *
    factor(supplement) +
    scale(cw_uvb) +
    factor(sex) +
    scale(age) +
    factor(competition_environment) +
    scale(pc1) +
    scale(pc2) +
    scale(pc3),
  data = data
)

pgs_supplement_model_summary <- summary(pgs_supplement_model)
# print(pgs_supplement_model_summary)

# ---- check assumptions
# # visual inspection
# performance::check_model(pgs_supplement_model)

# # test normality of residuals
# shapiro.test(residuals(pgs_supplement_model))

# # test homoskedasticity
# lmtest::bptest(pgs_supplement_model)

# # test multicollinearity
# car::vif(pgs_supplement_model)

# # test high leverage
# which(hatvalues(pgs_supplement_model) > 0.5)

# cooks_d <- cooks.distance(pgs_supplement_model)
# which(cooks_d > 4 / length(cooks_d))

# robust standard errors
robust_pgs_supplement_model <- lmtest::coeftest(
  pgs_supplement_model,
  vcov = sandwich::vcovHC(pgs_supplement_model, type = "HC4")
)

cli::cli_h1("PGS x supplementation model summary (w/ robust standard errors)")
print(robust_pgs_supplement_model)

# confidence intervals (with robust standard errors)
robust_pgs_supplement_model_ci <- confint(robust_pgs_supplement_model) %>%
  as_tibble(rownames = "term") %>%
  mutate(
    formatted_text = paste0(
      round(`2.5 %`, 2),
      ", ",
      round(`97.5 %`, 2)
    )
  )

cli::cli_h1(
  "PGS x supplementation model 95% confidence intervals (w/ robust standard errors)"
)
print(robust_pgs_supplement_model_ci)

# test for difference between models
cli::cli_h1("Test for difference between models")
cli::cli_h2("Full model vs. PGS x cw-D-UVB model")
print(waldtest(
  full_model,
  pgs_cw_uvb_model,
  vcov = sandwich::vcovHC(pgs_cw_uvb_model, type = "HC4")
))

cat("\n")
cli::cli_h2("Full model vs. PGS x competition environment model")
print(waldtest(
  full_model,
  pgs_place_model,
  vcov = sandwich::vcovHC(pgs_place_model, type = "HC4")
))

cat("\n")
cli::cli_h2("Full model vs. PGS x supplementation model")
print(waldtest(
  full_model,
  pgs_supplement_model,
  vcov = sandwich::vcovHC(pgs_supplement_model, type = "HC4")
))
