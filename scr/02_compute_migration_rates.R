############################################################
# 02_compute_migration_rates.R
# Calcul des taux migratoires et fusion avec données spatiales
############################################################

library(dplyr)
library(sf)

load("data/clean_data.RData")

#-----------------------------------------------------------
# 1. Calcul des flux sortants et entrants
#-----------------------------------------------------------

outflow <- mig_data_period %>%
  group_by(origin) %>%
  summarise(outflow = sum(reverse_neg))

inflow <- mig_data_period %>%
  group_by(dest) %>%
  summarise(inflow = sum(reverse_neg))

colnames(outflow)[1] <- "CountryCode"
colnames(inflow)[1] <- "CountryCode"

#-----------------------------------------------------------
# 2. Fusion avec covariables
#-----------------------------------------------------------

outflow <- left_join(outflow, my_covariates, by = "CountryCode") %>%
  mutate(EmigrationRate = outflow / population)

inflow <- left_join(inflow, my_covariates, by = "CountryCode") %>%
  mutate(ImmigrationRate = inflow / population)

# Fusion finale
migration_rates <- left_join(outflow, inflow[, c("CountryCode","inflow","ImmigrationRate")], by = "CountryCode")

#-----------------------------------------------------------
# 3. Fusion avec données spatiales
#-----------------------------------------------------------

world_filtered <- world %>% filter(iso3 %in% migration_rates$CountryCode)

world_migration <- left_join(
  world_filtered,
  migration_rates,
  by = c("iso3" = "CountryCode")
)

#-----------------------------------------------------------
# 4. Sauvegarde
#-----------------------------------------------------------

save(world_migration, migration_rates, file = "data/migration_rates.RData")
