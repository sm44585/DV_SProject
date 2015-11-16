require("jsonlite")
require("RCurl")

# Loads the data from Vehicle data set into the Vehicle dataframe
# Change the USER and PASS below to be your UTEid
vehicles <- data.frame(fromJSON(getURL(URLencode('skipper.cs.utexas.edu:5001/rest/native/?query="select ATVTYPE,BARRELS08,BARRELSA08,CITY08,CITYA08,CO2TAILPIPEAGPM,CO2TAILPIPEGPM,COMB08,COMBA08,CYLINDERS,FUELCOST08,FUELCOSTA08,FUELTYPE,FUELTYPE1,FUELTYPE2,HIGHWAY08,HIGHWAYA08,HLV,HPV,LV2,LV4,MPGDATA,PV2,PV4,YEAR,MAKE from VEHICLES"'),httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_sm44585', PASS='orcl_sm44585', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE),))

summary(vehicles)
