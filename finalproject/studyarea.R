#Sedi Ghiasi
#LA588
#Prof,Seeger
#Final project-spring 2023


#------study area---------
#required packages

install.packages(c("leaflet","sp"))
library(leaflet)
library(sp)

#A circle in the study area to highlight it
# setting coordinates for center of circle
center <- c(lon = -93.6091, lat = 41.6005)

#  radius of circle in meters
radius <- 100

# creating a leaflet map centered on Des Moines
des_moines_map <- leaflet() %>% 
  setView(lng = center[1], lat = center[2], zoom = 11) %>% 
  addCircleMarkers(lng = center[1], lat = center[2], radius = radius, fillColor = "darkgreen", fillOpacity = 0.3, stroke = FALSE) %>% 
  addTiles()

# printing the map
des_moines_map





#---weather file---------

#required packages
install.packages("ggplot2")
#library(magrittr)

#the initial data set had to many columns, i needed to clean it, so i dropped all columns except, "temp" and "datetime".
weatherfile_messy <- read.csv("weatherfile.csv")
#removing unnecessary columns
weatherfile <- weatherfile_messy[, c("datetime", "temp")]
#the current data set has temperature per day, we want to calculate average temp of each month 

library(dplyr)
library(lubridate)


#the current data set has temperature as text, we want to convert it to date format
weatherfile$datetime <- as.Date(weatherfile$datetime, format = "%Y-%m-%d")
#adding a new column for month
weatherfile <- mutate(weatherfile, Month = month(datetime, label = TRUE)) %>% 
  select(-datetime) %>%
  group_by(Month) %>% 
  summarize(Avg_Temperature = mean(temp)) #avg temp per month


#save the excel file to use in tableau

install.packages("openxlsx")
library(openxlsx)
write.xlsx(weatherfile,"weatehrfile.xlsx")
#Plot the ggraph tem per month
install.packages("ggplot2") 
library(ggplot2)

ggplot(data = weatherfile, aes(x = Month, y = Avg_Temperature)) +
  geom_bar(stat = "identity", fill = "darkgreen") +
  labs(title = "Average temperature per month", x = "Month", y = "Temperature (°C)") +
  theme(plot.title = element_text(hjust = 0.5, size = 14, face = "bold", color = "black"))




#--------plotting buildings based on their height------
install.packages("sf")
library(sf)
shapefile <- read_sf("building.shp")

# Plot the shapefile with building height
plot(shapefile["BuildingHe"])


# After considering my options, I have decided to change my approach and create a visualization of the data using Tableau, instead of using R to create a plot




# Load packages
install.packages("sf")
library(sf)
library(raster)

# Load shapefile and raster

tree <- raster("tree.tif")
building_excel<- read.csv("zonal_building.csv")
tree_excel<-read.csv("zonal_tree.csv")
grid <- st_read("gird_400.shp")
names(building_excel)

# join the shapefile and the table based on a common FID column
merged_data <- merge(grid, tree_excel, by.x = "FId", by.y = "FID")

#error:it said it cannot find FID in the shape file 
#then i checked the colmns name in both files
#head(grid$FID)
#names(grid)
# here is the solution: the objects in shapefile had FID column which is an identifier in Arc GIS pro.
#after reading a shapefile using the st_read() function from the sf package in R, the FID column get disappeared, as it is not a required attribute of the shapefile format.
#so i had to create an equivalent column to solve the problem using id=FID. 

merged_data <- merge(grid, tree_excel, by.x = "Id", by.y = "FID")

merged_data2 <- merge(merged_data, building_excel, by.x = "Id", by.y = "FID")

names(merged_data2 )
plot(merged_data2)
names(merged_data)
st_write(merged_data, "tree_coverage.shp")
st_write(merged_data2,"building_coverage.shp")

# Performing the intersection to cut the unnecessary grids
cut<-st_read("neighborhoods.shp")
clipped <- st_intersection(merged_data2, cut)

# Save the clipped shapefile
st_write(clipped, "outputclip.shp")
library(raster)
library(sf)
#---calculating percentage of trees in each grid#-----
# Clip the shapefile to the boundary
# Clip the shapefile to the boundary


# Calculate new fields using dplyr
clipped <- clipped %>% 
  mutate(FAR = (AREA_b * 90000)/100,
        Tree_Height= MEAN,
        bUilding_Height= MEAN_b,
        canopy_ratio=(AREA/90000)/100)

# Write the updated shapefile to a new file
st_write(clipped, "updated_shapefile.shp")
    
names(clipped)







         


