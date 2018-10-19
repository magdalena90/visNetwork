
library(shiny)
library(visNetwork)
library(igraph)
library(RColorBrewer)

source('../add_node_info.R')

edges = read.csv('../Datasets/clean_edges.csv')
nodes = read.csv('../Datasets/clean_nodes.csv')

layout_options = c('layout_in_circle','layout_on_sphere','layout_randomly')

shinyServer(function(input, output) {
  
  network = eventReactive(input$submit, {

    edges = edges[edges$value >= input$edge_weight,]
    keep_nodes = unique(c(edges$from, edges$to))
    nodes = nodes[nodes$id %in% keep_nodes,]
    nodes = add_node_info(nodes, edges, T)
    
    network = visNetwork(nodes, edges) %>% visLayout(randomSeed = 123) %>%
      visOptions(highlightNearest = TRUE, selectedBy = 'cluster') %>%
      visInteraction(navigationButtons = TRUE)
  
    if(input$interactive == FALSE){
      if(input$igraph_layout == 4){
        network = network %>% visIgraphLayout()
      } else {
        igraph_layout = layout_options[as.integer(input$igraph_layout)]
        network = network %>% visIgraphLayout(layout=igraph_layout) 
      }
    }
    
    network
  })
  
  output$network = renderVisNetwork( network() )

})
