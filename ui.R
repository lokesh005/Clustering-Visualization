library(shinydashboard)
library(shiny)
library(DT)
library(plotly)
library(markdown)
library(httr)
library(devtools)

library(twitteR)

library(ggmap)
library(maps)
library(ggplot2)
library(NbClust)
library(httr)
library(devtools)


shinyUI(fluidPage(
  
  navbarPage("Clustering Visz. on World using Twitter",
             sidebarLayout(
               sidebarPanel(
                 
                 radioButtons('sep', 'Want to use default Keys or new keys for Twitter',
                              c(DEFAULT ='default',
                                NEW ='new'),
                              'default'),
                 
                 uiOutput("mm"),
                 
                 textInput("usernam", "Enter the username" , value = "oneplus"),
                 numericInput("ab", 
                              label = "How many followers you want to show on Graph",  
                              value = 15, max = 6000),
                 hr()
                 
               ),
               
               hr()
               
               
             ),
             mainPanel( 
               plotOutput("marks")
             )
  )
)
)