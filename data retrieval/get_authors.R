# separate authors
segm_table %>% 
  separate(authors, c("author1","author2","author3","author4","author5","author6","author7","author8","author9","last"),"\\., ") ->
  segm_table_authors
author10 <- gsub("[[:punct:]]","",segm_table_authors$last)
author10 <- gsub("^ ","",author10)
author10 <- as.data.frame(author10)
segm_table_authors <- cbind(segm_table_authors,author10)

# add authors over 10 manually
write.csv(segm_table_authors,"segm_authors_expanded.csv", row.names = FALSE)
authors_expanded <- read_csv("segm_authors_expanded.csv")

# get authors
author_pubs <- data.frame(author = "deleteme", title = "deleteme", journal = "deleteme", year = 0, doi_link="deleteme",article.type="deleteme")
for (i in 2:120) {
  unlist(authors_expanded[,i]) %>%
  cbind(author = ., authors_expanded[,c(1,121,122,124,125)]) %>%
  drop_na(.) %>%
  rbind(author_pubs,.) -> author_pubs
}
author_pubs <- author_pubs[-1,]
author_pubs[1] <- gsub("[[:punct:]]","",author_pubs$author)


## save 
write.csv(author_pubs, "segm_authors.csv", row.names = FALSE)

# create author counts
author_pubs %>% count(author) %>% arrange(desc(n)) -> author_counts
author_counts %>% 
  arrange(desc(author)) %>%
  unique(.) ->
  author_counts

# add affiliations
segm <- c("Malone W J","Mason J W", "Clayton A", "DAngelo R", "Abbruzzese E", "Biggs M", "Byng R","Hutchinson A", "Solheim K","Spiliadis A", "Cohn J","Goonan K", "Hunter P K", "Ayad S", "Marchiano L","Clarke P","Spencer J B","Syrulink E","Kenny D T")
icgdr <- c("Littman L","OMalley S","Zucker K J")
sfund <- c("Athéa N", "Bailey J M", "BrignardelloPetersen R", "Couban R", "Dahlin K", "Diaz S","ExpósitoCampos P","Grignon P","Guyatt G","Ibrahim S","Januś D","Joffe A R", "Jorgensen S C J","Kaltiala R","Karvonen M","Kerr K F","KulatungaMoruzi C","Levine S B","Masson C","Miroshnychenko A","Mitchell I","Montante S","Palmer D","Ptak J J","Regenstreif L","Sinai J","YepesNuñez J J","Zhang Y")
wpath <- c("Adams N J", "Adrian T M", "Allen L R", "Arcelus J","Azul D","Bagga H","Basar K", "Bathory D S", "Belinky J J","Berg D R","Berli J U","BluebondLangner R O", "Bouman M P","Bouman W P","Bower M L","Brassard P J","Brown G R","Byrne J","Capitan L","Cargill C J","Carswel J M","Chang S C","Chelvakumar G","Coleman E","Corneil T","Dalke K B","de Vries A L C", "de Vries E","DeCuypere G", "den Heijer M","Deutsch M B","Devor A H","Dhejne C","Dmarco A","Ducheny K","Edmiston E K","EdwardsLeeper L","Ehrbar R","Ehrensaft D","Eisfeld J","Elaut E","EricksonSchroth L","Ettner R","Feldman J L","Fisher A D","Fraser L","Garcia M M", "Grijs L", "Goodman M","Green J", "Green S E","Hall B P","Hancock A B","Hardy T L D","Irwig M S","Jacobs L A","Janssen A C","Johnson K","Johnson T W","Karasic D H","Klink D T","Knudson G A","Kreukels B P C","Kuler L E","Kvach E J","Leibowitz S F","Malouf M A","Massey R","Mazur T","McLachlan C","MeyerBahlburg H F L","Monstrey S J","Morrison S D","Mosser S W","Motmans J","Nahata L","Neira P M","Nieder T O","Nygren U","Oates J M","ObedinMaliver J","Pagkalos G","Patton J","Phanuphak N","Rachlin K","Radix A E","Reed T","Reisner S L","Richards C","Rider G N","Ristori J","RobbinsCherry S","Roberts S A","RodriguezWallberg K A", "Rosenthal S M","Sabir K","Safer J D","Schechter L S","Scheim A I","Seal L J","Sehoole T J","Spencer K","StArmand C","Steensma T D","Strang J F","Tangpricha V","Taylor G B","Tilleman K","Tishelman A C","TSjoen G G","Vala L N","Van Mello N M","Van Trotsenburg M A A","Veale J F","Vencill J A","Vincent B","Wesp L M","West M A","Winter S")
acp <- c("Hruz P W", "Laidlaw M K", "Van Meter Q L", "Van Mol A", "Cretella M")
author_counts %>%
  mutate(aff = case_when(author %in% segm ~ "SEGM", author %in% icgdr ~ "ICGDR", author %in% acp ~ "ACPeds", author %in% sfund ~ "SEGM-funded", author %in% wpath ~ "WPATH SOC8")) -> 
  author_counts

# save
write.csv(author_counts, "author_list.csv", row.names = FALSE)
