#ui.R 

library(shiny)

# Define UI for application that plots random distributions 
shinyUI(pageWithSidebar(
  
  # Application title
  titlePanel("Project 6: Shiny app to display MPG data", windowTitle = "Project 6"),
  
  # Sidebar with a slider input for number of observations
  sidebarPanel(
    #PV2 Crosstab inputs
    h3("Crosstab sliders: 2 Door vehicle Passenger Volume"),
    #Slider for PV2 KPI1
    sliderInput("KPI1", 
                "KPI Low Max value:", 
                min = 0,
                max = 1, 
                value = 1),
    #Slider for PV2 KPI2
    sliderInput("KPI2", 
                "KPI Medium Max value:", 
                min = 1,
                max = 2, 
                value = 2),
    #PV4 Crosstab inputs
    
    #Bar Chart inputs
    h3("Bar Chart filter: City and Highway MPG for each transmission"),
    #Checkbox for filtering transmission
    checkboxGroupInput("TRANY",
      "Transmission:",
      c("All", "Automatic 3-spd", "Automatic 4-spd","Automatic 5-spd","Automatic 6-spd","Automatic 6spd","Automatic 7-spd", "Automatic 8-spd", "Automatic 9-spd", "Manual 3-spd", "Manual 4-spd", "Manual 5-spd", "Manual 5 spd", "Manual 6-spd", "Manual 7-spd"), "All"
    ),
    
    #action button to generate plots
    p("Click the button to Generate the plots."),
    actionButton("redoPlot", "Generate Plot")
    ),
  
  # Show a plot of the generated distribution
  mainPanel(
    plotOutput("crosstabPV2Plot"),
    plotOutput("barchartPlot")
  )
))
