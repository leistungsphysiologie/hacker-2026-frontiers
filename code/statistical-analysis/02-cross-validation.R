## set seed for reproducibility -----------------------------------------------
set.seed(20032025)

## load packages --------------------------------------------------------------
library(tidyverse)
library(data.table)
library(here)

## import data ----------------------------------------------------------------
data <- purrr::map_dfr(
  1:5,
  ~ {
    readxl::read_xlsx(
      here("data", "statistical-analysis.xlsx"),
      sheet = paste("cv fold", .x)
    ) %>%
      mutate(
        vitamin_d_nmol_status = factor(case_when(
          vitamin_d_nmol < 50 ~ "deficient",
          vitamin_d_nmol >= 50 & vitamin_d_nmol < 75 ~ "insufficient",
          vitamin_d_nmol >= 75 ~ "sufficient"
        ))
      )
  }
)

## analysis of 5-fold cross validation results --------------------------------
# helper function to analyze a single fold
analyze_fold <- function(fold_data) {
  # full model with PGS
  full_model_formula <- "vitamin_d_nmol ~ 
    scale(pgs) + 
    scale(cw_uvb) + 
    factor(sex) + 
    scale(age) + 
    factor(competition_environment) + 
    factor(supplement) + 
    scale(pc1) + scale(pc2) + scale(pc3)"

  full_model <- lm(formula = full_model_formula, data = fold_data)
  full_model_summary <- summary(full_model)

  # null model w/o PGS
  null_model_formula <- "vitamin_d_nmol ~ 
    scale(cw_uvb) + 
    factor(sex) + 
    scale(age) + 
    factor(competition_environment) + 
    factor(supplement) +
    scale(pc1) + scale(pc2) + scale(pc3)"

  null_model <- lm(formula = null_model_formula, data = fold_data)
  null_model_summary <- summary(null_model)

  # calculate performance metrics
  actuals <- fold_data$vitamin_d_nmol
  full_preds <- predict(full_model, newdata = fold_data)
  full_mae <- mean(abs(full_preds - actuals)) # mean absolute error
  full_rmse <- sqrt(mean((full_preds - actuals)^2)) # root mean squared error

  null_preds <- predict(null_model, newdata = fold_data)
  null_mae <- mean(abs(null_preds - actuals))
  null_rmse <- sqrt(mean((null_preds - actuals)^2))

  pgs_mae <- null_mae - full_mae
  pgs_rmse <- null_rmse - full_rmse

  results <- list(
    full.r2 = full_model_summary$r.squared,
    full.adj.r2 = full_model_summary$adj.r.squared,
    null.r2 = null_model_summary$r.squared,
    null.adj.r2 = null_model_summary$adj.r.squared,
    pgs.r2 = full_model_summary$r.squared - null_model_summary$r.squared,
    pgs.adj.r2 = full_model_summary$adj.r.squared -
      null_model_summary$adj.r.squared,
    full.mae = full_mae,
    full.rmse = full_rmse,
    null.mae = null_mae,
    null.rmse = null_rmse,
    pgs.mae = pgs_mae,
    pgs.rmse = pgs_rmse
  )

  return(results)
}

# initialize results data frame
fold_results <- tibble(
  fold = integer(),
  full.r2 = numeric(),
  full.adj.r2 = numeric(),
  null.r2 = numeric(),
  null.adj.r2 = numeric(),
  pgs.r2 = numeric(),
  pgs.adj.r2 = numeric(),
  full.mae = numeric(),
  full.rmse = numeric(),
  null.mae = numeric(),
  null.rmse = numeric(),
  pgs.mae = numeric(),
  pgs.rmse = numeric()
)

# run analysis for each fold
for (fold in 1:5) {
  fold_result <- data %>% filter(fold == !!fold) %>% analyze_fold(.)

  fold_results <- fold_results %>%
    bind_rows(tibble(
      fold = fold,
      full.r2 = fold_result$full.r2,
      full.adj.r2 = fold_result$full.adj.r2,
      null.r2 = fold_result$null.r2,
      null.adj.r2 = fold_result$null.adj.r2,
      pgs.r2 = fold_result$pgs.r2,
      pgs.adj.r2 = fold_result$pgs.adj.r2,
      full.mae = fold_result$full.mae,
      full.rmse = fold_result$full.rmse,
      null.mae = fold_result$null.mae,
      null.rmse = fold_result$null.rmse,
      pgs.mae = fold_result$pgs.mae,
      pgs.rmse = fold_result$pgs.rmse
    ))
}

# calculate mean and SD across folds
summary_stats <- data.frame(
  metric = colnames(fold_results)[-1], # exclude 'fold' column
  mean = sapply(fold_results[, -1], mean),
  sd = sapply(fold_results[, -1], sd)
)

# create a 'mean ± SD' column for easy reporting
summary_stats$mean_sd <- paste0(
  round(summary_stats$mean, 2),
  " ± ",
  round(summary_stats$sd, 2)
)

# print summary statistics
cli::cli_h1("Summary of cross-validation results")
print(summary_stats[, -1])

# print individual fold results
cli::cli_h1("Individual fold results")
print(fold_results)
