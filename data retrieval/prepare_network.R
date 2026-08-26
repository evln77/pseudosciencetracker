# prepare data
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

# save
colnames(author_edges) <- c("to", "from", "weight")
author_edges <- filter(author_edges, weight > 0)
write.csv(author_edges, "segm_edges.csv", row.names=FALSE)

# prepare nodes
to <- as.data.frame(author_edges$to)
from <- as.data.frame(author_edges$from)
nodes <- rbind(set_names(to, "author"),set_names(from, "author"))
nodes <- unique(nodes)
merge(nodes, author_counts[, c("author", "n")], by="author") -> nodes

# add affiliations
segm <- c("Malone W J","Mason J W", "Clayton A", "DAngelo R", "Abbruzzese E", "Biggs M", "Byng R","Hutchinson A", "Solheim K","Spiliadis A", "Cohn J","Goonan K", "Hunter P K", "Ayad S", "Marchiano L","Clarke P","Spencer J B","Syrulink E","Kenny D T")
icgdr <- c("Littman L","OMalley S", "Zucker K J")
sfund <- c("Athéa N", "Bailey J M", "BrignardelloPetersen R", "Couban R", "Dahlin K", "Diaz S","ExpósitoCampos P","Grignon P","Guyatt G","Ibrahim S","Januś D","Joffe A R", "Jorgensen S C J","Kaltiala R","Karvonen M","Kerr K F","KulatungaMoruzi C","Levine S B","Masson C","Miroshnychenko A","Mitchell I","Montante S","Palmer D","Ptak J J","Regenstreif L","Sinai J","YepesNuñez J J","Zhang Y")
wpath <- c("Adams N J", "Adrian T M", "Allen L R", "Arcelus J","Azul D","Bagga H","Basar K", "Bathory D S", "Belinky J J","Berg D R","Berli J U","BluebondLangner R O", "Bouman M P","Bouman W P","Bower M L","Brassard P J","Brown G R","Byrne J","Capitan L","Cargill C J","Carswel J M","Chang S C","Chelvakumar G","Coleman E","Corneil T","Dalke K B","de Vries A L C", "de Vries E","DeCuypere G", "den Heijer M","Deutsch M B","Devor A H","Dhejne C","Dmarco A","Ducheny K","Edmiston E K","EdwardsLeeper L","Ehrbar R","Ehrensaft D","Eisfeld J","Elaut E","EricksonSchroth L","Ettner R","Feldman J L","Fisher A D","Fraser L","Garcia M M", "Grijs L", "Goodman M","Green J", "Green S E","Hall B P","Hancock A B","Hardy T L D","Irwig M S","Jacobs L A","Janssen A C","Johnson K","Johnson T W","Karasic D H","Klink D T","Knudson G A","Kreukels B P C","Kuler L E","Kvach E J","Leibowitz S F","Malouf M A","Massey R","Mazur T","McLachlan C","MeyerBahlburg H F L","Monstrey S J","Morrison S D","Mosser S W","Motmans J","Nahata L","Neira P M","Nieder T O","Nygren U","Oates J M","ObedinMaliver J","Pagkalos G","Patton J","Phanuphak N","Rachlin K","Radix A E","Reed T","Reisner S L","Richards C","Rider G N","Ristori J","RobbinsCherry S","Roberts S A","RodriguezWallberg K A", "Rosenthal S M","Sabir K","Safer J D","Schechter L S","Scheim A I","Seal L J","Sehoole T J","Spencer K","StArmand C","Steensma T D","Strang J F","Tangpricha V","Taylor G B","Tilleman K","Tishelman A C","TSjoen G G","Vala L N","Van Mello N M","Van Trotsenburg M A A","Veale J F","Vencill J A","Vincent B","Wesp L M","West M A","Winter S")
acp <- c("Hruz P W", "Laidlaw M K", "Van Meter Q L", "Van Mol A", "Cretella M")
nodes %>%
  mutate(aff = case_when(author %in% segm ~ "SEGM", author %in% icgdr ~ "ICGDR", author %in% sfund ~ "SEGM-funded", author %in% wpath ~"WPATH SOC8", author %in% acp ~ "ACPeds", .default = "none")) -> 
  nodes
nodes$aff <- as.factor(nodes$aff)
nodes$aff <- factor(nodes$aff, levels = c("WPATH SOC8","SEGM","SEGM-funded","ICGDR", "ACPeds","none"))

# save
write.csv(nodes, "author_nodes.csv", row.names = FALSE)


