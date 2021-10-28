
library(dplyr)
library(purrr)

metrics_dir <- "/home/kris/"
paths <- list.files(metrics_dir, "*.csv", full = TRUE)
metrics <- map_dfr(paths, read.csv, .id = "path") %>%
	mutate(model = basename(paths[as.integer(path)]))

avg_metrics <- metrics %>%
	group_by(model) %>%
	summarize_at(vars(IoU, precision, recall, frechet), mean) %>%
	mutate_at(vars(IoU, precision, recall, frechet), ~ round(., 4))

write.csv(metrics, "metrics_combined.csv", row.names = FALSE)
write.csv(avg_metrics, "metrics_average.csv", row.names = FALSE)
