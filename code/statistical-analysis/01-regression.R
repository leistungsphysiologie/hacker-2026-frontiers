## set seed for reproducibility -----------------------------------------------
set.seed(20032025)

## load packages --------------------------------------------------------------
library(tidyverse)
library(here)
library(lmtest)
library(see) # required for performance::check_model()

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

## regression analysis --------------------------------------------------------
# full model ----
full_model <- lm(
  vitamin_d_nmol ~
    scale(pgs) +
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

full_model_summary <- summary(full_model)

cli::cli_h1("Full model summary (w/o robust standard errors)")
print(full_model_summary)

# ---- check assumptions
# visual inspection
performance::check_model(full_model)

# test normality of residuals
shapiro.test(residuals(full_model))

# test homoskedasticity
lmtest::bptest(full_model)

# test multicollinearity
car::vif(full_model)

# test high leverage
which(hatvalues(full_model) > 0.5)

cooks_d <- cooks.distance(full_model)
which(cooks_d > 4 / length(cooks_d))

# robust standard errors
robust_model <- lmtest::coeftest(
  full_model,
  vcov = sandwich::vcovHC(full_model, type = "HC4")
)

cli::cli_h1("Full model summary (w/ robust standard errors)")
print(robust_model)

# confidence intervals (with robust standard errors)
robust_ci <- confint(robust_model) %>%
  as_tibble(rownames = "term") %>%
  mutate(
    formatted_text = paste0(
      round(`2.5 %`, 2),
      ", ",
      round(`97.5 %`, 2)
    )
  )

cli::cli_h1("Full model 95% confidence intervals (w/ robust standard errors)")
print(robust_ci)

# null model ----
null_model <- lm(
  vitamin_d_nmol ~
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

null_model_summary <- summary(null_model)

# compare models ----
# contribution of PGS to R2 (incremental R2)
full_model_summary$r.squared - null_model_summary$r.squared

# contribution of PGS to adjusted R2
full_model_summary$adj.r.squared - null_model_summary$adj.r.squared

# performance metrics ----
# mean absolute error
mae <- mean(abs(
  predict(full_model, newdata = data) - data$vitamin_d_nmol
))
# root mean squared error
rmse <- sqrt(mean(
  (predict(full_model, newdata = data) - data$vitamin_d_nmol)^2
))

cat("\n")
cli::cli_alert("MAE: {round(mae, 2)} | RMSE: {round(rmse, 2)}")
