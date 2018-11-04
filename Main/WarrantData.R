library(RSocrata)
library(here)
library(tidyverse)

source(here::here('Main/tokenSocrata.R'))

if(!requireNamespace("devtools")) install.packages("devtools")
devtools::install_github("dkahle/ggmap", ref = "tidyup")
library(ggmap)

######################################
####           Warrants          #####
######################################

warants <- 'https://data.brla.gov/resource/gdjb-agbb.csv?'
query <- "$where=doa between '2016-06-12' and '2016-08-22'"

dt_warrants <- read.socrata(paste0(warants, query), app_token = token[['app']])
dt_warrants <- as_tibble(dt_warrants)

dt_warrants <- dt_warrants %>% 
  filter(sex == "M")

######################################
####       Types of crimes       #####
######################################



######################################
####            Other            #####
######################################
# brMap <- readRDS(here::here('data/mapTerrainBR.RDS'))

# ggmap::ggmap(brMap) +
#   geom_point(data = dataComb, aes(x = long, y = lat, color = type), alpha = .35) + 
#   ggtitle('Emergency Calls')

