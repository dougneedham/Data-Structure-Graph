# This is the UI component of my Shiny app that displays a Data Structure Graph
# A Data Structure Graph is a graphical representation of either an ERD (Entity Relationship Diagram) Level 1,
# or a DFD (Data Flow Diagram) Level 2. 
# It could also represent how data flows between multiple organizations.

# Doug Needham
# https://www.linkedin.com/in/dougneedham
# January 2015

library(shiny)

shinyUI(fluidPage(
  titlePanel("Doug Needham Data Structure Graph Analysis"),
  p("A Data Structure Graph is a graphical representation of either an ERD, or the meta-data of data elements that flow through an enterprise"),
  HTML("A Level 1 Data Structure Graph is a  Graph representation of an <a href=\"http://en.wikipedia.org/wiki/Entity%E2%80%93relationship_model\" target=\"_blank\">Entity Relationship Diagram</a>"),
  HTML("A level 2 Data Structure Graph is a Graph representation of a <a href=\"http://en.wikipedia.org/wiki/Data_flow_diagram\" target=\"_blank\">Data Flow Diagram</a>"),
  p("One of the key differences with these traditional methods and a Data Structure Graph is the two diagrams are represented mathematicall as a network or graph.
    This allows us to do some level of structural analysis of the way data moves through either an organization or a particular database."),
  p("Please feel free to uplad a file to this shiny app. The input requirement is a simple CSV file with three (3) columns"),
  p("Column 1 is the parent entity, or source application (level 1 and level 2, respectively) It should be labeled: Source"),
  p("Column 2 is the child entity, or target application (level 1 and level 2, respectively) It should be labeled: Target"),
  p("Column 3 is the relationship that ties the source and target together. Either a foreign key relationship, or a data Entity (level 1 and level 2)"),
  HTML("If you have any questions about this application please contact me through my linkedin profile: <a href=\"https://www.linkedin.com/in/dougneedham\" target=\"_blank\">Doug \"The Data Guy\" Needham</a>"),
  br(),
  p("Once you upload this data, you can \"pull a thread\" for an individual foreign key or data entity to see how it flows."),
  p("The columns are required to be labeld Source,Target,Edge_Label"),
  sidebarLayout(
    sidebarPanel(
      fileInput('file1', 'Choose CSV File',
                accept=c('text/csv', 
                         'text/comma-separated-values,text/plain', 
                         '.csv')),
      tags$hr(),
      checkboxInput('header', 'Header', TRUE),
      radioButtons('sep', 'Separator',
                   c(Comma=',',
                     Semicolon=';',
                     Tab='\t'),
                   ','),
      radioButtons('quote', 'Quote',
                   c(None='',
                     'Double Quote'='"',
                     'Single Quote'="'"),
                   '"'),
    selectInput('thread',"Select thread",choices = NULL)
    ),
    mainPanel(
      imageOutput("myPlot", width=800, height=1000),
      imageOutput("ThreadPlot", width=800, height=500)
    
    )
  )
))
