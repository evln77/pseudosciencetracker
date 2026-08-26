# prepare data
segm_table$article.type <- as.factor(segm_table$article.type)
segm_table$article.type <- factor(segm_table$article.type, levels = c("News", "Blog", "Conference Abstract","Position Statement", "Editorial","Report","Synthesis","Report","Case Study","Data Analysis"))

# timeline without article type
segm_table %>%
  filter(year > 2017 & year < 2026) %>%
  #filter(grepl("consent",abstract)) %>%
  drop_na(article.type) %>%
  ggplot()+
  geom_bar(aes(x=year),position = "stack")+
  labs(title = "SEGM-cited Articles per Year")+
  xlab(label = "\n\n")+
  ylab(label = "number of articles")+
  scale_x_continuous(breaks=seq(1965,2025, by = 1))+
  scale_fill_paletteer_d("tidyquant::tq_dark") +
  theme(plot.background=element_rect("white", colour = "white"),panel.grid = element_line("white"),  
        panel.background = element_rect("white"),legend.background = element_rect("white"),
        legend.box.background = element_rect("white"),legend.key = element_rect("white"),
        text = element_text(colour = "black"),
        legend.position = "right",
        axis.text.y = element_text(color = "darkgray"),
        axis.ticks = element_blank()) -> f
print(a)

# timeline with article type
segm_table %>%
  filter(year > 2017 & year < 2026) %>%
  #filter(grepl("consent",abstract)) %>%
  drop_na(article.type) %>%
  ggplot()+
  geom_bar(aes(x=year,fill=article.type),position = "stack")+
  labs(title = "SEGM-cited Articles per Year")+
  xlab(label = "\n\n")+
  ylab(label = "number of articles")+
  scale_x_continuous(breaks=seq(1965,2025, by = 1))+
  scale_fill_paletteer_d("tidyquant::tq_dark") +
  theme(plot.background=element_rect("white", colour = "white"),panel.grid = element_line("white"),  
        panel.background = element_rect("white"),legend.background = element_rect("white"),
        legend.box.background = element_rect("white"),legend.key = element_rect("white"),
        text = element_text(colour = "black"),
        legend.position = "right",
        axis.text.y = element_text(color = "darkgray"),
        axis.ticks = element_blank()) -> b
print(b)

grid.arrange(a, b, ncol = 2)
