# server.R
require(jsonlite)
require(RCurl)
require(ggplot2)
require(dplyr)
require(reshape2)
require(shiny)

shinyServer(function(input, output) {
  #Code to generate data frame
  vehicles <- eventReactive(c(input$redoPlot), {
    vehicles <- data.frame(fromJSON(getURL(URLencode('skipper.cs.utexas.edu:5001/rest/native/?query="select ATVTYPE,BARRELS08,BARRELSA08,CITY08,CITYA08,CO2TAILPIPEAGPM,CO2TAILPIPEGPM,COMB08,COMBA08,CYLINDERS,FUELCOST08,FUELCOSTA08,FUELTYPE,FUELTYPE1,FUELTYPE2,HIGHWAY08,HIGHWAYA08,HLV,HPV,LV2,LV4,MPGDATA,PV2,PV4,YEAR,MAKE,TRANY from VEHICLES"'),httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_sm44585', PASS='orcl_sm44585', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE)))
  }, ignoreNULL = FALSE)
  
  #Code that generates reactive transmission filter for the bar chart.
  trans_filter <- eventReactive(input$BarPlot, {
    if (input$TRANY == "All"){
      trans_filter = c("Automatic 3-spd", "Automatic 4-spd","Automatic 5-spd","Automatic 6-spd","Automatic 6spd","Automatic 7-spd", "Automatic 8-spd", "Automatic 9-spd", "Manual 3-spd", "Manual 4-spd", "Manual 5-spd", "Manual 5 spd", "Manual 6-spd", "Manual 7-spd")
    }
    else {
      trans_filter = input$TRANY
    }
    }, ignoreNULL = FALSE)
  
  #Code that generate reactive year selector for the scatter plot.
  year_selector <- eventReactive(input$ScatterPlot, {
    if 
  }
  
  #Code that generates reactive KPI inputs for the PV4 crosstab
  MPG_PV2_KPI_LOW <- eventReactive(c(input$redoPlot,  input$PV4Plot), {MPG_PV2_KPI_LOW = input$KPI1}, ignoreNULL = FALSE)   
  MPG_PV2_KPI_HIGH <- eventReactive(c(input$redoPlot, input$PV4Plot), {MPG_PV2_KPI_HIGH = input$KPI2}, ignoreNULL = FALSE)
  
  #Code that generates reactive KPI inputs for the PV2 crosstab
  MPG_PV2_KPI_LOW_2 <- eventReactive(c(input$redoPlot, input$PV2Plot), {MPG_PV2_KPI_LOW_2 = input$KPI1_2}, ignoreNULL = FALSE)   
  MPG_PV2_KPI_HIGH_2 <- eventReactive(c(input$redoPlot, input$PV2Plot), {MPG_PV2_KPI_HIGH_2 = input$KPI2_2}, ignoreNULL = FALSE)
  
  #Code to generate PV4 Crosstab plot
  output$crosstabPV4Plot <- renderPlot({
    crosstab <- vehicles() %>% group_by(MAKE, YEAR) %>% summarize(sum_comb08 = sum(COMB08), sum_pv2 = sum(PV2),sum_pv4 = sum(PV4)) %>% mutate(ratio_1 = sum_comb08 / (sum_pv2))%>% mutate(ratio_2 = sum_comb08 / (sum_pv4)) %>% mutate(kpi_1 = ifelse(ratio_1 < MPG_PV2_KPI_LOW(), '03 Not Efficient or Spacious', ifelse(ratio_1 <= MPG_PV2_KPI_HIGH(), '02 Average Efficiency and Space', '01 Efficient and Spacious')))%>% mutate(kpi_2 = ifelse(ratio_2 < MPG_PV2_KPI_LOW(), '03 Not Efficient or Spacious', ifelse(ratio_2 <= MPG_PV2_KPI_HIGH(), '02 Average Efficiency and Space', '01 Efficient and Spacious'))) %>%filter(MAKE %in% c("Acura", "Aston Martin", "Audi", "Bentley", "BMW", "Buick", "Chevrolet", "Dodge", "Ferrari", "Ford", "Honda", "Kia", "Lincoln", "Lexus", "Maserati", "Mazda", "Mercedes-Benz", "Nissan", "Toyota", "Volkswagen")) %>% filter(ratio_1 != Inf, ratio_2 != Inf)
    
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
  
  #Code to generate PV2 Crosstab plot
  output$crosstabPV2Plot <- renderPlot({
    crosstab <- vehicles() %>% group_by(MAKE, YEAR) %>% summarize(sum_comb08 = sum(COMB08), sum_pv2 = sum(PV2),sum_pv4 = sum(PV4)) %>% mutate(ratio_1 = sum_comb08 / (sum_pv2))%>% mutate(ratio_2 = sum_comb08 / (sum_pv4)) %>% mutate(kpi_1 = ifelse(ratio_1 < MPG_PV2_KPI_LOW(), '03 Not Efficient or Spacious', ifelse(ratio_1 <= MPG_PV2_KPI_HIGH(), '02 Average Efficiency and Space', '01 Efficient and Spacious')))%>% mutate(kpi_2 = ifelse(ratio_2 < MPG_PV2_KPI_LOW(), '03 Not Efficient or Spacious', ifelse(ratio_2 <= MPG_PV2_KPI_HIGH(), '02 Average Efficiency and Space', '01 Efficient and Spacious'))) %>%filter(MAKE %in% c("Acura", "Aston Martin", "Audi", "Bentley", "BMW", "Buick", "Chevrolet", "Dodge", "Ferrari", "Ford", "Honda", "Kia", "Lincoln", "Lexus", "Maserati", "Mazda", "Mercedes-Benz", "Nissan", "Toyota", "Volkswagen")) %>% filter(ratio_1 != Inf, ratio_2 != Inf)
    
    # This line turns the make and year columns into ordered factors.
    crosstab <- crosstab %>% transform(MAKE = ordered(MAKE), YEAR = ordered(YEAR))
    
    #This generates the PV4 with combined MPG plot
    plot <-ggplot() +
      coord_cartesian() + 
      scale_x_discrete() +
      scale_y_discrete() +
      labs(title='Vehicle Crosstab of Efficiency/Space ratio for 2 door cars') +
      labs(x=paste("Make"), y=paste("Year")) +
      layer(data=crosstab, 
            mapping=aes(x=MAKE, y=YEAR, label=round(ratio_1, 2)), 
            stat="identity", 
            stat_params=list(), 
            geom="text",
            geom_params=list(colour="black"), 
            position=position_identity()
      ) +
      layer(data=crosstab, 
            mapping=aes(x=MAKE, y=YEAR, fill=kpi_1), 
            stat="identity", 
            stat_params=list(), 
            geom="tile",
            geom_params=list(alpha=0.50), 
            position=position_identity()
      ) 
    # End your code here.
    return(plot)
  })
  
  #Code to generate Bar Chart Plot
  output$barchartPlot <- renderPlot({
    bar_chart <- vehicles() %>% select(TRANY, HIGHWAY08, CITY08) %>% subset(TRANY %in% trans_filter()) %>% group_by(TRANY) %>% summarise(avg_city_MPG = mean(CITY08), avg_highway_MPG = mean(HIGHWAY08)) %>% melt(id.vars = c("TRANY")) %>% group_by(variable) %>% mutate(WINDOW_AVG_MPG = mean(value))
      #Plot Function to generate bar chart with reference line and values
      plot <- ggplot() + 
      coord_cartesian() + 
      scale_x_discrete() +
      scale_y_continuous() +
      facet_wrap(~variable) +
      labs(title='Average Highway and City MPG based on transmission ') +
      labs(x=paste("Transmission"), y=paste("MPG")) +
      layer(data=bar_chart, 
            mapping=aes(x=TRANY, y=value), 
            stat="identity", 
            stat_params=list(), 
            geom="bar",
            geom_params=list(colour="blue", fill="white"), 
            position=position_dodge()
      ) + coord_flip() + 
      layer(data=bar_chart, 
            mapping=aes(x=TRANY, y=value, label=round(WINDOW_AVG_MPG, 2)), 
            stat="identity", 
            stat_params=list(), 
            geom="text",
            geom_params=list(colour="black", hjust=2), 
            position=position_identity()
      ) +
      layer(data=bar_chart, 
            mapping=aes(yintercept = WINDOW_AVG_MPG), 
            geom="hline",
            geom_params=list(colour="red")
      ) +
      layer(data=bar_chart, 
            mapping=aes(x=TRANY, y=value, label=round(value, 2)), 
            stat="identity", 
            stat_params=list(), 
            geom="text",
            geom_params=list(colour="black", hjust=0), 
            position=position_identity()
      )
    return(plot)
  })
  #Code to generate the scatter plot
  output$ScatterPlot <- renderPlot({
    scatterplot <- vehicles() %>% select(COMB08, YEAR) %>% transform(YEAR = as.Date(as.character(YEAR), "%Y"))
    plot <- ggplot() +
      coord_cartesian() + 
      scale_x_date() +
      scale_y_continuous() +
      labs(title="Combined MPG of every model year") +
      labs(x="Year", y="Combined MPG") +
      layer(data=scatterplot , 
            mapping=aes(x=YEAR, y=COMB08),
            stat="identity",
            stat_params=list(), 
            geom="point",
            geom_params=list(), 
            position=position_identity()
      )
    return(plot)
  })
})
