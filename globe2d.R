#adapted from endangered species project on Github: https://github.com/WL-Biol185-ShinyProjects/endangered-species-trends/blob/master/server.R

#country latitudes and long from country-captials.csv
#vaccine data from hopkins data set 

library(tidyverse)
library(leaflet)


hopkins_lat_long <- readRDS("LatLon_Countries.RDS")

output$VulnerableClass <- renderLeaflet({ 
  VulnerableClass <- hopkins_lat_long%>%
    # filter( iucn == "VULNERABLE"
    #         , species == input$VulnerableClass
    # )
  
  VCountriesGeo <- rgdal::readOGR( "data/countries.geo.json"
                                   , "OGRGeoJSON"
  )
  
  # VCountriesGeo@data <- VCountriesGeo@data %>%
  #   left_join( VulnerableClass
  #              , by = c( "name" = "country"
  #              )
  #   )
  # 
  pal <- colorNumeric( "YlOrRd"
                       , c( min( LatLon_Countries$Doses_admin
                       )
                       , max( LatLon_Countries$Doses_admin
                       )
                       )
  )
  leaflet(data = VCountriesGeo)%>%
    addTiles()%>%
    addPolygons( fillColor = ~pal( value)
                 , weight = 1
                 , opacity = 0.1
                 , fillOpacity = 0.7
    )%>%
    addLegend( pal = pal
               , values = ~value
               # , title = "number of species"
               , position = "bottomright"
    )%>%
    setView( lat = 38.0110306
             , lng = 0
             , zoom = 1
    )
  
})
