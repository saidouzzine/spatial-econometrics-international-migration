############################################################
# 01_load_and_clean_data.R
# Chargement et nettoyage des données du projet
# Auteur : Said OUZZINE
############################################################

# Packages
library(dplyr)
library(sf)
library(missForest)

#-----------------------------------------------------------
# 1. Chargement des données migratoires
#-----------------------------------------------------------

load("data/mig_data.RData")   # mig_data
mig_data <- as.data.frame(mig_data)

# Filtrer la période de référence
mig_data_period <- subset(mig_data, period == "2015-2020")

#-----------------------------------------------------------
# 2. Chargement des covariables nationales
#-----------------------------------------------------------

load("data/covariates.RData")   # my_covariates

# Ajout de la variable supplémentaire : taux de chômage
unemployment <- read.csv("data/unemployment.csv")

my_covariates <- merge(
  my_covariates,
  unemployment,
  by.x = "CountryCode",
  by.y = "CountryCode",
  all.x = TRUE
)

#-----------------------------------------------------------
# 3. Imputation des valeurs manquantes
#-----------------------------------------------------------

vars_to_impute <- c(
  "deflactor","lifeexp","dummyEarthquake","population","dummyStorm",
  "GDPpercapita_UN","FD","conflictpercapita","politicalstability",
  "landlocked","vulnerability","Events","Fatalities"
)

my_covariates[, vars_to_impute] <- missForest(my_covariates[, vars_to_impute])$ximp

#-----------------------------------------------------------
# 4. Chargement des données géographiques
#-----------------------------------------------------------

world <- st_read("data/world_boundaries.geojson")
world <- st_transform(world, crs = "ESRI:54030")

#-----------------------------------------------------------
# 5. Sauvegarde
#-----------------------------------------------------------

save(mig_data_period, my_covariates, world, file = "data/clean_data.RData")
