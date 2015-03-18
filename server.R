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
    
    dsg_input <- read.csv(inFile$datapath, header=input$header, sep=input$sep, 
                      quote=input$quote)
    DSG <- graph.data.frame(dsg_input,directed=TRUE)
    edge_list <- as.data.frame(unique(sort(dsg_input$Edge_Label)))
    options <- c()
    for (index in edge_list[,1]) { options = c(options,c(index,index))}
    updateSelectInput(session, 'thread', choices = options)    
    
    col_levels <- levels(dsg_input$Source)
    V(DSG)$size       <- 8
    V(DSG)$label.cex  <- 1
    V(DSG)$label.dist <- 1
    V(DSG)$color      <- get_color(which(col_levels %in% dsg_input[V(DSG),2]))
    par(mar=rep(0,4))
   
    plot.igraph(DSG,layout=layout.kamada.kawai(DSG))
  })
  output$ThreadPlot <- renderPlot({
    inFile <- input$file1
    
    if (is.null(inFile))
      return(NULL)
    
    dsg_input <- read.csv(inFile$datapath, header=input$header, sep=input$sep, 
                      quote=input$quote)
    point_of_origin = 0
    dsg <- graph.data.frame(dsg_input[dsg_input$Edge_Label==input$thread,],directed=TRUE)    
    V(dsg)$size       <- 10
    V(dsg)$color      <- "green"
    V(dsg)$label.cex  <- 1
    V(dsg)$label.dist <- 1
    E(dsg)$color      <- "black"
    plot.igraph(dsg,layout=layout.fruchterman.reingold(dsg))
    
  })
})
