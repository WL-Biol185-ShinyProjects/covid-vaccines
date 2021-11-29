library(shiny)
library(shinydashboard)


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
               icon = icon("home", lib = "glyphicon")),
      
      menuItem("Global", tabName = "Global", 
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
    
    tabItems(
      
      tabItem(tabName = "Home",
              
      
              h1("Covid-19 Vaccines and Variants", align = "center"),
              h2("Informational WebPage By:", align = "center"),
              h3("Katie Kern, Jack Donahue, Emma Aldrige", align = "center"),
              
              #insert fluid row here 
              img(src = "covid-info.png", height = 800, width = 500, style = "display: block; margin-left; auto; margin-right: auto;")),
              
      
      tabItem(tabName = "Global",
              
            p(strong("|The interactive globe above displays the relative number of vaccines distributed to each country specific to a vaccine manufacturers.  Use the interactive drop-down menu to explore different globes for the vaccine manufacturers of interest. The spike location on the globe rests at the capital of the country. 
              Countries with no spikes indicate missing data, not zero vaccines distributed|")),
  
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
              
              p(strong("The data maniputlated on this page is intended to illustrate
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
              
              box(width = 12, leafletOutput("PercentVaccinatedHeatMap")),
              
              box(width = 12, leafletOutput("PartiallyVaccinatedHeatmap")),
              
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