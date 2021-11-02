
library(dplyr)
library(purrr)

metrics_dir <- "/datadrive/results/inference/compressed/"
paths <- list.files(metrics_dir, "*.csv", full = TRUE, recursive = TRUE)
metrics <- map_dfr(paths, read.csv, .id = "path") %>%
	mutate(model = gsub(metrics_dir, "", paths[as.integer(path)]))

avg_metrics <- metrics %>%
	group_by(model, prob) %>%
	summarize_at(vars(IoU, precision, recall, frechet), mean) %>%
	filter(IoU == max(IoU)) %>%
	mutate_at(vars(IoU, precision, recall, frechet), ~ round(., 4))

write.csv(metrics, "metrics_combined.csv", row.names = FALSE)
write.csv(avg_metrics, "metrics_average.csv", row.names = FALSE)
