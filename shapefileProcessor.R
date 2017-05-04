### @author      Alexander Elton-Pym aelt7654@uni.sydney.edu.au
### @version     1.0     
### requires rgdal, rgeos and sp packages

#read shapefile
aus = readOGR(".", "SUA_2011_AUST")

#review shapefile
summary(aus)
plot(aus, axes=TRUE)

#calculate and save centroids
centroids = gCentroid(aus, byid=TRUE)
write.csv(centroids, file = "centroids.csv")