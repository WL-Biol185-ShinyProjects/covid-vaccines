library(shiny)
library(utils)
library(tidyverse)
library(threejs)
library("maptools")
library("maps")
library("writexl") 


function(input, output) {


  output$summary <- renderText({
    summary(x())
  })



}


function(input, output, session) {


worldcities_all_manu <- read.csv("~/covid-vaccines/CSVs/worldcities_all_manu.csv")

  
  output$globe <- renderGlobe({
    


  x <- worldcities_all_manu %>% 
         filter(vaccine == input$vaccine) 
   data(worldcities_all_manu, package = "maps")  
    cities <- x[order(x$vaccines_by_manu,decreasing=TRUE)[1:37],]
    value  <- 1000 * cities$vaccines_by_manu / max(cities$vaccines_by_manu)
    manu_globe <-globejs(bg="black", lat=cities$lat,     long=cities$long, value=value, 
                           rotationlat=-0.34,     rotationlong=-0.38, fov=30)
  })
  
  output$distPlot <- renderPlot({
    hist(rnorm(input$obs))
  })
  
  output$VaccinatedBox <- renderValueBox({
    valueBox(
      paste0(1 + input$count, "Percentage"), "Vaccinated", 
      icon = icon("heart", lib = "glyphicon"),
      color = "light-blue"
    )
  })
  
  output$Predominant_VaccineBox <- renderValueBox({
    valueBox(
      paste0(1 + input$count, "Type"), "Predominant Vaccine", 
      icon = icon("briefcase", lib = "glyphicon"),
      color = "blue",
    )
  })
  
  output$CountryBox <- renderValueBox({
    valueBox(
      paste0(1 + input$count, "country"), "Country", 
      icon = icon("search", lib = "glyphicon"),
      color = "aqua",
    )
  })
  
  output$heartbeat <- renderUI({
    invalidateLater(40 * 1000, session)
    p(Sys.time(),style = "visibility: hidden;")
  })
  
}


