add_node_info = function(nodes, edges, shiny=FALSE){
  colors_dir = 'Datasets/colors_long.txt'
  if(shiny){ colors_dir = '../Datasets/colors_long.txt' }
  
  # Clustering
  graph = graph_from_data_frame(edges, directed = FALSE, vertices = nodes)
  communities = cluster_louvain(graph, weights = edges$value)
  nodes$cluster = communities$membership
  
  # Reassign cluster name
  cluster_size = data.frame(table(nodes$cluster))
  cluster_by_size = cluster_size[with(cluster_size, order(-Freq)), ]
  nodes$cluster = lapply(nodes$cluster, function(x) which(cluster_by_size$Var1==x))
  
  # Assign colors to clusters
  n_clusters = max(communities$membership)
  colors = unlist(strsplit(scan(colors_dir, what='', quiet=TRUE), ' '))
  nodes$color = lapply(nodes$cluster, function(x) colors[x])
  
  # Node and font size
  nodes$value = degree(graph, v=V(graph), mode='total', normalized=TRUE)
  nodes$font.size = sqrt(nodes$value)*25
  
  # Tooltip
  nodes$title = nodes$label
  
  return(nodes)
}
