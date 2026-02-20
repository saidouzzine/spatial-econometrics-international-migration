############################################################
# 03_spatial_autocorrelation.R
# Matrices de poids, Moran I, LISA
############################################################

library(spdep)
library(sf)
library(dplyr)

load("data/migration_rates.RData")

#-----------------------------------------------------------
# 1. Construction de la matrice de poids spatiaux
#-----------------------------------------------------------

coords <- st_coordinates(st_centroid(world_migration))

# Contiguïté + 4 plus proches voisins
nb_contig <- poly2nb(world_migration)
nb_knn <- knn2nb(knearneigh(coords, k = 4))

nb_combined <- union.nb(nb_contig, nb_knn)
W <- nb2listw(nb_combined, style = "W")

#-----------------------------------------------------------
# 2. Moran I sur EmigrationRate et ImmigrationRate
#-----------------------------------------------------------

moran_emig <- moran.test(world_migration$EmigrationRate, W)
moran_immig <- moran.test(world_migration$ImmigrationRate, W)

#-----------------------------------------------------------
# 3. LISA (Local Moran)
#-----------------------------------------------------------

lisa_emig <- localmoran(world_migration$EmigrationRate, W)
lisa_immig <- localmoran(world_migration$ImmigrationRate, W)

#-----------------------------------------------------------
# 4. Sauvegarde
#-----------------------------------------------------------

save(W, moran_emig, moran_immig, lisa_emig, lisa_immig, file = "data/spatial_autocorrelation.RData")
