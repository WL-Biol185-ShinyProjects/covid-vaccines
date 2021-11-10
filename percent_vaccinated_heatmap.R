library(tidyverse)
library(leaflet)
library(rgdal)
library(dplyr)
library(RColorBrewer)


#objective: make a heatmap using leaflet that shows the percent of people fully (and partially) vaccinated in each country. Make an interactive feature in shiny with a drop down menu where users can choose fully or partially vaccinated 

#load vaccination data 
time_series_covid19_vaccine_global <- read_csv("https://raw.githubusercontent.com/govex/COVID-19/master/data_tables/vaccine_data/global_data/time_series_covid19_vaccine_global.csv")
hopkins <- time_series_covid19_vaccine_global

hopkins <- hopkins %>%
  filter(Date == "2021-10-25") %>%
  filter(!is.na(People_fully_vaccinated)) %>%
  filter(Country_Region != "US (Aggregate)") %>%
  filter(Country_Region != "World")


#load population data
population_by_country <- read.csv("~/covid-vaccines/CSVs/population_by_country_2020.csv")

#join vaccine and population data
hopkins_pop <- left_join(hopkins, population_by_country, by = c("Country_Region" = "Country..or.dependency.")) 

#create new columns for percent of people partially and fully vaccinated
hopkins_pop$percent_partial <- (hopkins_pop$People_partially_vaccinated / hopkins_pop$Population..2020.)*100
hopkins_pop$People_fully <- (hopkins_pop$People_fully_vaccinated / hopkins_pop$Population..2020.)*100 

#rename hopkins_pop to make the country names match world_geo 
hopkins_pop$Country_Region[37] <- "Czech Republic"

#upload spatial data for choropleth 
#from https://www.r-graph-gallery.com/183-choropleth-map-with-leaflet.html 

# download.file("http://thematicmapping.org/downloads/TM_WORLD_BORDERS_SIMPL-0.3.zip" ,
#               destfile="~/covid-vaccines/data/world_shape_file.zip")
# system("unzip ~/covid-vaccines/data/world_shape_file.zip")

#create a spatial polygon dataframe
# world_spdf <- readOGR( 
#   dsn= paste0(getwd(),"/DATA/world_shape_file/") , 
#   layer="TM_WORLD_BORDERS_SIMPL-0.3",
#   verbose=FALSE
# )

world_geo <- readOGR("/home/gregg/countries.geo.json")
world_geo_vax <- read.csv("~/covid-vaccines/CSVs/world_geo_vax.csv")

world_geo@data <- left_join(world_geo@data, world_geo_vax, by = "name", "name")

#make the map 
mybins <- c(0,10,20,30,40,50,60,70,80,90,100)
mypalette <- colorBin( palette="YlOrBr", domain=world_geo@data, na.color="transparent", bins=mybins)

partially_vaxxed <- leaflet(world_geo) %>% 
  addTiles()  %>% 
  setView( lat=10, lng=0 , zoom=2) %>%
  addPolygons( 
    fillColor = ~mypalette(hopkins_pop$percent_partial), 
    stroke=TRUE, 
    fillOpacity = 0.9, 
    color="white",
    #color = ~colorQuantile("YlOrRd", world_geo)(world_geo) )
    weight=0.3,
    #label = mytext,
    labelOptions = labelOptions( 
      style = list("font-weight" = "normal", padding = "3px 8px"), 
      textsize = "13px", 
      direction = "auto"
    )
  ) %>%
  addLegend( pal=mypalette, values=~percent_partial, opacity=0.9, title = "Percent partially vaccinated by country", position = "bottomleft" ) %>%
  addPopups(world_geo ,#how to call on country polygon? ,
            world_geo$percent_partial,
            options = popupOptions(closeButton = FALSE)
  )


fully_vaxxed <- leaflet(world_geo) %>% 
  addTiles()  %>% 
  setView( lat=10, lng=0 , zoom=2) %>%
  addPolygons( 
    fillColor = ~mypalette(hopkins_pop$percent_partial), 
    stroke=TRUE, 
    fillOpacity = 0.9, 
    color="white",
    #color = ~colorQuantile("YlOrRd", world_geo)(world_geo) )
    weight=0.3,
    #label = mytext,
    labelOptions = labelOptions( 
      style = list("font-weight" = "normal", padding = "3px 8px"), 
      textsize = "13px", 
      direction = "auto"
    )
  ) %>%
  addLegend( pal=mypalette, values=~percent_partial, opacity=0.9, title = "Percent partially vaccinated by country", position = "bottomleft" ) 


#need to add popup labels and repeat for fully vaxxed 
#need to incorporate into server and add dropdown menu into ui 


