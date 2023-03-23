# LA588-Assignment4
# 
# March 21, 2023
# Sedi

install.packages("leaflet", "leaflet.providers", "tidyverse")
install.packages("sf")
library(leaflet)
library(leaflet.providers)
library(tidyverse)
library(readxl)
library(sf)
library(dplyr)





lookup<- read.csv("IowaStudentsDiversity.csv", header = TRUE)

myData <- lookup
greenLeafIcon <- makeIcon(
  iconUrl = "https://leafletjs.com/examples/custom-icons/leaf-green.png",
  iconWidth = 10, iconHeight = 35,
  iconAnchorX = 22, iconAnchorY = 94,
  shadowUrl = "https://leafletjs.com/examples/custom-icons/leaf-shadow.png",
  shadowWidth = 50, shadowHeight = 64,
  shadowAnchorX = 4, shadowAnchorY = 62
)
  
# Add markers from the CSV to this map
map <- leaflet(myData) %>% 
  addTiles() %>%
  

  addMarkers(~longitude, ~latitude,icon = greenLeafIcon)
map

# Circles 

map <- leaflet(myData) %>% 
  addTiles() %>%
  addCircles(~longitude, ~latitude, label = myData$country)
map


map <- leaflet(myData) %>% 
  addTiles() %>%
  addCircles(~longitude, ~latitude, popup = paste("<strong>", 
    myData$last_name, "</strong><br>", "country: ", 
    myData$country))
map

# Maybe change the size and color of the circles
# Note for the color you can also use the hex color value
map <- leaflet(myData) %>% 
  addTiles() %>%
  addCircles(~longitude, ~latitude, popup= paste("<strong>", 
    myData$last_name, "</strong><br>", "country: ", 
    myData$country), weight = 12, radius=1000, 
    color="green", stroke = TRUE, fillOpacity = 0.8)
map

# Time to add some options for the base map
# See the complete set of Leaflet providers 
# http://leaflet-extras.github.io/leaflet-providers/preview/index.html
# Running the following should display the map layers in the console.


# We now have an button containing a group of background layers
map <- leaflet(myData) %>% 
  addTiles(group = "OSM", options = providerTileOptions(minZoom = 4, maxZoom = 10)) %>%
  addProviderTiles("Stamen.TonerLite", group = "Toner", 
    options = providerTileOptions(minZoom = 8, maxZoom = 10)) %>%
  addProviderTiles("Thunderforest", group = "Water Color") %>%
  addProviderTiles("TomTom", group = "Topo") %>%
  addProviderTiles("OpenPtMap", group = "Mapnik") %>%
  addProviderTiles("HERE.normalDayTraffic", group = "CartoDB") %>%
  addLayersControl(baseGroups = c("OSM", "Toner", "Water Color", "Topo", "Mapnik", "CartoDB"),
    options = layersControlOptions(collapsed = TRUE)) %>%
  addCircles(~longitude, ~latitude, popup= paste("<strong>", 
    myData$last_name, "</strong><br>", "Shirt Size: ", 
    myData$country), weight = 4, radius=40, 
    color="red", stroke = TRUE, fillOpacity = 0.8)
map



# Wow, that was a lot of points! How about only the first 200 observations?
map <- leaflet(myData[1:50,]) %>% 
  addProviderTiles("TomTom", 
    options = providerTileOptions(minZoom = 4, maxZoom = 10))%>%
  addMarkers(~longitude, ~latitude)
map

# Make clusters, note this only appears to work with addMarkers
map <- leaflet(myData[1:50,]) %>% 
  addProviderTiles("Stamen.TonerLite", 
    options = providerTileOptions(minZoom = 4, maxZoom = 10))%>%
  addMarkers(~longitude, ~latitude, clusterOptions = markerClusterOptions())
map

# One more try on all 1,000 locations
map <- leaflet(myData) %>% 
  addProviderTiles("Stamen.TonerLite", 
    options = providerTileOptions(minZoom = 6, maxZoom = 20))%>%
  addMarkers(~longitude, ~latitude, clusterOptions = markerClusterOptions())
map

county_pop_places <- st_read("iowa.shp")
shapefile_new <- county_pop_places %>% 
  select(geometry)
st_write(shapefile_new, "new_shapefile.shp")
# Set the projection to use lat and longs
county_pop_places <- st_transform(county_pop_places, crs = 4326)



m <- leaflet() %>%
  setView(-96.7, 40.2, 6)  %>%
  addTiles() %>%
  addPolygons(data = county_pop_places,  # borders of all counties
              color = "blue", fill = NA, weight = 1)
m