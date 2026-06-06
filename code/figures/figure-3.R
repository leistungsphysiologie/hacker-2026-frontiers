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
  sheet = "Figure 3"
)

## plot data ----
ggplot(plot_data, aes(x = scale(pgs), y = vitamin_d_nmol)) +
  geom_vline(
    xintercept = c(-3, -2, -1, 0, 1, 2, 3),
    color = "grey90",
    linetype = 1,
    linewidth = 0.25
  ) +
  geom_point(
    alpha = 0.5,
    shape = 21,
    fill = "black",
    size = 2.25
  ) +
  geom_smooth(
    method = "lm",
    color = "#fdb913",
    fill = "grey80"
  ) +
  labs(
    x = "Standardized Polygenic Score",
    y = "Serum 25(OH)D (*nmol/L*)"
  ) +
  scale_x_continuous(
    labels = c(-3, -2, -1, 0, 1, 2, 3),
    breaks = c(-3, -2, -1, 0, 1, 2, 3)
  ) +
  cowplot::theme_cowplot() +
  theme(
    text = element_text(family = "roboto"),
    axis.title.y.left = ggtext::element_markdown(),
    axis.title.y.right = ggtext::element_markdown()
  )

# save plot ----
ggsave(
  here("output", "figure-3.tiff"),
  width = 18,
  height = 10,
  units = "cm",
  dpi = 400,
  bg = "white"
)
