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

## anova ----------------------------------------------------------------------
anova <- aov(scale(pgs) ~ vitamin_d_nmol_status, data = data)

cli::cli_h1("ANOVA results")
print(summary(anova))

# post-hoc tests
post_hoc <- TukeyHSD(anova)

cli::cli_h1("Post-hoc tests")
print(post_hoc)

# alternative
# pairwise.t.test(
#   scale(data$pgs),
#   data$vitamin_d_nmol_status,
#   p.adjust.method = "bonferroni"
# )

# summary statistics ----------------------------------------------------------
# vitamin d status
data %>%
  # group_by(vitamin_d_nmol_status) %>%
  summarise(
    n = n(),
    mean = mean(vitamin_d_nmol),
    median = median(vitamin_d_nmol),
    sd = sd(vitamin_d_nmol),
    min = min(vitamin_d_nmol),
    max = max(vitamin_d_nmol)
  )

# pgs
data %>%
  group_by(vitamin_d_nmol_status) %>%
  summarise(
    n = n(),
    mean = mean(scale(pgs)),
    median = median(scale(pgs)),
    sd = sd(scale(pgs)),
    min = min(scale(pgs)),
    max = max(scale(pgs))
  )
