require(tidyr)
require(dplyr)
require(ggplot2)
require(reshape2)
#R workflow
bar_chart <- vehicles %>% select(TRANY, HIGHWAY08, CITY08) %>% subset(TRANY %in% c("Automatic 3-spd", "Automatic 4-spd","Automatic 5-spd","Automatic 6-spd","Automatic 6spd","Automatic 7-spd", "Automatic 8-spd", "Automatic 9-spd", "Manual 3-spd", "Manual 4-spd", "Manual 5-spd", "Manual 5 spd", "Manual 6-spd", "Manual 7-spd")) %>% group_by(TRANY) %>% summarise(avg_city_MPG = mean(CITY08), avg_highway_MPG = mean(HIGHWAY08)) %>% melt(id.vars = c("TRANY")) %>% group_by(variable) %>% mutate(WINDOW_AVG_MPG = mean(value))
#Plot Function to generate bar chart with reference line and values
ggplot() + 
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
