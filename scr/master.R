############################################################
# master.R
# Exécution séquentielle du pipeline d’économétrie spatiale
# Auteur : Said OUZZINE
############################################################

# Fonction utilitaire pour exécuter un script R
run_script <- function(file) {
  cat("\n====================================================\n")
  cat("Exécution du script :", file, "\n")
  cat("====================================================\n\n")
  
  source(file, echo = TRUE, max.deparse.length = Inf)
  
  cat("\n----------------------------------------------------\n")
  cat("Fin du script :", file, "\n")
  cat("----------------------------------------------------\n\n")
}

# Liste des scripts dans l’ordre logique du pipeline
scripts <- c(
  "src/01_load_and_clean_data.R",
  "src/02_compute_migration_rates.R",
  "src/03_spatial_autocorrelation.R",
  "src/04_spatial_models.R",
  "src/05_gravity_model.R"
)

# Exécution séquentielle
cat("\n====================================================\n")
cat("DÉMARRAGE DU PIPELINE D'ÉCONOMÉTRIE SPATIALE\n")
cat("====================================================\n\n")

for (s in scripts) {
  run_script(s)
}

cat("\n====================================================\n")
cat("PIPELINE TERMINÉ AVEC SUCCÈS\n")
cat("====================================================\n")
