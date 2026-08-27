# load package
library(igraph)
library(tidyverse)

# load data
edges <- read_csv("edges.csv")
nodes <- read_csv("nodes.csv")

# generate network
net <- graph_from_data_frame(d = edges, vertices = nodes, directed = FALSE)
net <- simplify(net, remove.multiple = F, remove.loops = T) 
pal <- c("#DD75D3FF","#E16305FF","#F2CB05FF","#719F47FF","#7E8CF3FF","gray50")
V(net)$color <- pal[V(net)$aff]
V(net)$label <- NA
E(net)$width <- E(net)$weight/5
V(net)$size <- V(net)$n/1.5
plot(net, layout=layout_with_kk(net,weights=E(net)$weights)*0.025, rescale=FALSE)  
legend(x="bottomright", c("WPATH","SEGM","SEGM-funded","ICGDR","ACPeds"), pch=21, 
       col="gray20", pt.bg=pal, pt.cex=3, cex=1, bty="n", ncol=1)
