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
      
      # dateRangeInput("daterange3", "Date range:",
      #                start  = "2020-08-01",
      #                end    = "2021-9-31",
      #                min    = "2020-08-01",
      #                max    = "2021-9-31",
      #                format = "mm/dd/yy",
      #                separator = " - "),
      
      menuItem("Global View", tabName = "Global View", 
               icon = icon("globe", lib = "glyphicon")),
      
      menuItem("Global Variants", tabName = "Variants by Country", 
               icon = icon("random", lib = "glyphicon")),
      
      menuItem("Vaccine and Wealth", tabName = "Vaccine and Wealth", 
               icon = icon("th")),
      
      menuItem("Continents", tabName = "Continents", 
               icon = icon("th"))
      # menuItem("CDC Vaccine Info", icon = icon("file-code-o"),
      #          href = "https://www.cdc.gov/coronavirus/2019-ncov/vaccines/index.html")
    )
  ),
  
  
  dashboardBody(
    
    tabItems(
      
      tabItem(tabName = "Global View",
              
              ),
      
      tabItem(tabName = "Variants by Country",
              
              fluidRow(
              
                box(globeOutput("pfizer_globe")))
              ),
      
      tabItem(tabName = "Vaccine and Wealth"),
      
      tabItem(tabName = "Continents")
    ),
    

    
    # tags$head( 
    #   tags$style(HTML('.main-sidebar {
    #     font-family: "Lucida Console", monospace;
    #     font-weight: bold;
    #     font-size: 14px; }'))
    # ),
    

    
    # fluidRow(
    # 
    #   valueBoxOutput("CountryBox"),
    # 
    #   valueBoxOutput("VaccinatedBox"),
    # 
    #   valueBoxOutput("Predominant_VaccineBox")
    # ),
    # 
    # fluidRow(
    #   
    #   box(width = 4, actionButton("count", "Increment progress"))
    # ),
    # 
    # fluidRow(
    #    box(width = 12, globeOutput("pfizer_globe"))
    # ),
    
    uiOutput("hearbeat")
    ),

    
  # tags$head(tags$style(HTML('
  #     .main-header .logo {
  #       font-family: "Lucida Console", monospace;
  #       font-weight: bold;
  #       font-size: 24px;
  #     }'
  # )))
  )