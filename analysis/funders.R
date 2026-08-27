# load packages
library(tidyverse)
library(paletteer)

# load data
funded_articles <- read_csv("funded_articles.csv")

# arrange data
funded_articles %>% 
  count(type) %>%
  arrange(desc(n)) ->
  fund_counts

# graph of funders by type
fund_counts %>%
  mutate(type = fct_reorder(type, n)) %>%
  ggplot()+
  geom_col(aes(fill=type, x="", y=n))+
  coord_polar(theta="y") +
  labs(title = "Pseudoscience funders by type of organization")+
  ylab(label = "Number of funded studies")+
  xlab(label = "\n\n")+
  scale_fill_paletteer_d("ggsci::legacy_tron") + 
  scale_y_continuous(breaks=seq(0,200, by = 25)) +
  theme(plot.background=element_rect("white", colour = "white"),panel.grid = element_line("white"),  
        panel.background = element_rect("white"),legend.background = element_rect("white"),
        legend.box.background = element_rect("white"),legend.key = element_rect("white"),
        text = element_text(colour = "black"),
        legend.position = "right",
        axis.text.x = element_text(color = "black"),
        axis.ticks = element_blank()) -> l
print(l)
