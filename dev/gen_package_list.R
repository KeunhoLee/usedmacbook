library("rvest")
library("stringr")
library("dplyr")
library("RSelenium")

needed_packs <- c('rvest',
                  'stringr',
                  'dplyr',
                  'RSelenium')

installed_packs <- installed.packages()
installed_packs <- as.data.frame(installed_packs, stringsAsFactors = FALSE)

packs_info <- subset(installed_packs,
                Package %in% needed_packs,
                select=c(Package, Version))

saveRDS(packs_info, 'packs_info.rds')
