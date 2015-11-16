# This file creates the scatterplot.
require(tidyr)
require(dplyr)
require(ggplot2)

# This selects only the comb08 and year columns whilte transforming the year column to a date
scatterplot <- vehicles %>% select(COMB08, YEAR) %>% transform(YEAR = as.Date(as.character(YEAR), "%Y"))

ggplot() +
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
