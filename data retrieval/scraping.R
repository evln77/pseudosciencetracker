# scraping
library(rvest)
link <- "https://segm.org/studies"
segm_studies <- read_html(link)
summaries_css <- segm_studies %>% html_elements(".col-b")
segm_summaries_css2 <- html_text(summaries_css)

# extraction 
library(tidyverse)
abstract <- gsub(".*\\Journal Abstract ", "", segm_summaries_css)
segm_compendium <- as.data.frame(abstract)
segm_summaries_css <- gsub("\n  \n    JOURNAL ABSTRACT\n .*","",segm_summaries_css)
segm_summaries_css <- gsub("^\n   ","",segm_summaries_css)
doi_link <- gsub(".*\\https://","",segm_summaries_css)
doi_link <- as.data.frame(doi_link)
segm_compendium <- cbind(segm_compendium,doi_link)
authors <- gsub("\n.*","", segm_summaries_css)
authors <- as.data.frame(authors)
segm_compendium <- cbind(authors,segm_compendium)
segm_summaries_css <- gsub(",\n.*","",segm_summaries_css)
journal <- gsub(".*\\.\n    ","",segm_summaries_css)
journal <- as.data.frame(journal)
segm_compendium <- cbind(journal,segm_compendium)
segm_summaries_css <- gsub(".\n    .*","",segm_summaries_css)
title <- gsub(".*\\)\n  ","",segm_summaries_css)
title <- as.data.frame(title)
segm_compendium <- cbind(title,segm_compendium)
segm_summaries_css <- gsub(")\n  .*","",segm_summaries_css)
year <- gsub(".*\\(","",segm_summaries_css)
year <- as.data.frame(year)
segm_compendium <- cbind(segm_compendium,year)
segm_compendium$year <- as.numeric(unlist(segm_compendium$year))
segm_compendium %>%
  distinct(.keep_all = TRUE) ->
  segm_compendium

# save
write.csv(segm_compendoum, "segm_compendium.csv", row.names = FALSE)
