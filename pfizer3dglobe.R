library(tidyverse)
library(threejs)
library("maptools")
library("maps")
library("writexl")

worldcities_pfizer <- read_csv("CSVs/worldcities_pfizer.csv")
data(worldcities_pfizer, package="maps")
cities <- worldcities_pfizer[order(worldcities_pfizer$vaccines_by_manu,decreasing=TRUE)[1:37],]
value  <- 1000 * cities$vaccines_by_manu / max(cities$vaccines_by_manu)

pfizer_globe <-globejs(bg="black", lat=cities$lat,     long=cities$long, value=value, 
        rotationlat=-0.34,     rotationlong=-0.38, fov=30)
