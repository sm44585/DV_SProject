# server.R
require(jsonlite)
require(RCurl)
require(ggplot2)
require(dplyr)
require(shiny)

shinyServer(function(input, output) {
  
  output$distPlot <- renderPlot({
    # Start your code here.
    
    MPG_PV2_KPI_LOW = input$KPI1   
    MPG_PV2_KPI_HIGH = input$KPI2
    # Loads the data from Vehicle data set into the Vehicle dataframe
    # Change the USER and PASS below to be your UTEid
vehicles <- data.frame(fromJSON(getURL(URLencode('skipper.cs.utexas.edu:5001/rest/native/?query="select ATVTYPE,BARRELS08,BARRELSA08,CITY08,CITYA08,CO2TAILPIPEAGPM,CO2TAILPIPEGPM,COMB08,COMBA08,CYLINDERS,FUELCOST08,FUELCOSTA08,FUELTYPE,FUELTYPE1,FUELTYPE2,HIGHWAY08,HIGHWAYA08,HLV,HPV,LV2,LV4,MPGDATA,PV2,PV4,YEAR,MAKE from VEHICLES"'),httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_sm44585', PASS='orcl_sm44585', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE),))
    # The following is equivalent to creat a crosstab with two KPIs in Tableau"
    crosstab <- vehicles %>% group_by(MAKE, YEAR) %>% summarize(sum_comb08 = sum(COMB08), sum_pv2 = sum(PV2),sum_pv4 = sum(PV4)) %>% mutate(ratio_1 = sum_comb08 / (sum_pv2))%>% mutate(ratio_2 = sum_comb08 / (sum_pv4)) %>% mutate(kpi_1 = ifelse(ratio_1 < MPG_PV2_KPI_LOW, '03 Not Efficient or Spacious', ifelse(ratio_1 <= MPG_PV2_KPI_HIGH, '02 Average Efficiency and Space', '01 Efficient and Spacious')))%>% mutate(kpi_2 = ifelse(ratio_2 < MPG_PV2_KPI_LOW, '03 Not Efficient or Spacious', ifelse(ratio_2 <= MPG_PV2_KPI_HIGH, '02 Average Efficiency and Space', '01 Efficient and Spacious'))) %>%filter(MAKE %in% c("Acura", "Aston Martin", "Audi", "Bentley", "BMW", "Buick", "Chevrolet", "Dodge", "Ferrari", "Ford", "Honda", "Kia", "Lincoln", "Lexus", "Maserati", "Mazda", "Mercedes-Benz", "Nissan", "Toyota", "Volkswagen")) %>% filter(ratio_1 != Inf, ratio_2 != Inf)
    
    # This line turns the make and year columns into ordered factors.
    crosstab <- crosstab %>% transform(MAKE = ordered(MAKE), YEAR = ordered(YEAR))
    
    #This generates the PV4 with combined MPG plot
plot <-ggplot() +
      coord_cartesian() + 
      scale_x_discrete() +
      scale_y_discrete() +
      labs(title='Vehicle Crosstab of Efficiency/Space ratio for 4 door cars') +
      labs(x=paste("Make"), y=paste("Year")) +
      layer(data=crosstab, 
            mapping=aes(x=MAKE, y=YEAR, label=round(ratio_2, 2)), 
            stat="identity", 
            stat_params=list(), 
            geom="text",
            geom_params=list(colour="black"), 
            position=position_identity()
      ) +
      layer(data=crosstab, 
            mapping=aes(x=MAKE, y=YEAR, fill=kpi_2), 
            stat="identity", 
            stat_params=list(), 
            geom="tile",
            geom_params=list(alpha=0.50), 
            position=position_identity()
      ) 
    # End your code here.
    return(plot)
  })
})
