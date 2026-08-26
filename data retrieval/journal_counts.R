#create journal counts
segm_table %>% count(journal) %>% arrange(desc(n)) %>% filter(journal != "NA") -> journal_counts
## load APCs and publishers
journal_info <- read_csv("journals.csv")
# add apc and publisher info
merge(journal_counts, journal_info[, c("journal", "apc", "parent")], by="journal") -> journal_counts
journal_counts$profit <- journal_counts$n*journal_counts$apc
write.csv(journal_counts, "segm_journals.csv", row.names = FALSE)
aggregate(journal_counts$profit, by=list(parent=journal_counts$parent), FUN=sum) -> pub_profits
pub_profits <- pub_profits[order(-pub_profits$x),]
