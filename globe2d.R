#adapted from endangered species project on Github: https://github.com/WL-Biol185-ShinyProjects/endangered-species-trends/blob/master/server.R

#country latitudes and long from country-captials.csv



output$VulnerableClass <- renderLeaflet({ 
  VulnerableClass <- worldData%>%
    filter( iucn == "VULNERABLE"
            , species == input$VulnerableClass
    )
  
  VCountriesGeo <- rgdal::readOGR( "data/countries.geo.json"
                                   , "OGRGeoJSON"
  )
  
  VCountriesGeo@data <- VCountriesGeo@data %>%
    left_join( VulnerableClass
               , by = c( "name" = "country"
               )
    )
  
  pal <- colorNumeric( "YlOrRd"
                       , c( min( VulnerableClass$value
                       )
                       , max( VulnerableClass$value
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
               , title = "number of species"
               , position = "bottomright"
    )%>%
    setView( lat = 38.0110306
             , lng = 0
             , zoom = 1
    )
  
})