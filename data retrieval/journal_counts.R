# load compendium
segm_compendium <- read_csv("segm_compendium.csv")

# create journal counts
segm_compendium %>% count(journal) %>% arrange(desc(n)) %>% filter(journal != "NA") -> journals

## load APCs and publishers
journal_info <- read_csv("journals_info.csv")

# add apc and publisher info
merge(journals, journal_info[, c("journal", "apc", "parent")], by="journal") -> journal_counts
journals$profit <- journals$n*journals$apc
write.csv(journals, "journals.csv", row.names = FALSE)


