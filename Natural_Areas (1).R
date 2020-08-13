setwd("/Users/snigdhasuvarna/Documents/SDG15/R_Try")

#Install packages
install.packages("ggplot2")
install.packages("rgdal")
install.packages("sf")
install.packages("sp")
install.packages("tidyverse")

#libraries
library(ggplot2)
library(rgdal)
library(sf)
library(sp)
library(tidyverse)

#import for sf
na <- st_read("/Users/snigdhasuvarna/Documents/SDG15/R_Try/Meff_NA")
na

#Plot all the Natural Areas in LA
plot(na, max.plot = 1, col="darkgreen")

#Transform the Coordinate System (CRS) to a Non-Long/Lat version of WGS84
naproject <- st_transform(na,crs = 32610)
naproject

#Add a ~2 KM Buffer?? around each unique feature layer
buffer <- st_buffer(naproject, dist = 2000) #This is the modified buffer used to run this large dataset
buffer <- st_buffer(naproject, dist = 0.02) #This buffer is most likely 2km
buffer

#Plot all the Buffered Natural Areas in LA
plot(buffer, max.plot = 1, col= "darkgreen")

#Create an intersection matrix using the intersection tool
mx <- st_intersects(buffer,buffer)
mx

#Dissolve the polygons that don't intersect with each other
mxlists<-list()

uniques<-list()
keeps<-list()

for(j in 1:length(mx)){
	mxlists[[j]]<-unlist(mx[[j]])

for(i in 1:length(mx)){
	uniques[i]<-any(mx[[i]]%in%mxlists[[j]])
	keeps[[j]]<-which(uniques==FALSE)
						}
	}

uniques<-unlist(uniques)
mxKeeps<-buffer[keeps[[1]],]


endUniques<-list()
endKeeps<-list()

for(i in 1:length(keeps)){
endUniques[[i]]<-keeps[[1]][1]%in%keeps[[i]]
endKeeps<-buffer[endUniques==TRUE,]
}

keeps[[1]][1]%in%keeps[[2]]
endUniques<-unlist(endUniques)

polys<-list()

for(i in 1:length(mx)){
	polys[[i]]<-st_union(buffer[mx[i][[1]],])
	cat(i,",","of",length(mx),"\n")
}

poly1<-st_union(buffer[mx[1][[1]],])

plot(poly1,lwd=4,add=FALSE)

for(i in 1:length(polys)){
plot(polys[[i]],lwd=0.05,add=TRUE,border="red")
}

plot(poly1,lwd=4,add=TRUE)

#Save Plot as a PDF
pdf("~/Desktop/PolgyonPlots.pdf")
plot(poly1,lwd=4,add=FALSE)

for(i in 1:length(polys)){
plot(polys[[i]],lwd=0.05,add=TRUE,border="red")
}

plot(poly1,lwd=4,add=TRUE)

dev.off()

#Save Plot as a JPG
jpeg("~/Desktop/PolgyonPlots.jpg")
plot(poly1,lwd=4,add=FALSE)

for(i in 1:length(polys)){
plot(polys[[i]],lwd=0.05,add=TRUE,border="red")
}

plot(poly1,lwd=4,add=TRUE)

dev.off()

#Intersect the Original Map Buffered map (buffer) and the newly Dissolved Map (poly1)
union <- st_union(buffer, poly1)
union

#Get the Areas of the Polygons 
PID <- union[, c("OBJECTID"), drop=FALSE] 
Area <- union[, c("Shape_Area"), drop=FALSE]
Area2 <- union$Shape_Area^2

#Create a Data Frame
df <- data.frame(c(Area),
                 c(PID),
                 c(Area2))
head(df)
names(df)

#Intra_Connectivity Calculation
sum_Shape_Area <- sum(df$Shape_Area)
sum_c.Area2 <- sum(df$c.Area2)
Intra <- sum_c.Area2/sum_Shape_Area 
Intra

# Due to time constraints I was only able to create a script up till the...
#Intra_Connectivity Calculations. I highly encourage the next round of researchers to continue this working script. 



