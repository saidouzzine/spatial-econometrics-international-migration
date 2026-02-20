############################################################
# 05_gravity_model.R
# Modèle gravitaire des flux migratoires bilatéraux
############################################################

library(dplyr)
library(geosphere)

load("data/mig_data.RData")
load("data/covariates.RData")
load("data/pairs.RData")

#-----------------------------------------------------------
# 1. Fusion des données bilatérales
#-----------------------------------------------------------

data_od <- mig_data %>%
  filter(period == "2015-2020") %>%
  left_join(my_covariates, by = c("origin" = "CountryCode")) %>%
  left_join(my_covariates, by = c("dest" = "CountryCode"), suffix = c("_O", "_D")) %>%
  left_join(pairs, by = c("origin" = "countrycode1", "dest" = "countrycode2"))

#-----------------------------------------------------------
# 2. Calcul des distances géographiques
#-----------------------------------------------------------

coords <- read.csv("data/country_centroids.csv")

data_od <- data_od %>%
  left_join(coords, by = c("origin" = "iso3")) %>%
  left_join(coords, by = c("dest" = "iso3"), suffix = c("_O", "_D"))

data_od$distance <- distHaversine(
  cbind(data_od$lon_O, data_od$lat_O),
  cbind(data_od$lon_D, data_od$lat_D)
)

#-----------------------------------------------------------
# 3. Modèle gravitaire
#-----------------------------------------------------------

gravity_formula <- reverse_neg ~
  log(GDPpercapita_UN_O) + log(GDPpercapita_UN_D) +
  log(population_O) + log(population_D) +
  distance + contig + comlang_off + comcur + colony

gravity_model <- lm(gravity_formula, data = data_od)

#-----------------------------------------------------------
# 4. Sauvegarde
#-----------------------------------------------------------

save(data_od, gravity_model, file = "data/gravity_model.RData")
