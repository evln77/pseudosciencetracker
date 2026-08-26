# scraping
library(rvest)
link <- "https://segm.org/studies"
segm_studies <- read_html(link)
summaries_css <- segm_studies %>% html_elements(".col-b")
segm_summaries_css2 <- html_text(summaries_css)

# extraction 
library(tidyverse)
abstract <- gsub(".*\\Journal Abstract ", "", segm_summaries_css)
segm_table <- as.data.frame(abstract)
segm_summaries_css <- gsub("\n  \n    JOURNAL ABSTRACT\n .*","",segm_summaries_css)
segm_summaries_css <- gsub("^\n   ","",segm_summaries_css)
doi_link <- gsub(".*\\https://","",segm_summaries_css)
doi_link <- as.data.frame(doi_link)
segm_table <- cbind(segm_table,doi_link)
authors <- gsub("\n.*","", segm_summaries_css)
authors <- as.data.frame(authors)
segm_table <- cbind(authors,segm_table)
segm_summaries_css <- gsub(",\n.*","",segm_summaries_css)
journal <- gsub(".*\\.\n    ","",segm_summaries_css)
journal <- as.data.frame(journal)
segm_table <- cbind(journal,segm_table)
segm_summaries_css <- gsub(".\n    .*","",segm_summaries_css)
title <- gsub(".*\\)\n  ","",segm_summaries_css)
title <- as.data.frame(title)
segm_table <- cbind(title,segm_table)
segm_summaries_css <- gsub(")\n  .*","",segm_summaries_css)
year <- gsub(".*\\(","",segm_summaries_css)
year <- as.data.frame(year)
segm_table <- cbind(segm_table,year)
segm_table$year <- as.numeric(unlist(segm_table$year))
segm_table %>%
  distinct(.keep_all = TRUE) ->
  segm_table
