# This is the server component of my Shiny app that displays a Data Structure Graph
# A Data Structure Graph is a graphical representation of either an ERD (Entity Relationship Diagram) Level 1,
# or a DFD (Data Flow Diagram) Level 2. 
# It could also represent how data flows between multiple organizations.

# Doug Needham
# https://www.linkedin.com/in/dougneedham
# January 2015
library(shiny)
library(igraph)
get_color <- function(index) {
  color_list <- colors()
  color_string <- color_list[index]
  return(color_string)
}
dup_fun <- function (x) { c(x,x) }

shinyServer(function(input, output,session) {
  output$myPlot <- renderPlot({
    inFile <- input$file1
    
    if (is.null(inFile))
      return(NULL)
    
    links <- read.csv(inFile$datapath, header=input$header, sep=input$sep, 
                      quote=input$quote)
    Mapper <- graph.data.frame(links,directed=TRUE)
    edge_list <- as.data.frame(unique(sort(links$Edge_Label)))
    options <- c()
    for (index in edge_list[,1]) { options = c(options,c(index,index))}
    updateSelectInput(session, 'thread', choices = options)    
    
    col_levels <- levels(links$Source)
    V(Mapper)$size       <- 8
    V(Mapper)$label.cex  <- 1
    V(Mapper)$label.dist <- 1
    V(Mapper)$color      <- get_color(which(col_levels %in% links[V(Mapper),2]))
    par(mar=rep(0,4))
   
    plot.igraph(Mapper,layout=layout.auto(Mapper))
  })
  output$ThreadPlot <- renderPlot({
    inFile <- input$file1
    
    if (is.null(inFile))
      return(NULL)
    
    links <- read.csv(inFile$datapath, header=input$header, sep=input$sep, 
                      quote=input$quote)
    point_of_origin = 0
    g <- graph.data.frame(links[links$Edge_Label==input$thread,],directed=TRUE)    
    V(g)$size       <- 10
    V(g)$color      <- "green"
    V(g)$label.cex  <- 1
    V(g)$label.dist <- 1
    E(g)$color      <- "black"
    plot(g)
  })
})
