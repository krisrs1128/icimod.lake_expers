
library(dplyr)
library(purrr)

metrics_dir <- "/home/kris/"
paths <- list.files(metrics_dir, "*.csv", full = TRUE)
metrics <- map_dfr(paths, read.csv, .id = "path")

avg_metrics <- metrics %>%
	mutate(model = basename(paths[as.integer(path)])) %>%
	group_by(model) %>%
	summarize_at(vars(IoU, precision, recall, frechet), mean) %>%
	mutate_at(vars(IoU, precision, recall, frechet), ~ round(., 4))

write.csv(avg_metrics, "metrics_overall.csv", row.names = FALSE)
