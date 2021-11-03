library(shiny)
library(utils)
library(tidyverse)
library(threejs)
library("maptools")
library("maps")
library("writexl") 
library("lubridate")


function(input, output) {


  output$summary <- renderText({
    summary(x())
  })



}


function(input, output, session) {
  
  
  worldcities_all_manu <- read.csv("~/covid-vaccines/CSVs/worldcities_all_manu.csv")
  
  
  output$globe <- renderGlobe({
  
    data(worldcities_all_manu, package = "maps") #injection scope, never ever do this again
    x <- worldcities_all_manu %>% 
         filter(vaccine == input$vaccine) 
    print(x)
    nrows_x <- nrow(x)
    cities <- x[order(x$vaccines_by_manu,decreasing=TRUE)[1:nrows_x],]
    value  <- 1000 * cities$vaccines_by_manu / max(cities$vaccines_by_manu)
    manu_globe <-globejs(bg="black", lat=cities$lat,     long=cities$long, value=value, 
                           rotationlat=-0.34,     rotationlong=-0.38, fov=30)
  })
  
  
  output$percapita <- renderPlot({ 
    setwd("~/covid-vaccines/CSVs")
    
    time_series_covid19_vaccine_global <- read_csv("https://raw.githubusercontent.com/govex/COVID-19/master/data_tables/vaccine_data/global_data/time_series_covid19_vaccine_global.csv")
    hopkins <- time_series_covid19_vaccine_global
    
    #left join hopkins with world cities in order to get population to do fully vaccinated per capita
    country_pop <- read.csv("population_by_country_2020.csv") %>%
      mutate(Country..or.dependency. = as.character(Country..or.dependency.)) %>%
      mutate(pop = Population..2020.)
    
    country_pop$Country..or.dependency.[3] <- "US"
    
    hopkins1 <- hopkins %>%
      filter(Date == "2021-10-25") %>%
      filter(!is.na(People_partially_vaccinated)) %>%
      filter(Country_Region != "US (Aggregate)") %>%
      filter(Country_Region != "World")
    
    hopkins_fully <- hopkins1 %>%
      arrange(desc(People_fully_vaccinated)) %>%
      slice(1:10)
    
    pop_hopkins_fully <- left_join(hopkins_fully, country_pop, by = c("Country_Region" = "Country..or.dependency.")) %>%
      mutate(fully_per_capita = People_fully_vaccinated / pop) %>%
      mutate(World.Share = gsub("%", "", World.Share, fixed = TRUE)) %>%
      mutate(World.Share = as.numeric(World.Share))
    
    ggplot(pop_hopkins_fully, aes(reorder(Country_Region, fully_per_capita), 

                                  fully_per_capita, fill = World.Share)) + 
      geom_bar(stat = "identity") +
      theme_classic() +
      labs(title = "Fully Vaccinated Rates Per Capita (Countries with Highest Number of Vaccines Distribued)", 
           subtitle = "Colored by % of World Population for Each Country", 
           y = "Fully Vaccinated Individuals per Capita",
           x = "Country")
    
    })
  
  
  output$globalvariants <- renderPlot ({ 
    setwd("~/covid-vaccines/CSVs")
    variants <- read.csv("covid-variants.csv")
    
    
    variants_date <- variants %>%
      mutate(year = year(as_date(date))) %>%
      mutate(month = month(as_date(date))) %>%
      mutate(day = day(as_date(date))) %>%
      filter(variant == "Alpha" | variant == "Delta" | variant == "Gamma" | variant == "Iota" | variant == "Beta" | variant == "Eta" | variant == "Lambda")
    
    
    variants_popular <- variants_date %>%
      filter(location == input$location) %>%
      group_by(variant, year, month) %>%
      summarise(
        n = sum(num_sequences, na.rm = TRUE)
      ) %>%
      mutate(month = as.factor(month)) %>%
      mutate(month_write = ifelse(month == 1, "Jan",
                                  ifelse(month == 2, "Feb",
                                         ifelse(month == 3, "Mar",
                                                ifelse(month == 4, "Apr",
                                                       ifelse(month == 5, "May",
                                                              ifelse(month == 6, "Jun",
                                                                     ifelse(month == 7, "Jul",
                                                                            ifelse(month == 8, "Aug",
                                                                                   ifelse(month == 9, "Sep",
                                                                                          ifelse(month == 10, "Oct",
                                                                                                 ifelse(month == 11, "Nov",
                                                                                                        ifelse(month == 12, "Dec", NA))))))))))))) %>%
      mutate(month_write = factor(month_write, levels = c("Dec", "Nov", "Oct", "Sep", "Aug", "Jul", "Jun", "May", "Apr", "Mar", "Feb", "Jan")))
    
    
    ggplot(variants_popular, aes(month_write, n, fill = variant)) +
      geom_bar(stat = "identity") +
      facet_wrap(~year) +
      coord_flip() +
      theme_classic() +
      labs(title = "Covid-19 Variant Prevelance By Year", y = "Relevant Prevelance", x = "Month", fill = "Variant")
    
    
    
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


