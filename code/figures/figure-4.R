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
  sheet = "Figure 4"
) %>%
  mutate(
    vitamin_d_nmol_status = factor(
      vitamin_d_nmol_status,
      levels = c(0, 1, 2),
      labels = c("deficient", "insufficient", "sufficient")
    )
  )

## plot data ----
plot_data %>%
  ggplot(aes(vitamin_d_nmol_status, scale(pgs))) +
  geom_hline(
    yintercept = c(-3, -2, -1, 0, 1, 2, 3),
    color = "grey90",
    linetype = 1,
    linewidth = 0.25
  ) +
  ggdist::stat_halfeye(
    slab_color = "#fdb913",
    slab_linewidth = 0.5,
    fill = colorspace::lighten("#fdb913", amount = 0.5),
    adjust = 0.5,
    width = 0.5,
    .width = 0,
    justification = -0.4,
    point_colour = NA
  ) +
  geom_boxplot(
    color = "#fdb913",
    fill = colorspace::lighten("#fdb913", amount = 0.5),
    width = 0.25,
    outlier.shape = NA
  ) +
  geom_point(
    alpha = 0.5,
    shape = 21,
    fill = "black",
    color = "white",
    size = 2.25,
    stroke = 0.75,
    position = position_jitter(seed = 1, width = 0.02, height = 0)
  ) +
  ggsignif::geom_signif(
    comparisons = list(
      c("deficient", "sufficient"),
      c("insufficient", "sufficient")
    ),
    test = "t.test",
    map_signif_level = TRUE,
    step_increase = 0.125,
    tip_length = 0.01,
    family = "roboto",
    y_position = 3.2
  ) +
  cowplot::theme_cowplot() +
  labs(
    x = "Vitamin D Status",
    y = "Standardized Polygenic Score"
  ) +
  theme(
    text = element_text(
      family = "roboto"
    ),
    title = element_text(
      family = "roboto"
    ),
    axis.text.y = ggtext::element_markdown(lineheight = 1.2),
    axis.title.y = element_text(
      margin = margin(t = 0, r = 10, b = 0, l = 0)
    ),
    axis.title.x = element_text(
      margin = margin(t = 5, r = 0, b = 0, l = 0)
    )
  ) +
  scale_y_continuous(
    labels = c(-3, -2, -1, 0, 1, 2, 3),
    breaks = c(-3, -2, -1, 0, 1, 2, 3)
  ) +
  scale_x_discrete(
    labels = c(
      "deficient" = "deficient<br>(*<50 nmol/L*)",
      "insufficient" = "insufficient<br>(*50--75 nmol/L*)",
      "sufficient" = "sufficient<br>(*≥75 nmol/L*)"
    )
  ) +
  coord_flip()

# save plot
ggsave(
  here("output", "figure-4.tiff"),
  width = 17,
  height = 10,
  units = "cm",
  bg = "white",
  dpi = 400
)
