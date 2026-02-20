############################################################
# 04_spatial_models.R
# Modèles spatiaux : OLS, SAR, SEM, SDM
############################################################

library(spdep)
library(dplyr)

load("data/migration_rates.RData")
load("data/spatial_autocorrelation.RData")

#-----------------------------------------------------------
# 1. Modèle OLS
#-----------------------------------------------------------

formula_mig <- EmigrationRate ~ deflactor + lifeexp + GDPpercapita_UN +
  FD + politicalstability + landlocked + vulnerability +
  prec_3days + heat_wave + dry_wave

ols_emig <- lm(formula_mig, data = world_migration)
ols_immig <- lm(update(formula_mig, ImmigrationRate ~ .), data = world_migration)

#-----------------------------------------------------------
# 2. Tests de dépendance spatiale
#-----------------------------------------------------------

lm_moran_emig <- lm.LMtests(ols_emig, W, test = "all")
lm_moran_immig <- lm.LMtests(ols_immig, W, test = "all")

#-----------------------------------------------------------
# 3. Modèles SAR / SEM / SDM
#-----------------------------------------------------------

sar_emig <- lagsarlm(formula_mig, data = world_migration, listw = W)
sem_emig <- errorsarlm(formula_mig, data = world_migration, listw = W)
sdm_emig <- lagsarlm(formula_mig, data = world_migration, listw = W, type = "mixed")

#-----------------------------------------------------------
# 4. Sauvegarde
#-----------------------------------------------------------

save(
  ols_emig, ols_immig,
  lm_moran_emig, lm_moran_immig,
  sar_emig, sem_emig, sdm_emig,
  file = "data/spatial_models.RData"
)
