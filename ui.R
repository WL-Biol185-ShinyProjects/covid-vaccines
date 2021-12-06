library(shinydashboard)
library(shiny)
library(utils)
library(tidyverse)
library(threejs)
library(maptools)
library(maps)
library(writexl) 
library(lubridate)
library(ggplot2)
library(tidyr)
library(tibble)
library(dplyr)
library(rgdal)
library(RColorBrewer)
library(leaflet)

dashboardPage(skin = "green",
              
              
  
  dashboardHeader(
    title = p("COVID-19 Global Vaccination", style = "color: aqua;"),
    titleWidth = 450, 
  
            dropdownMenu(type = "messages",
               messageItem(
                 from = "The Creators",
                 message = "Emma, Katie, and Jack made this"))),
  

  dashboardSidebar(
    
    a(href = "https://www.cdc.gov/coronavirus/2019-ncov/vaccines/index.html"),  
 
    sidebarMenu(
      
      menuItem("Home", tabName = "Home", 
               icon = icon("globe", lib = "glyphicon")),
      
      menuItem("Variants", tabName = "Variants", 
               icon = icon("random", lib = "glyphicon")),
      
      menuItem("Socioeconomics", tabName = "Socioeconomics", 
               icon = icon("usd")),
      
      menuItem("Population", tabName = "Population", 
               icon = icon("user")),
      
      menuItem("CDC Vaccine Info", icon = icon("file-code-o"),
                href = "https://www.cdc.gov/coronavirus/2019-ncov/vaccines/index.html")
    )
  ),
  
  
  dashboardBody(
    
    tags$head(tags$style(HTML('.content-wrapper { overflow: auto; }'))),
    
    tabItems(
      
      tabItem(tabName = "Home",
              
             p(strong("Welcome to the Covid Vaccine Information Hub, please click
                      on the tabs to explore"), align = "center"),
             
             
             box(width = 12,
              p("The interactive globe below displays the relative number of vaccines 
              distributed to each country specific to a vaccine manufacturers.  
              Use the interactive drop-down menu to explore different globes for the vaccine 
              manufacturers of interest. The spike location on the globe rests at the capital 
              of the country. 
              Countries with no spikes indicate missing data, not zero vaccines distributed")),
           
  
            selectInput(
                "vaccine",
                "Manufacturer:",
                c("AstraZeneca" = "Oxford/AstraZeneca",
                  "Moderna" = "Moderna",
                  "Pfizer" = "Pfizer/BioNTech",
                  "Johnson&Johnson" = "JJ")
                
              ),
              
                    box(width = 12, globeOutput("globe")
                        )),
      
      tabItem(tabName = "Variants",
              
                box(width = 12, 
                p("As the pandemic continues to evolve, different 
                                   variants of COVID-19 have emerged. The graph above 
                                   shows the timeline of when these specific variants emerged 
                                   in the country of choice. Use the interactive drop-down menu in 
                                   order to compare the differences inwhen variants emerged in 
                                   countries over 2020 to 2021 timeline. 
                                   As you explore, please note
                                   the Delta variant of COVID-19 is the most recent prolific variant and 
                                   the data is as of October 25th, 2021" )),
                
                box(width = 12, plotOutput("globalvariants")),
                
                selectInput(
                  "location",
                  "country",
                  c("Angola",
                     "Argentina",
                     "Aruba",
                     "Australia",
                     "Austria",
                     "Bahrain",
                     "Bangladesh",
                     "Belgium",
                     "Botswana",
                     "Brazil",
                     "Bulgaria",
                     "Cambodia",
                     "Canada",
                     "Chile",
                     "China",
                     "Colombia",
                     "Costa Rica",
                     "Croatia",
                     "Curacao",
                     "Czechia",
                     "Denmark",
                     "Ecuador",
                     "Estonia",
                     "Finland",
                     "France",
                     "Gambia",
                     "Germany",
                     "Ghana",
                     "Greece",
                     "Hong Kong",
                     "Hungary",
                     "Iceland",
                     "India",
                     "Indonesia",
                     "Iraq",
                     "Ireland",
                     "Israel",
                     "Italy",
                     "Jamaica",
                     "Japan",
                     "Jordan",
                     "Kazakhstan",
                     "Kenya",
                     "Kuwait",
                     "Latvia",
                     "Lebanon",
                     "Lithuania",
                     "Luxembourg",
                     "Malawi",
                     "Malaysia",
                     "Malta",
                     "Mexico",
                     "Mozambique",
                     "Nepal",
                     "Netherlands",
                     "New Zealand",
                     "Nigeria",
                     "North Macedonia",
                     "Norway",
                     "Pakistan",
                     "Peru",
                     "Philippines",
                     "Poland",
                     "Portugal",
                     "Qatar",
                     "Romania",
                     "Russia",
                     "Rwanda",
                     "Singapore",
                     "Sint Maarten (Dutch part)",
                     "Slovakia",
                     "Slovenia",
                     "South Africa",
                     "South Korea",
                     "Spain",
                     "Sri Lanka",
                     "Suriname",
                     "Sweden",
                     "Switzerland",
                     "Thailand",
                     "Trinidad and Tobago",
                     "Turkey",
                     "Uganda",
                     "Ukraine",
                     "United Kingdom",
                     "United States",
                     "Uruguay",
                     "Zambia",
                     "Zimbabwe")
                  )
                
              ),
      
      tabItem(tabName = "Socioeconomics",
              
              box(width = 12,
              p("The data maniputlated on this page is intended to illustrate
                        disparities between vaccination rates across countries in different 
                        socioeconmic standings. We hope these
                        graphical displays accuratly display this global issue.")),
              
              box(width = 12, plotOutput("socioeconomicsbox")),
              
              box(width = 4,
                  selectInput(
                    "Country",
                    "Country:",
                    c("Uganda" = "Uganda",
                      "Togo" = "Togo",
                      "Switzerland" = "Switzerland",
                      "Sweden" = "Sweden",
                      "Singapore" = "Singapore",
                      "Sierra Leone" = "Sierra Leone",
                      "Rwanda" = "Rwanda",
                      "Qatar" = "Qatar",
                      "Norway" = "Norway",
                      "Mozambique" = "Mozambique",
                      "Mali" = "Mali",
                      "Malawi" = "Malawi",
                      "Luxembourg" = "Luxembourg",
                      "Ireland" = "Ireland",
                      "Iceland" = "Iceland",
                      "Gambia" = "Gambia",
                      "Ethiopia" = "Ethiopia",
                      "Denmark" = "Denmark",
                      "Afghanistan" = "Afghanistan")
                    
                  )),
              
              box(width = 12,
                  fluidRow(
                    
                    valueBoxOutput("CountryBox"),
                    
                    valueBoxOutput("VaccinatedBox"),
                    
                    valueBoxOutput("Predominant_VaccineBox")
                  ))),
      
      tabItem(tabName = "Population",
              
              box(width = 12,
                  p("The below panels show an interactive map of the percent of 
                    people fully vaccinated and percent partially vaccinated across 
                    the globe. Note that partially vaccinated individuals include fully 
                    vaccinated individuals. Click on each country to view its statistics")),
              
              box(width = 12, leafletOutput("PercentVaccinatedHeatMap")),
              
              box(width = 12, leafletOutput("PartiallyVaccinatedHeatmap")),
              
              box(width = 12, 
                  p("The graph below shows the top 10 countries with the highest 
                    number of fully vaccinated individuals in the world. More specifically, 
                    the bars for each country show the rate of fully vaccinated individuals 
                    per capita. The color of the bar indicates how much of the world population 
                    that individual country contributes. The population data for each country 
                    comes from a 2020 population dataset.                       Creator Analysis: As the creators of this visualization, 
                    we found it extremely interesting that even though China and 
                    India equivalent and large portions of the world populations, 
                    they are at polar opposite sides of vaccine distributions per capita, 
                    with China recording the highest vaccine distributed per capita and India 
                    reporting the lowest. This leads to global questions such as accuracy in 
                    reporting data, access to life saving vaccines, and other barriers that may 
                    distinguish these countries")),
              
              box(width = 12, plotOutput("percapita"))
              )
      
    ),
    

    
    tags$head(
      tags$style(HTML('.main-sidebar {
        font-family: "Lucida Console", monospace;
        font-weight: bold;
        font-size: 14px; }'))
    ),
    
    
    uiOutput("hearbeat")
    ),


  tags$head(tags$style(HTML('
       .main-header .logo {
         font-family: "Lucida Console", monospace;
         font-weight: bold;
         font-size: 24px;
       }'
   )))
  )