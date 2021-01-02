library(data.table)
library(ggplot2)
library(magrittr)


# There are some intermediate variables saved, running this takes ~8GB of RAM

# ---------------- Loading and preparing the dataset

bd_norm <- fread('beat-distances-normal.csv', header = F)
bd_iso_est <- fread('beat-distances-iso-est.csv', header = F)

bd <- rbind(
  bd_norm[,drift_sup := factor("normalization")], 
  bd_iso_est[,drift_sup := factor("isometric level est.")]
)

names(bd) <- c(V1 = "index", V2 = "type", V3 = "dist_1", 
                           V4 = "dist_2", V5 = "dist_inf", V6 = "dist_r",
                           drift_sup = "drift_sup")
bd$type = factor(bd$type, ordered = T)
levels(bd$type) = c("0" = "N", "1" = "V")

bd_longer <- melt(bd, id.vars = c("index", "type", "drift_sup"), 
                  variable.name = "measure", value.name = "distance")
bd_longer <- bd_longer[,measure := factor(measure)]

# ---------------- Distance histograms

bd_longer[drift_sup == 'normalization'] %>%
  ggplot(aes(x = distance, after_stat(ndensity), fill = type)) +
  geom_histogram(bins = 50) +
  facet_wrap(vars(measure), scales = "free", ncol = 2)

bd_longer[drift_sup == 'isometric level est.'] %>%
  ggplot(aes(x = distance, after_stat(ndensity), fill = type)) +
  geom_histogram(bins = 50) +
  facet_wrap(vars(measure), scales = "free", ncol = 2)


# ---------------- ROC Curve

max_distances <- bd_longer[!is.na(distance), .(max = max(distance)), by = .(drift_sup, measure)]

roc <- data.table()
for (ds in levels(bd$drift_sup)) {
  print(ds)
  for (msr in levels(bd_longer$measure)) {
    print(msr)
    
    max_dist <- max_distances[drift_sup == ds & measure == msr]$max[1]
    
    data <- bd_longer[drift_sup == ds & measure == msr]
    for (thresh in c(-1, seq(0, max_dist, length.out = 50))) {
      tp <- data[distance >= thresh & type == 'V'] %>% nrow()
      fp <- data[distance >= thresh & type == 'N'] %>% nrow()
      tn <- data[distance < thresh & type == 'N'] %>% nrow()
      fn <- data[distance < thresh & type == 'V'] %>% nrow()
      
      roc <- rbind(roc, data.table(
        threshold = thresh, 
        measure = msr, drift_sup = ds,
        fpr = fp / (fp + tn), 
        tpr = tp / (tp + fn)
      ))
    }
  }
}

ggplot(roc, aes(x = fpr, y = tpr, color = measure, linetype = drift_sup)) +
  geom_path(size = 1) +
  coord_cartesian(xlim = c(0, 0.6), ylim = c(0.2, 1)) +
  labs(title= "ROC curve", 
       x = "False Positive Rate (1-Specificity)", 
       y = "True Positive Rate (Sensitivity)") +
  theme(legend.position = c(0.8, 0.4))


