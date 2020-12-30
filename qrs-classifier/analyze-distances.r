library(dplyr)
library(tidyr)
library(ggplot2)
library(magrittr)

beat_distances <- read.csv('beat-distances.csv', header = F)

beat_distances %<>% tibble()
names(beat_distances) <- c("index", "type", "dist_1", "dist_2", "dist_inf", "dist_r")

beat_distances$type = factor(beat_distances$type, ordered = T)
levels(beat_distances$type) = c("N", "V")

beat_distances %>%
  pivot_longer(!c('index', 'type'), names_to = "measure", values_to = "distance") %>%
  ggplot(aes(x = distance, fill = type)) +
  geom_histogram(bins = 50) + scale_y_log10() +
  facet_wrap(vars(measure), scales = "free_x")
