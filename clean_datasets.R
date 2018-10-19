setwd('~/MSc/visNetwork/')

library(igraph)

# Load data
edges = read.csv('Datasets/original_edges.csv')
nodes = read.csv('Datasets/original_nodes.csv')

# Keep useful variables, change name to visNetwork conventions
edges = edges[,c('Source','Target','Weight')]
nodes = nodes[,c('Id','Label')]

colnames(edges) = c('from','to','value')
colnames(nodes) = c('id','label')
nodes$label = as.character(nodes$label)

# Error in dataset: some nodes duplicated with name starting with ',"'
error_nodes_idx = grep(',"', nodes$label)
error_nodes = nodes$id[error_nodes_idx]

# Create list with correct nodes
for(i in error_nodes_idx){
  correct_node_label = substr(nodes$label[i], 3, nchar(nodes$label[i]))
  correct_node_id = nodes$id[nodes$label == correct_node_label]
  if(length(correct_node_id)==0){
    correct_node_id = max(nodes$id)+1
    nodes = rbind(nodes, list(correct_node_id, correct_node_label))
  }
}

# Replace error_nodes in edges data frame
for(i in error_nodes_idx){
  correct_node_label = substr(nodes$label[i], 3, nchar(nodes$label[i]))
  correct_node_id = nodes$id[nodes$label == correct_node_label]
  incorrect_node_id = nodes$id[i]
  
  # If correct name doesn't exist, create it
  if(length(correct_node_id)==0){
    correct_node_id = max(nodes$id)+1
    nodes = rbind(nodes, list(correct_node_id, correct_node_label))
  }
  
  # Replace wrong id with correct one in edges data frame
  edges$from[edges$from == incorrect_node_id] = correct_node_id
  edges$to[edges$to == incorrect_node_id] = correct_node_id
}

# Remove error_nodes
nodes = nodes[-error_nodes_idx,]

# In case the id change left duplicate edges
graph = graph_from_data_frame(edges, directed = FALSE, vertices = nodes)
E(graph)$value = edges$value
graph = simplify(graph, edge.attr.comb='sum')

edges = data.frame(get.edgelist(graph))
edges$value = E(graph)$value
colnames(edges) = c('from','to','value')

# Write new clean files
write.csv(nodes, 'Datasets/clean_nodes.csv', row.names=FALSE)
write.csv(edges, 'Datasets/clean_edges.csv', row.names=FALSE)


remove(i, incorrect_node_id, correct_node_id, correct_node_label, 
       error_nodes, error_nodes_idx, graph)
