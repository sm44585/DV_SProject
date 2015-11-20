#ui.R 
require(shiny)
require(shinydashboard)
require(leaflet)

# Define UI for application that plots random distributions 
dashboardPage(
  dashboardHeader(title = "Project 6: EPA MPG Data Visualization", titleWidth = 400
  ),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Crosstab PV2", tabName = "PV2_Crosstab", icon = icon("th")),
      menuItem("Crosstab PV4", tabName = "PV4_Crosstab", icon = icon("th")),
      menuItem("Bar Chart", tabName = "Bar_Chart", icon = icon("bar-chart")),
      menuItem("Scatterplot", tabName = "Scatterplot", icon = icon("th")),
      menuItem("Refresh All Plots and Data", tabName = "Refresh", icon = icon("database"))
    )
  ),
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "PV2_Crosstab",
              sliderInput("PV2_KPILow", 
                          "Maximum Low Value for PV2 KPI:", 
                          min = 0,
                          max = 1, 
                          value = 1),
              #Slider for PV2 KPI2
              sliderInput("PV2_KPIHigh", 
                          "Maximum Medium Value for PV2 KPI:", 
                          min = 1, 
                          max = 2, 
                          value = 2),
              actionButton("PV2Plot", "Generate PV2 Crosstab Plot"),
              plotOutput("crosstabPV2Plot")
      ),
    tabItem(tabName = "PV4_Crosstab",
            sliderInput("PV4_KPILow", 
                        "Maximum Low Value for PV4 KPI:", 
                        min = 0,
                        max = 1, 
                        value = 1),
            #Slider for PV4 KPI2
            sliderInput("PV4_KPIHigh", 
                        "Maximum Medium Value for PV2 KPI:", 
                        min = 1,
                        max = 2, 
                        value = 2),
            actionButton("PV4Plot", "Generate PV4 Crosstab Plot"),
            plotOutput("crosstabPV4Plot")
            ),
    tabItem(tabName = "Bar_Chart",
            checkboxGroupInput(inputId = "TRANY",
                                label ="Transmission:",
                                choices = c("All", "Automatic 3-spd", "Automatic 4-spd","Automatic 5-spd","Automatic 6-spd","Automatic 6spd","Automatic 7-spd", "Automatic 8-spd", "Automatic 9-spd", "Manual 3-spd", "Manual 4-spd", "Manual 5-spd", "Manual 5 spd", "Manual 6-spd", "Manual 7-spd"), selected = "All", inline = TRUE
            ),
            #action button to generate bar chart plot
            actionButton("BarPlot", "Generate Bar Plot"),
            plotOutput("barchartPlot")
            ),
    tabItem(tabName = "Scatterplot",
            p("Note: if beginning year is greater than end year, the chart defaults to displaying all model years."),
            #data range slider for each year
            sliderInput("BEG_YEAR", 
                        "Pick a beginning year of model year:", 
                        min = 1985,
                        max = 2016, 
                        value = 1985,
                        step = 1,
                        sep = ""),
            sliderInput("END_YEAR", 
                        "Pick an end year of model year:", 
                        min = 1985,
                        max = 2016, 
                        value = 2016,
                        step = 1,
                        sep = ""),
            
            actionButton("ScatterPlot", "Generate Scatter Plot"),
            plotOutput("ScatterPlot")
            ),
    tabItem(tabName = "Refresh",
            #action button to generate plots
            br(),br(),
            p("If you want to change inputs for multiple charts but don't want to push each button to update the chart, click the button below to refresh all of the plots at once."),
            actionButton("refreshAll", "Refresh All Plots"),
            br(),br(),
            p("If you want to refresh the data from Oracle, click the button below"),
            actionButton("refreshData", "Refresh the Data")
    )
    )
))
