library(leaflet)
library(htmltools)
library(htmlwidgets)
library(tidyverse)

data_RCFeature <- read.csv("data/RCFeature.csv")
data_RCFeature <- tibble(data_RCFeature)
view(data_RCFeature)

view("data/RCFeature.csv")

l_denmark <- leaflet() %>%   # assign the base location to an object
  setView(150.2923, -33.75892, zoom = 17)

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

places <- data_RCFeature %>% filter(!is.na(Longitude))
danish_map %>% 
  addCircleMarkers(lng = places$Longitude,
                   lat = places$Latitude,
                   popup = places$Description,
                   clusterOptions = markerClusterOptions())





