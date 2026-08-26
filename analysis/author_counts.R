# graph for authors of all articles
author_counts %>% 
  filter(n > 9) %>% 
  mutate(author = fct_reorder(author, n)) %>%
  ggplot()+
  geom_col(aes(y=author,x=n, fill=factor(aff)),position = position_dodge())+
  labs(title = "SEGM's most cited researchers",fill="affiliation")+
  ylab(label = "\n\n")+
  xlab(label = "number of articles")+
  scale_x_continuous(limits=c(0,16), breaks=seq(0,16, by = 4)) +
  scale_fill_manual(values = c("SEGM" = "#E16305FF", "WPATH SOC8" = "#DD75D3FF", "SEGM-funded" = "#F2CB05FF")) +
  theme(plot.background=element_rect("white", colour = "white"),panel.grid = element_line("white"),  
        panel.background = element_rect("white"),legend.background = element_rect("white"),
        legend.box.background = element_rect("white"),legend.key = element_rect("white"),
        text = element_text(colour = "black"),
        legend.position = "right",
        axis.text.x = element_text(color = "darkgray"),
        axis.ticks = element_blank()) -> z
print(z)

# graph of authors of editorials
author_pubs %>% 
  filter(article.type == "Editorial") %>%
  count(author) %>%
  arrange(desc(n)) %>%
  filter(n > 3) %>% 
  mutate(aff = case_when(author %in% segm ~ "SEGM", author %in% icgdr ~ "ICGDR", author %in% acp ~ "ACPeds", author %in% sfund ~ "SEGM-funded", author %in% wpath ~"WPATH SOC8")) %>%
  mutate(author = fct_reorder(author, n)) %>%
  ggplot()+
  geom_col(aes(y=author,x=n, fill=aff),position = position_dodge())+
  scale_fill_manual(values = c("SEGM" = "#E16305FF", "ACPeds" = "#7E8CF3FF", "SEGM-funded" = "#F2CB05FF")) +
  labs(title = "SEGM's most cited editorialists",fill="affiliation")+
  ylab(label = "\n\n")+
  xlab(label = "number of articles")+
  scale_x_continuous(limits=c(0,16), breaks=seq(0,16, by = 4)) +
  theme(plot.background=element_rect("white", colour = "white"),panel.grid = element_line("white"),  
        panel.background = element_rect("white"),legend.background = element_rect("white"),
        legend.box.background = element_rect("white"),legend.key = element_rect("white"),
        text = element_text(colour = "black"),
        legend.position = "right",
        axis.text.x = element_text(color = "darkgray"),
        axis.ticks = element_blank()) -> w
print(y)

grid.arrange(z,y,nrow=2)
