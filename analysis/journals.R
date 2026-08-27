# load packages
library(tidyverse)
library(gridExtra)

# load data
journals <- read_csv("journals.csv")
segm_compendium <- read_csv("segm_compendium.csv")

# graph of journals for all articles
journals %>% filter(n > 9) %>%
  filter(journal!="") %>%
  mutate(journal = fct_reorder(journal, n)) %>%
  ggplot()+
  geom_col(aes(y=journal,x=n),position = position_dodge())+
  labs(title = "SEGM-cited articles by journal")+
  ylab(label = "\n\n")+
  xlab(label = "number of articles")+
  scale_x_continuous(limits=c(0,35), breaks=seq(0,35, by = 5)) +
  theme(plot.background=element_rect("white", colour = "white"),panel.grid = element_line("white"),  
        panel.background = element_rect("white"),legend.background = element_rect("white"),
        legend.box.background = element_rect("white"),legend.key = element_rect("white"),
        text = element_text(colour = "black"),
        legend.position = "none",
        axis.text.x = element_text(color = "black"),
        axis.ticks = element_blank()) -> a
print(m)

# graph of journals for editorials
segm_compendium %>%
  filter(article.type=="Editorial") %>%
  count(journal) %>% 
  mutate(journal = fct_reorder(journal, n)) %>% 
  filter(journal != "NA") %>%
  filter(n > 4) %>%
  ggplot() +
  geom_col(aes(y=journal,x=n),position = position_dodge())+
  labs(title = "SEGM-endorsed editorials by journal")+
  ylab(label = "\n\n")+
  xlab(label = "number of editorials")+
  scale_x_continuous(limits=c(0,35), breaks=seq(0,35, by = 5)) +
  theme(plot.background=element_rect("white", colour = "white"),panel.grid = element_line("white"),  
        panel.background = element_rect("white"),legend.background = element_rect("white"),
        legend.box.background = element_rect("white"),legend.key = element_rect("white"),
        text = element_text(colour = "black"),
        legend.position = "none",
        axis.text.x = element_text(color = "black"),
        axis.ticks = element_blank()) -> g
print(n)

grid.arrange(m,n,nrow=2)
