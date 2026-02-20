############################################################
# utils.R
# Fonctions utilitaires pour le projet
############################################################

# Fonction pour normaliser une variable
normalize <- function(x) {
  return((x - min(x, na.rm = TRUE)) / (max(x, na.rm = TRUE) - min(x, na.rm = TRUE)))
}

# Fonction pour vérifier unicité d’un identifiant
check_unique <- function(df, var) {
  sum(duplicated(df[[var]]))
}

# Fonction pour créer un Moran scatterplot
plot_moran <- function(values, listw) {
  moran.plot(values, listw, labels = FALSE)
}
