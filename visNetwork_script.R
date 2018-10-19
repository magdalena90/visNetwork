setwd('~/MSc/visNetwork/')

library(visNetwork) # https://datastorm-open.github.io/visNetwork/
library(igraph)

source('add_node_info.R')

#################################################################################
# DATASETS:

# 1. Download The Marvel Social Network from https://github.com/gephi/gephi/wiki/Datasets

# 2. The file is in .gephi format, so I opened it in Gephi and from there extracted the 
# nodes and edges .csv files and saved them in the Datasets folder as original_edges.csv'
# and original_nodes.csv' (perhaps there's a way to do this directly with R but I couldn't
# find it)

# 3. Run clean_datasets.R script to create clean_edges.csv and clean_nodes.csv

edges = read.csv('Datasets/clean_edges.csv')
nodes = read.csv('Datasets/clean_nodes.csv')

#################################################################################
# SMALL NETWORK

# Simple network
edges_small = edges[edges$value >= 150,]
keep_nodes = unique(c(edges_small$from, edges_small$to))
nodes_small = nodes[nodes$id %in% keep_nodes,]

visNetwork(nodes_small, edges_small)

# Add info to nodes
nodes_small_w_info = add_node_info(nodes_small, edges_small)

visNetwork(nodes_small_w_info, edges_small)

# Save
network = visNetwork(nodes_small_w_info, edges_small, width = '100%')
visSave(network, file = 'network_small.html')


remove(keep_nodes, network)
#################################################################################
# Size problems with interactive plots:

edges_medium = edges[edges$value >= 50,]
keep_nodes = unique(c(edges_medium$from, edges_medium$to))
nodes_medium = nodes[nodes$id %in% keep_nodes,]
nodes_medium_w_info = add_node_info(nodes_medium, edges_medium)

visNetwork(nodes_medium_w_info, edges_medium)

# Fix: igraph Layouts (http://igraph.org/r/doc/layout_.html)
visNetwork(nodes_medium_w_info, edges_medium) %>% visIgraphLayout()

visNetwork(nodes_medium_w_info, edges_medium, main='Superhero Network') %>%
  visIgraphLayout(layout = 'layout_in_circle') %>%
  visOptions(highlightNearest = TRUE, selectedBy = 'cluster') %>%
  visLayout(randomSeed = 123)


remove(keep_nodes)
