# Clustering-Visualization
Clustering Visualization of Twitter Followers on World Map

Used the twitter API to fetch the data of particular topic inserted by the user in the input box. 

## Used following libraries:
``` r
  library(ggplot2)
  library(plotly)
  library(twitteR)
  library(ggmap)
  library(maps)
  library(ggplot2)
  library(NbClust)
  library(httr)
  library(devtools)
  library(RColorBrewer)
  ```

First used NbClust function to get the optimum clusters which can be visualized on World map and then used kmeans clustering on them to get the clusters.

The clusters will tells the places where the users are active or are concerned about the topic. 

### Application
This can be used by industries to predict what area should they target to get increase thier sale. This kind of project was being used in US Election 2016 to predict the possible areas where Hilary Clinton will get the optimum votes and areas where Prez. Trump will get the votes 
