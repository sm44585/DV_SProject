#ui.R 
library(shiny)

# Define UI for application that plots random distributions 
shinyUI(pageWithSidebar(
  
  # Application title
  titlePanel("Project 6: Shiny app to display MPG data", windowTitle = "Project 6"),
  # Sidebar with a slider input for number of observations
  sidebarPanel(
    #PV2 Crosstab 
    h3("Crosstab sliders: 2 Door vehicle Passenger Volume"),
    #Slider for PV2 KPI1
    sliderInput("PV2_KPILow", 
                "KPI Low Max value_2:", 
                min = 0,
                max = 1, 
                value = 1),
    #Slider for PV2 KPI2
    sliderInput("PV2_KPIHigh", 
                "KPI Medium Max value_2:", 
                min = 1,
                max = 2, 
                value = 2),
    actionButton("PV2Plot", "Generate PV2 Crosstab Plot"),
    
    #PV4 Crosstab 
    h3("Crosstab sliders: 4 Door vehicle Passenger Volume"),
    #Slider for PV4 KPI1
    sliderInput("PV4_KPILow", 
                "KPI Low Max value:", 
                min = 0,
                max = 1, 
                value = 1),
    #Slider for PV4 KPI2
    sliderInput("PV4_KPIHigh", 
                "KPI Medium Max value:", 
                min = 1,
                max = 2, 
                value = 2),
    actionButton("PV4Plot", "Generate PV4 Crosstab Plot"),
    
    #Bar Chart 
    h3("Bar Chart filter: City and Highway MPG for each transmission"),
    #Checkbox for filtering transmission
    checkboxGroupInput("TRANY",
      "Transmission:",
      c("All", "Automatic 3-spd", "Automatic 4-spd","Automatic 5-spd","Automatic 6-spd","Automatic 6spd","Automatic 7-spd", "Automatic 8-spd", "Automatic 9-spd", "Manual 3-spd", "Manual 4-spd", "Manual 5-spd", "Manual 5 spd", "Manual 6-spd", "Manual 7-spd"), "All"
    ),
    #action button to generate bar chart plot
    actionButton("BarPlot", "Generate Bar Plot"),
    
    #Scatter plot 
    h3("Scatter plot selector: City and Highway MPG for each model year"),
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
    #action button to generate plots
    br(),br(),
    p("If you want to change inputs for multiple charts but don't want to push each button to update the chart, click the button below to refresh all of the plots at once."),
    actionButton("refreshAll", "Refresh All Plots"),
    br(),br(),
    p("If you want to refresh the data from Oracle, click the button below"),
    actionButton("refreshData", "Refresh the Data")
    ),
  
  # Show a plot of the generated distribution
  mainPanel(
    plotOutput("crosstabPV2Plot"),
    plotOutput("crosstabPV4Plot"),
    plotOutput("barchartPlot"),
    plotOutput("ScatterPlot")
    
  )
))
