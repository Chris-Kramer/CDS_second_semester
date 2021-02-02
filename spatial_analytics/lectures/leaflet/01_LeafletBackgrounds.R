###   GETTING STARTED WITH LEAFLET


## Choose favorite backgrounds in:
# https://leaflet-extras.github.io/leaflet-providers/preview/
## beware that some need extra options specified

# Packages
# install.packages("leaflet")
# install.packages("htmltools")

# Example with Markers
library(leaflet)
library(htmltools)
library(htmlwidgets)
library(tidyverse)

popup = c("Robin", "Jakub", "Jannes")
leaflet.providers::get_providers()
leaflet() %>% # Call biblioteket glem ikke paranteser
# addProviderTiles("Esri.WorldPhysical") %>% #En baggrund
  addProviderTiles("Esri.WorldImagery") %>% #En anden baggrund
  addAwesomeMarkers(lng = c(-3, 23, 11), #Tilføj markører, longtitude
                    lat = c(52, 53, 49),#Tilføj markører, latitude
                    popup = popup) 


## Sydney with setView
leaflet() %>%
  addTiles() %>%
  addProviderTiles("Esri.WorldImagery", 
                   options = providerTileOptions(opacity=0.5)) %>% 
  setView(lng = 151.005006, lat = -33.9767231, zoom = 10) #Med setview kan vi finde et set, her er det sydnet


# Europe with Layers
leaflet() %>% 
  addTiles() %>% 
  setView( lng = 2.34, lat = 48.85, zoom = 5 ) %>% 
  addProviderTiles("Esri.WorldPhysical", group = "Physical") %>% #Lag 1
  addProviderTiles("Esri.WorldImagery", group = "Aerial") %>%  #Lag 2
  addProviderTiles("MtbMap", group = "Geo") %>%  #Lag 3

addLayersControl( #Her tilføjes lag
  baseGroups = c("Geo","Aerial", "Physical"),
  options = layersControlOptions(collapsed = T))

# note that you can feed plain Lat Long columns into Leaflet
# without having to convert into spatial objects (sf), or projecting


########################## SYDNEY HARBOUR DISPLAY WITH LAYERS

# Set the location and zoom level
leaflet() %>% 
  setView(151.2339084, -33.85089, zoom = 13) %>%
  addTiles()  # checking I am in the right area


# Bring in a choice of esri background layers  

l_aus <- leaflet() %>%   # assign the base location to an object
  setView(151.2339084, -33.85089, zoom = 13)


esri <- grep("^Esri", providers, value = TRUE)

for (provider in esri) {
  l_aus <- l_aus %>% addProviderTiles(provider, group = provider)
}

AUSmap <- l_aus %>%
  addLayersControl(baseGroups = names(esri),
                   options = layersControlOptions(collapsed = FALSE)) %>%
  addMiniMap(tiles = esri[[1]], toggleDisplay = TRUE,
             position = "bottomright") %>%
  addMeasure(
    position = "bottomleft",
    primaryLengthUnit = "meters",
    primaryAreaUnit = "sqmeters",
    activeColor = "#3D535D",
    completedColor = "#7D4479") %>% 
  htmlwidgets::onRender("
                        function(el, x) {
                        var myMap = this;
                        myMap.on('baselayerchange',
                        function (e) {
                        myMap.minimap.changeLayer(L.tileLayer.provider(e.name));
                        })
                       }") %>% 
addControl("", position = "topright")

AUSmap #View the map
################################## SAVE FINAL PRODUCT

# Save map as a html document (optional, replacement of pushing the export button)
# only works in root
library(htmlwidgets)
saveWidget(AUSmap, "AUSmap.html", selfcontained = TRUE)


################################## ADD DATA TO LEAFLET
# Libraries
library(tidyverse)
library(googlesheets4)
library(leaflet)
library(googlesheets)

places <- read_sheet("https://docs.google.com/spreadsheets/d/1PlxsPElZML8LZKyXbqdAYeQCDIvDps2McZx1cTVWSzI/edit#gid=0",col_types = "cccnncn")
glimpse(places)

leaflet() %>% 
  addTiles() %>% 
  addMarkers(lng = places$Longitude, 
             lat = places$Latitude,
             popup = places$Description)

#########################################################
#
# Task 1: Create a Danish equivalent with esri layers

l_denmark <- leaflet() %>%   # assign the base location to an object
  setView(11, 56, zoom = 7)


esri <- grep("^Esri", providers, value = TRUE)

for (provider in esri) {
  l_denmark <- l_denmark %>% addProviderTiles(provider, group = provider)
}

danish_map <- l_denmark %>%
  addLayersControl(baseGroups = names(esri),
                   options = layersControlOptions(collapsed = FALSE)) %>%
  addMiniMap(tiles = esri[[1]], toggleDisplay = TRUE,
             position = "bottomright") %>%
  addMeasure(
    position = "bottomleft",
    primaryLengthUnit = "meters",
    primaryAreaUnit = "sqmeters",
    activeColor = "#3D535D",
    completedColor = "#7D4479") %>% 
  htmlwidgets::onRender("
                        function(el, x) {
                        var myMap = this;
                        myMap.on('baselayerchange',
                        function (e) {
                        myMap.minimap.changeLayer(L.tileLayer.provider(e.name));
                        })
                       }") %>% 
  addControl("", position = "topright")
danish_map
# Task 2: Read in the googlesheet data you and your colleagues populated with data. 


places <- read_sheet("https://docs.google.com/spreadsheets/d/1PlxsPElZML8LZKyXbqdAYeQCDIvDps2McZx1cTVWSzI/edit#gid=0")

glimpse(places)

places <- places %>% filter(!is.na(Longitude))

danish_map %>% 
  addCircleMarkers(lng = places$Longitude,
                   lat = places$Latitude,
                   popup = places$Description,
                   clusterOptions = markerClusterOptions()) #This clusters nearby points to one. 
# The googlesheet is at https://docs.google.com/spreadsheets/d/1PlxsPElZML8LZKyXbqdAYeQCDIvDps2McZx1cTVWSzI/edit#gid=0

#########################################################