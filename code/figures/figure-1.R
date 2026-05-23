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
  sheet = "Figure 1"
)

## prepare data for plotting ----
plot_data <- plot_data %>%
  filter(
    Threshold == 0.00100005 |
      Threshold == 0.0225001 |
      Threshold == 0.0500001 |
      Threshold == 0.1 |
      Threshold == 0.2 |
      Threshold == 0.3 |
      Threshold == 0.4 |
      Threshold == 0.5 |
      Threshold == 1
  ) %>%
  mutate(
    p_label = round(P, digits = 3),
    p_log10 = -log10(P)
  )

## plot data ----
plot_data %>%
  ggplot(., aes(x = factor(Threshold), y = R2)) +
  geom_col(aes(fill = p_log10)) +
  geom_text(
    aes(label = p_label),
    vjust = -1.5,
    hjust = 0,
    angle = 45,
    cex = 4,
    parse = TRUE,
    family = "roboto"
  ) +
  labs(
    x = "*P* -- value threshold",
    y = "PGS *R*<sup>2</sup>",
    fill = "--log<sub>10</sub> model<br>*P* -- value"
  ) +
  scale_fill_gradient2(
    low = colorspace::darken("#fdb913", amount = 0.5),
    high = "#fdb913",
    mid = colorspace::darken("#fdb913", amount = 0.5),
    midpoint = 1e-4
  ) +
  scale_x_discrete(
    labels = c(0.001, 0.0225001, 0.05, seq(0.1, 0.5, 0.1), 1)
  ) +
  scale_y_continuous(
    limits = c(0, max(plot_data$R2) * 1.15),
    expand = c(0, 0)
  ) +
  coord_cartesian(clip = "off") +
  cowplot::theme_cowplot() +
  theme(
    text = element_text(family = "roboto"),
    axis.title.x = ggtext::element_markdown(
      margin = margin(t = 7, r = 0, b = 0, l = 0)
    ),
    axis.title.y = ggtext::element_markdown(
      margin = margin(t = 0, r = 7, b = 0, l = 0)
    ),
    legend.title = ggtext::element_markdown()
  )

## save plot ----
ggsave(
  here("output", "figure-1.tiff"),
  width = 20,
  height = 10,
  units = "cm",
  dpi = 400,
  bg = "white"
)
