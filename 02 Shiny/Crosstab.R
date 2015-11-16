require(jsonlite)
require(RCurl)

# The following is equivalent to creat a crosstab with two KPIs in Tableau"
MPG_PV2_KPI_LOW = 1   
MPG_PV2_KPI_HIGH = 2
# The following is equivalent to creat a crosstab with two KPIs in Tableau"
crosstab <- vehicles %>% group_by(MAKE, YEAR) %>% summarize(sum_comb08 = sum(COMB08), sum_pv2 = sum(PV2),sum_pv4 = sum(PV4)) %>% mutate(ratio_1 = sum_comb08 / (sum_pv2))%>% mutate(ratio_2 = sum_comb08 / (sum_pv4)) %>% mutate(kpi_1 = ifelse(ratio_1 < MPG_PV2_KPI_LOW, '03 Not Efficient or Spacious', ifelse(ratio_1 <= MPG_PV2_KPI_HIGH, '02 Average Efficiency and Space', '01 Efficient and Spacious')))%>% mutate(kpi_2 = ifelse(ratio_2 < MPG_PV2_KPI_LOW, '03 Not Efficient or Spacious', ifelse(ratio_2 <= MPG_PV2_KPI_HIGH, '02 Average Efficiency and Space', '01 Efficient and Spacious'))) %>%filter(MAKE %in% c("Acura", "Aston Martin", "Audi", "Bentley", "BMW", "Buick", "Chevrolet", "Dodge", "Ferrari", "Ford", "Honda", "Kia", "Lincoln", "Lexus", "Maserati", "Mazda", "Mercedes-Benz", "Nissan", "Toyota", "Volkswagen")) %>% filter(ratio_1 != Inf, ratio_2 != Inf)

# This line turns the make and year columns into ordered factors.
crosstab <- crosstab %>% transform(MAKE = ordered(MAKE), YEAR = ordered(YEAR))

#This generates the PV4 with combined MPG plot
ggplot() +
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
#This generates the PV2 plot with combined MPG
ggplot() +
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
