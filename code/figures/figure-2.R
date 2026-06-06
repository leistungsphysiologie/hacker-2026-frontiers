## load packages ----
library(tidyverse)
library(here)
library(showtext)

## font options ----
font_add_google("Roboto Condensed", "roboto")
showtext_opts(dpi = 400)
showtext_auto()

## import data ----
plot_data <- readxl::read_xlsx(
  here(
    "data",
    "figures.xlsx"
  ),
  sheet = "Figure 2"
) %>%
  mutate(
    predictor_type = fct_relevel(
      case_when(
        grepl("pgs|pc|sex", term) ~ "Genetic",
        grepl("age", term) ~ "Demographic",
        grepl("cw_uvb|competition|supplement", term) ~
          "Environmental/\nBehavioral"
      ),
      "Genetic",
      "Demographic",
      "Environmental/\nBehavioral"
    )
  )

## plot data ----
ggplot(
  plot_data,
  aes(estimate, reorder(term, estimate), fill = predictor_type)
) +
  geom_vline(
    xintercept = 0,
    color = "grey70",
    linetype = 1,
    linewidth = 0.25
  ) +
  geom_errorbar(
    aes(
      xmin = estimate - 1.96 * std.error,
      xmax = estimate + 1.96 * std.error
    ),
    orientation = "y",
    linewidth = 0.5,
    width = 0.2
  ) +
  geom_point(
    aes(fill = significance),
    color = "white",
    shape = 21,
    size = 3
  ) +
  facet_grid(predictor_type ~ ., scales = "free_y", space = "free_y") +
  scale_fill_manual(
    labels = c(
      "*" = "*p* < 0.05",
      "n.s." = "non significant"
    ),
    values = c(
      "*" = "#fdb913",
      "n.s." = "#7F7F7F"
    )
  ) +
  labs(
    x = "Estimate",
    y = NULL,
    fill = "Significance"
    # caption = "Variables followed by '‡' were standardized."
  ) +
  cowplot::theme_cowplot() +
  theme(
    text = element_text(family = "roboto"),
    axis.text.y = ggtext::element_markdown(),
    strip.text.y = element_text(angle = 0, hjust = 0.5),
    strip.background = element_rect(
      color = "black",
      fill = "white",
      linewidth = 0.5
    ),
    strip.clip = "off", # remove space between facet labels and plot
    legend.position = "top",
    legend.title = element_text(size = 10),
    legend.text = ggtext::element_markdown(size = 10),
    plot.caption.position = "plot",
    plot.caption = element_text(size = 8)
  ) +
  scale_y_discrete(
    labels = c(
      "scale(pgs)" = "PGS<sup>‡</sup>",
      "scale(cw_uvb)" = "cw-D-UVB<sup>‡</sup>",
      "factor(sex)2" = "Sex - *Female*",
      "scale(age)" = "Age<sup>‡</sup>",
      "factor(competition_environment)1" = "Competition environment - *Outdoor*",
      "factor(supplement)1" = "Supplementation - *Yes*",
      "factor(supplement)2" = "Supplementation - *Unknown*",
      "scale(pc1)" = "PC1<sup>‡</sup>",
      "scale(pc2)" = "PC2<sup>‡</sup>",
      "scale(pc3)" = "PC3<sup>‡</sup>"
    )
  )

## save plot ----
ggsave(
  here("output", "figure-2.tiff"),
  width = 16,
  height = 12,
  units = "cm",
  dpi = 400,
  bg = "white"
)
