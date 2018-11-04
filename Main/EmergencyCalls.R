library(RSocrata)
library(here)
library(tidyverse)

source(here::here('Main/tokenSocrata.R'))

if(!requireNamespace("devtools")) install.packages("devtools")
devtools::install_github("dkahle/ggmap", ref = "tidyup")
library(ggmap)

######################################
####    LOOTING 911 calls        #####
######################################

crimeIncidents <- 'https://data.brla.gov/resource/gdjb-agbb.csv?'
query <- "$where=offense_date between '2016-08-12' and '2016-08-22'"

dt_911 <- read.socrata(paste0(crimeIncidents, query), app_token = token[['app']])
dt_911 <- as_tibble(dt_911)

dt_911 <- dt_911 %>% 
  filter(geolocation != "") %>%
  mutate(geolocation = str_extract_all(geolocation, '[-,.,0-9]+')) %>% 
  mutate(long = as.double(map_chr(geolocation, 1)), lat = as.double(map_chr(geolocation, 2))) %>%
  mutate(type = "911 Calls") %>%
  filter(offense_desc == "LOOTING")

######################################
####          Mapping            #####
######################################

brMap <- readRDS(here::here('data/mapTerrainBR.RDS'))

dataComb <- bind_rows(dt_311, dt_911, dt_fire)

ggmap::ggmap(brMap) +
  geom_point(data = dataComb, aes(x = long, y = lat, color = type), alpha = .35) + 
  ggtitle('Emergency Calls')

