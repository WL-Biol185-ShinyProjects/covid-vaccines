library(shiny)
library(shinydashboard)


dashboardPage(skin = "blue",
              
              
  
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
    
      
      menuItem("Global", tabName = "Global", 
               icon = icon("globe", lib = "glyphicon")),
      
      menuItem("Variants", tabName = "Variants", 
               icon = icon("random", lib = "glyphicon")),
      
      menuItem("Socioeconomics", tabName = "Socioeconomics", 
               icon = icon("th")),
      
      menuItem("Population", tabName = "Population", 
               icon = icon("th")),
      menuItem("CDC Vaccine Info", icon = icon("file-code-o"),
                href = "https://www.cdc.gov/coronavirus/2019-ncov/vaccines/index.html")
    )
  ),
  
  
  dashboardBody(
    
    tabItems(
      
      tabItem(tabName = "Global",
              
            selectInput(
                "vaccine",
                "Manufacturer:",
                c("AstraZeneca" = "Oxford/AstraZeneca",
                  "Moderna" = "Moderna",
                  "Pfizer" = "Pfizer/BioNTech",
                  "Johnson&Johnson" = "JJ")
                
              ),
              
                    box(width = 12, globeOutput("globe")
                        ),
            p("your mother could never create a globe this dank")
                            ),
      
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
              
              box(width = 12,
                  fluidRow(
                    valueBoxOutput("CountryBox"),
                    
                    valueBoxOutput("VaccinatedBox"),
                    
                    valueBoxOutput("Predominant_VaccineBox")
                  ))),
      
      tabItem(tabName = "Population",
              
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