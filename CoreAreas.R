#This simple script helped me understand where the 7 core areas were located in my areas of study


#Set your working directory
setwd("/Users/snigdhasuvarna/Documents/SDG15/R_Try/CoreAreas")

#Install all the following packages
install.packages("mapview")
install.packages("rgdal")
install.packages("maptools")

library(mapview)
library(rgdal)
library(maptools)

#Use Mapview to showcase the 7 core areas used in my Circuitscape Analysis
SP <- readOGR("/Users/snigdhasuvarna/Documents/SDG15/R_Try/Natural_Areas")

spplot(SP, zcol="OBJECTID")
mapview(SP, zcol="OBJECTID")