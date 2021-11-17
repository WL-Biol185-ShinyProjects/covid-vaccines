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

#fix country names to make them match hopkins
hopkins$Country_Region[154] <- "United States"
hopkins$Country_Region[143] <- "Taiwan"


#join vaccine and population data
hopkins_pop <- left_join(hopkins, population_by_country, by = c("Country_Region" = "Country..or.dependency.")) 

#create new columns for percent of people partially and fully vaccinated
hopkins_pop$percent_partial <- (hopkins_pop$People_partially_vaccinated / hopkins_pop$Population..2020.)*100
hopkins_pop$percent_fully <- (hopkins_pop$People_fully_vaccinated / hopkins_pop$Population..2020.)*100 

#rename columns to make the country names match 
#hopkins_pop$Country_Region[37] <- "Czech Republic"

world_geo <- readOGR("/home/gregg/countries.geo.json")
world_geo_vax <- read.csv("~/covid-vaccines/CSVs/world_geo_vax1.csv") 
world_geo_vax$people_partial_not_full <- world_geo_vax$People_partially_vaccinated - world_geo_vax$People_fully_vaccinated 
world_geo_vax$percent_partial_not_full <- 100*(world_geo_vax$people_partial_not_full / world_geo_vax$Population..2020.)


world_geo@data <- left_join(world_geo@data, world_geo_vax, by = "name", "name")

#make the map 
mybins <- c(0,5,10,15,20,25,30,35)
mypalette <- colorBin( palette="YlOrBr", domain=world_geo@data, na.color="transparent", bins=mybins)

#fix precision 
world_geo$percent_partial <- round(world_geo$percent_partial, digits = 2)
world_geo$People_fully <- round(world_geo$People_fully, digits = 2)
world_geo$percent_partial_not_full.y <- round(world_geo$percent_partial_not_full.y, digits = 2)

partial_popup <- paste0("<strong>Country: </strong>", 
                        world_geo$name,
                        "<br><strong>Partially Vaccinated: </strong>", 
                      world_geo$People_partially_vaccinated, 
                      "<br><strong>Percent of Population Partially Vaccinated </strong>", 
                      world_geo$percent_partial)
full_popup <- paste0("<strong>Country: </strong>", 
                        world_geo$name,
                     "<br><strong>Fully Vaccinated: </strong>", 
                        world_geo$People_fully_vaccinated, 
                        "<br><strong>Percent of Population Fully Vaccinated </strong>",
                     world_geo$People_fully)


partial_not_full_popup <- paste0("<strong>Country: </strong>", 
                                 world_geo$name,
                                 "<br><strong>Partially Vaccinated: </strong>", 
                                 world_geo$people_partial_not_full.x, 
                                 "<br><strong>Percent of Population Partially Vaccinated (not including fully) </strong>",
                                 world_geo$percent_partial_not_full.y)

#make the maps!
#partial 
leaflet(world_geo) %>% 
  addTiles()  %>% 
  setView( lat=10, lng=0 , zoom=2) %>%
  addPolygons( 
    popup = partial_popup,
    fillColor = ~mypalette(world_geo$percent_partial), 
    stroke=TRUE, 
    fillOpacity = 0.9, 
    color="white",
    weight=0.3,
    labelOptions = labelOptions( 
      style = list("font-weight" = "normal", padding = "3px 8px"), 
      textsize = "13px", 
      direction = "auto"
    )
  ) %>%
  addLegend( pal=mypalette, values=~percent_partial, opacity=0.9, title = "Percent partially vaccinated by country", position = "bottomleft" ) 

#partial but not including fully 
leaflet(world_geo) %>% 
  addTiles()  %>% 
  setView( lat=10, lng=0 , zoom=2) %>%
  addPolygons( 
    popup = partial_not_full_popup,
    fillColor = ~mypalette(world_geo$percent_partial_not_full.y), 
    stroke=TRUE, 
    fillOpacity = 0.9, 
    color="white",
    weight=0.3,
    labelOptions = labelOptions( 
      style = list("font-weight" = "normal", padding = "3px 8px"), 
      textsize = "13px", 
      direction = "auto"
    )
  ) %>%
  addLegend( pal=mypalette, values=~percent_partial_not_full.y, opacity=0.9, title = "Percent partially (but not fully) vaccinated by country", position = "bottomleft" ) 


#full 
leaflet(world_geo) %>%
  addTiles()  %>%
  setView( lat=10, lng=0 , zoom=2) %>%
  addPolygons(
    popup = full_popup,
    fillColor = ~mypalette(world_geo$People_fully),
    stroke=TRUE,
    fillOpacity = 0.9,
    color="white",
    weight=0.3,
    labelOptions = labelOptions(
      style = list("font-weight" = "normal", padding = "3px 8px"),
      textsize = "13px",
      direction = "auto"
    )
  ) %>%
  addLegend( pal=mypalette, values=~People_fully, opacity=0.9, title = "Percent fully vaccinated by country", position = "bottomleft" )


