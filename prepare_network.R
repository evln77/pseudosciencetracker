##prepare data
author_lists <- authors_expanded[,2:120]
author_lists %>%
  filter(grepl(",", author2)) -> author_lists
author_lists[1] <- gsub("[[:punct:]]","",author_lists$author1)
author_lists[2] <- gsub("[[:punct:]]","",author_lists$author2)
author_lists[3] <- gsub("[[:punct:]]","",author_lists$author3)
author_lists[4] <- gsub("[[:punct:]]","",author_lists$author4)
author_lists[5] <- gsub("[[:punct:]]","",author_lists$author5)
author_lists[6] <- gsub("[[:punct:]]","",author_lists$author6)
author_lists[7] <- gsub("[[:punct:]]","",author_lists$author7)
author_lists[8] <- gsub("[[:punct:]]","",author_lists$author8)
author_lists[9] <- gsub("[[:punct:]]","",author_lists$author9)
author_edges <- data.frame(to = "deleteme", from = "deleteme")
for (i in 1:nrow(author_lists)) {
  combn(author_lists[i,],2) %>%
  as.data.frame(.) %>%
  transpose(.) %>%
  rbind(author_edges,.) -> author_edges
}
author_edges[is.na(author_edges)] <- "deleteme"
author_edges <- filter(author_edges, to != "deleteme" & from != "deleteme")
author_edges = data.frame(lapply(author_edges, as.character), stringsAsFactors=FALSE)
author_edges <- data.frame(t(apply(author_edges, 1, sort)))
author_edges %>%
  distinct(.keep_all = TRUE) ->
  author_edges

#calculate edges
for (i in 1:nrow(author_edges)) {
  filter(author_pubs, author == author_edges[i,1] | author == author_edges[i,2]) %>%
  group_by(title) %>%
  count() %>%
  filter(n > 1) %>%
  nrow(.) -> author_edges[i,3]
}

#save
colnames(author_edges) <- c("to", "from", "weight")
author_edges <- filter(author_edges, weight > 0)
write.csv(author_edges, "segm_edges.csv", row.names=FALSE)

