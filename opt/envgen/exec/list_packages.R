#!/usr/bin/env Rscript
sessionInfo()
.libPaths()
.packages()
# avail.df <- available.packages() # Disabled by default
# write.csv(avail.df,"Available_R_Packages.csv")
# mirror.df <- getCRANmirrors(all = TRUE) # Disabled by default
# write.csv(mirror.df,"Available_CRAN_Mirrors.csv")
installed.df <- installed.packages()
write.csv(installed.df, "Installed_R_Packages.csv")
if ("BiocManager" %in% installed.df[, 1]) {
	BiocManager::version()
	BiocManager::repositories()
	# BiocManager::available() # Disabled by default
}
