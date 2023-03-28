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




# ----------------Create a Leaflet page in R that includes at least 20 markers.  ------

#I created an excel file using https://www.mockaroo.com/
lookup<- read.csv("IowaStudentsDiversity.csv", header = TRUE)
myData <- lookup


# I made a marker which called " green leaf icon"
greenLeafIcon <- makeIcon(
  iconUrl = "https://leafletjs.com/examples/custom-icons/leaf-green.png",
  iconWidth = 20, iconHeight = 60,
  iconAnchorX = 22, iconAnchorY = 94,
  shadowUrl = "https://leafletjs.com/examples/custom-icons/leaf-shadow.png",
  shadowWidth = 50, shadowHeight = 64,
  shadowAnchorX = 4, shadowAnchorY = 62)

  

# I added the markers from the CSV to this map
map <- leaflet(myData) %>% 
  addTiles() %>%
  addMarkers(~longitude, ~latitude,icon = greenLeafIcon)
map



# I added Circles 
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


map <- leaflet(myData) %>% 
  addTiles() %>%
  addCircles(~longitude, ~latitude, popup= paste("<strong>", 
    myData$last_name, "</strong><br>", "country: ", 
    myData$country), weight = 12, radius=1000, 
    color="green", stroke = TRUE, fillOpacity = 0.8)
map



# using http://leaflet-extras.github.io/leaflet-providers/preview/index.html
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



# selecting a portion of dataframe
map <- leaflet(myData[1:50,]) %>% 
  addProviderTiles("TomTom", 
    options = providerTileOptions(minZoom = 4, maxZoom = 10))%>%
  addMarkers(~longitude, ~latitude, icon = greenLeafIcon)
map

# Makeing clusters
map <- leaflet(myData[1:50,]) %>% 
  addProviderTiles("Stamen.TonerLite", 
    options = providerTileOptions(minZoom = 4, maxZoom = 10))%>%
  addMarkers(~longitude, ~latitude, icon = greenLeafIcon,clusterOptions = markerClusterOptions())
map


map <- leaflet(myData) %>% 
  addProviderTiles("Stamen.TonerLite", 
    options = providerTileOptions(minZoom = 7, maxZoom = 20))%>%
  addMarkers(~longitude, ~latitude,icon = greenLeafIcon, clusterOptions = markerClusterOptions())
map

# ----------------Create a Leaflet page in R that includes a chloropleth.------------
#Importing the shapefile.i created this shapefile based on my dataset

county_pop_places <- st_read("correctedshp.shp")
#county_pop_places <- county_pop_places %>% select(-geometry)
#st_write(county_pop_places, "new3_shapefile.shp")
#Data <- st_read("new3_shapefile.shp")
# Set the projection to use lat and longs
county_pop_places <- st_transform(county_pop_places, crs = 4326)

m <- leaflet() %>%
  setView(-94.5, 42.2, 6)  %>%
  addTiles() %>%
  addPolygons(data = county_pop_places,  # borders of all counties
              color = "green", fill = NA, weight = 1)
m

#setting bounds
bounds <- county_pop_places %>% 
  st_bbox() %>% 
  as.character()
fitBounds(m, bounds[1], bounds[2], bounds[3], bounds[4])
# Display only a few counties, counties with <1DOM countyI<20e.
county_pop_places_selection1 <- county_pop_places %>% 
  filter(DOMCountyI %in% c(1:20))

m <- leaflet() %>%
  setView(-94.5, 42.2, 6)  %>%
  addTiles() %>%
  addPolygons(data = county_pop_places_selection1,  # borders of all counties
              color = "#ffff00", fillColor = "green", weight = 3, opacity = 0.50, fillOpacity = 0.5, stroke = TRUE)
m
?leaflet::addPolygons

# Or maybe only the counties with TYPE>4or na
county_pop_places_selection2 <-county_pop_places %>% 
  filter(is.na(TYPE) | !TYPE > 4)

m <- leaflet() %>%
  setView(-94.5, 42.2, 6)  %>%
  addTiles() %>%
  addPolygons(data = county_pop_places_selection2,  # borders of all counties
              color = "#000", fillColor = "red", weight = 1, 
              opacity = 0.75, fillOpacity = 0.8)
m

# selecting both
m <- leaflet() %>%
  setView(-94.5, 42.2, 6)  %>%
  addTiles() %>%
  addPolygons(data = county_pop_places_selection2,  # borders of all counties
              color = "#000", fillColor = "red", weight = 1, 
              opacity = 0.75, fillOpacity = 0.8) %>%
  # Add the additional polygon! This woudl work for markers as well!!!
  addPolygons(data = county_pop_places_selection1,  # borders of all counties
              color = "blue", fillColor = "white", weight = 5, 
              opacity = 0.75, fillOpacity = 0.8)
m

# Select the color scheme from Color Brewer
library("RColorBrewer") #I think either Leaflet or tidyverse loads this for you
display.brewer.all()

bins <- c(0, 1, 2, 3, 4, 5, 6, 7, 8,9,10,11,12, Inf)
pal <- colorBin("Greens", domain = county_pop_places$TYPE, bins = bins)

m <- leaflet() %>%
  setView(-94.5, 42.2, 6)  %>%
  addTiles() %>%
  addPolygons(data = county_pop_places,
              fillColor = ~pal(TYPE),
              weight = 0.2,
              opacity = 1,
              color = "black",
              dashArray = "1",
              fillOpacity = 0.8)
m

# Add interaction
m <- leaflet() %>%
  setView(-94.5, 42.2, 6)  %>%
  addTiles() %>%
  addPolygons(data = county_pop_places,
              fillColor = ~pal(TYPE),
              weight = 0.5,
              opacity = 1,
              color = "grey",
              dashArray = "1",
              fillOpacity = 0.8,  #be careful, you need to switch the ) to a comma
              highlightOptions = highlightOptions(
                weight = 2,
                color = "#466",
                dashArray = "",
                fillOpacity = 0.7,
                bringToFront = TRUE)
  )
m


# Adding a popup
labels <- sprintf(
  "<strong>%s</strong><br/>%g TYPE",
  county_pop_places$QUAD_NAME, county_pop_places$TYPE
) %>% lapply(htmltools::HTML)

m <- leaflet() %>%
  setView(-94.5, 42.2, 6)  %>%
  addTiles() %>%
  addPolygons(data = county_pop_places,
              fillColor = ~pal(TYPE),
              weight = 0.5,
              opacity = 1,
              color = "grey",
              dashArray = "1",
              fillOpacity = 0.8,  #be careful, you need to switch the ) to a comma
              highlightOptions = highlightOptions(
                weight = 2,
                color = "#666",
                dashArray = "",
                fillOpacity = 0.7,
                bringToFront = TRUE),
              label = labels,
              labelOptions = labelOptions(
                style = list("font-weight" = "normal", padding = "3px 8px"),
                textsize = "10px",
                direction = "auto"))
m


#Adding a legend
m %>% addLegend(pal = pal, values = count, opacity = 0.7, title = "IOWA POPULATED PLACES",
                position = "bottomright")

#But we would prefer to have
#bounds <- county_pop_places %>% 
 # st_bbox() %>% 
 # as.character()
#fitBounds(m, bounds[1], bounds[2], bounds[3], bounds[4])

library(htmlwidgets)
#This does the same as export and creates a single 1.7 MB file
saveWidget(m, file="m.html")

# however if you want to export multiple maps for a page, then you can put 
# the shared resources into a dir named lib. The m.html file then is 1.
saveWidget(m, "m.html", selfcontained = F, libdir = "lib")
