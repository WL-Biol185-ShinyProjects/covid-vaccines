library(leaflet)

leaflet() %>%
  setView(lng = -79.442778, lat = 37.783889, zoom = 12) %>%
  addProviderTiles(providers$NASAGIBS.ViirsEarthAtNight2012)


leaflet() %>% 
  setView(lng = -79.442778, lat = 37.783889, zoom = 12) %>% 
  addProviderTiles(providers$CartoDB.Positron)


leaflet() %>% 
  addTiles() %>% 
  setView(lng = -79.442778, lat = 37.783889, zoom = 8) %>%
  addWMSTiles(
    "http://mesonet.agron.iastate.edu/cgi-bin/wms/nexrad/n0r.cgi",
    layers = "nexrad-n0r-900913",
    options = WMSTileOptions(format = "image/png", transparent = TRUE),
    attribution = "Weather data © 2012 IEM Nexrad"
  )



lex <- data.frame( lat    = c(37.789444 , 37.787673  ,  37.785624  )
                   , lon    = c(-79.441725, -79.443623 , -79.441544  )
                   , place  = c("Lab"     , "Classroom", "Thai food!")
                   , rating = c(7         , 5          , 10          )
                   , stringsAsFactors = FALSE
)


leaflet(data = lex) %>% 
  setView(lng = -79.442778, lat = 37.783889, zoom = 12) %>%
  addTiles()


leaflet(data = lex) %>% 
  addTiles() %>% 
  addMarkers(popup = ~place)



