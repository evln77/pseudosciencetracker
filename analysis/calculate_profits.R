aggregate(journal_counts$profit, by=list(parent=journal_counts$parent), FUN=sum) -> pub_profits
pub_profits <- pub_profits[order(-pub_profits$x),]
sum(journal_counts$profit, na.rm=TRUE)
