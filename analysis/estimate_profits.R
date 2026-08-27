# load packages
library(tidyverse)

# load data
journals <- read_csv("journals.csv")

# calculate profits
aggregate(journals$profit, by=list(parent=journals$parent), FUN=sum) -> pub_profits
pub_profits <- pub_profits[order(-pub_profits$x),]
sum(journal_counts$profit, na.rm=TRUE)
