#study area
# install and load required packages
install.packages("leaflet")
library(leaflet)

# set coordinates for Des Moines
des_moines <- c(lon = -93.6091, lat = 41.6005)

# create a leaflet map centered on Des Moines
des_moines_map <- leaflet() %>% 
  setView(lng = des_moines[1], lat = des_moines[2], zoom = 11) %>% 
  addTiles()

# add a marker at the center of the map
des_moines_map <- des_moines_map %>% addMarkers(lng = des_moines[1], lat = des_moines[2])

# display the map
des_moines_map


