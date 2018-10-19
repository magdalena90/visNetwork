
library(shiny)
library(visNetwork)
library(igraph)
library(RColorBrewer)

shinyUI(fluidPage(theme='styles.css',
  
  titlePanel('Superhero Network'),
  
  sidebarLayout(
    sidebarPanel("Select network's parameters:\n",
      sliderInput('edge_weight', 'Min edge weight', min=10, max=200, value=150),
      checkboxInput('interactive', 'Interactive plot', value=TRUE),
      conditionalPanel(
        condition = 'input.interactive==false',
        radioButtons('igraph_layout', 'Choose layout',
                     choices = list('Original'=4, 'Circle'=1, 'Sphere'=2, 'Random'=3),
                     selected = 4)
      ),
      actionButton('submit', 'Submit')
    ),
    
    mainPanel( visNetworkOutput('network') )
  )
))
