library(shiny)
library(utils)
worldcities_pfizer <- read.csv("CSVs/worldcities_pfizer.csv")
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
  
  
  x<- reactive({
    if(input$vaccine == "Pfizer") {
      worldcities_all_manu <- worldcities_all_manu %>%
        filter(vaccine == "Pfizer/BioNTech")}
    else if(input$vaccine == "Moderna") {
      worldcities_all_manu <- worldcities_all_manu %>%
        filter(vaccine == "Moderna")}
    else if(input$vaccine == "AstraZeneca") {
      worldcities_all_manu <- worldcities_all_manu %>%
        filter(vaccine == "Oxford/AstraZeneca")}
    else if(input$vaccine == "Johnson&Johnson") {
      worldcities_all_manu <- worldcities_all_manu %>%
        filter(vaccine == "JJ")}
  })
  
  output$pfizer_globe <- renderGlobe({
    
    data(x, package="maps")
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


