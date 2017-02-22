#Shiny Server

library(shiny)
library(DT)
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

shinyServer(function(input, output, session) {
  output$mm <- renderUI({
    if(input$sep=="new"){
      list(tags$p(tags$u(h4(paste0("Midterm ", ":")))),
            column(12, textInput("akey", "Enter API key" , value = "")),
            column(12, textInput("asec", "Enter API Secret key" , value = "")),
            column(12, textInput("tok", "Enter Token" , value = "")),
            column(12, textInput("tsec", "Enter Token Secret key" , value = ""))
      )
    }
  }) 
  
  
  
  output$marks <- renderPlot({
    if(input$sep=='default'){
      options(httr_oauth_cache=T)
      api_key <- "9OWlp1fFQMfhRGMdoe1bT5wq2"
      api_secret <- "kdCmc7PD5SrhhkoJ1UeRvuzQrYgc6DY9lGyA6TZpU1hatBYLkE"
      token <- "4717263320-k3AbCBOFipWG8DiChZVSlmw3ODMKMCNGXagzQsx"
      token_secret <- "Zr67eFdorrDZxoUq8Ec8KuSk75yK8zwqfooOf3fbxB9LG"
      
    }
    else if(input$sep=='new'){
      options(httr_oauth_cache=T)
      api_key <- akey
      api_secret <- asec
      token <- tok
      token_secret <- tsec
    }
    # Create Twitter Connection
    setup_twitter_oauth(api_key, api_secret, token, token_secret)
    
    user <- try(getUser(input$usernam),silent=TRUE) 
    followers <- user$getFollowers(input$ab)  #limiting followers to 1000
    followers <- twListToDF(followers)    #converting to dataframe
    followers$location[followers$location==""] <- NA    #assigning NA (not applicable)to 
    
    followers <- followers[sample(1:nrow(followers), size =50, replace=TRUE),]  #size must be less than length of followers
    
    loc1<- !is.na(followers$location) 
    loc<-followers$location[loc1]   
    coord <- geocode(loc)          # geocoding the followers locations
    #setwd("C:\\Users\\LOKESH TODWAL\\Desktop/")
    #y <- read.table("coord.txt")
   
    nb <- NbClust(coord, distance = "euclidean", min.nc = 2,
                  max.nc = 15, method = "kmeans", index ="all")  
    
    nClust<-length(unique(nb$Best.partition))
    kmeans.df <- data.frame(lat = coord$lat,
                            lon = coord$lon)
    kmeans.df <- na.omit(kmeans.df)     #omiting terms with NA 
    
    
    fit <- kmeans(kmeans.df, centers = nClust, nstart = 20)
    
    kmeans.df$cluster = fit$cluster #adding cluster column to data frame
    
    colfunc<-colorRampPalette(c("red","yellow","springgreen","royalblue"))
    cols <- colfunc(nClust)  #to points with same cluster number
    for(i in 1:nClust){
      kmeans.df$color[kmeans.df$cluster == i] <- cols[i]
    }
    
    kmeans.df$Cluster <- as.factor(kmeans.df$cluster)
    
    map.dat <- map_data("world")
    
    g <- ggplot() +                       #plotting the geopoints with clusters 
      geom_polygon(aes(long,lat, group=group), fill="grey85", data=map.dat) +
      geom_jitter(aes(x = lon, y = lat, fill=Cluster,
                      colour=Cluster), alpha=1, size=1.4,  data = kmeans.df) + 
      guides(fill = guide_legend( override.aes = list(alpha = 1))) +
      theme_minimal() +
      theme(text = element_text(size=15),
            legend.position="top")
    
    g <- g +
      stat_density_2d(
        aes(x = lon, y = lat,fill=as.factor(cluster), colour=as.factor(cluster)), 
        bins = 10, alpha=.2,
        size=0, data = kmeans.df, geom = "polygon") 
    
    g
    
  })
})