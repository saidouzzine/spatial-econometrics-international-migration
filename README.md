![R](https://img.shields.io/badge/R-276DC3?logo=r&logoColor=white&style=for-the-badge)
![Spatial Econometrics](https://img.shields.io/badge/Spatial%20Econometrics-8A2BE2?style=for-the-badge)

# spatial-econometrics-international-migration
Analyse spatiale des migrations internationales : description des données, calcul des taux d’émigration/immigration, cartographie, autocorrélation spatiale, modèles OLS et modèles spatiaux, puis estimation d’un modèle gravitaire des flux bilatéraux entre pays.
# Projet d’Économétrie Spatiale : Analyse des Flux Migratoires Internationaux  
Auteur : Said OUZZINE  
Master 2 FOAD – Toulouse School of Economics  

## 1. Objectif du projet
Ce projet analyse les dynamiques migratoires internationales à travers une approche d’économétrie spatiale.  
Il est structuré en trois volets :

1. **Description et préparation des données**  
2. **Analyse des taux d’émigration et d’immigration par pays**  
3. **Modélisation des flux migratoires bilatéraux via un modèle gravitaire**

L’ensemble du travail a été réalisé sous **R** et documenté via **R Markdown**.

---

## 2. Données utilisées

### 2.1 Flux migratoires (Abel & Cohen, 2019)
- Flux bilatéraux estimés pour plusieurs périodes (1990–2020)  
- Six méthodes d’estimation disponibles  
- Méthode retenue : **minimisation fermée (min_close)**  
- Période de référence : **2015–2020**

### 2.2 Données géographiques
- Contours administratifs mondiaux  
- Projection utilisée : **ESRI:54030 (World Robinson)**  
- Format : objets `sf` (simple features)

### 2.3 Variables explicatives nationales
Provenant de Laurent et al. (2022) :  
- PIB par habitant (PPP)  
- Espérance de vie  
- Déflateur du PIB  
- Stabilité politique  
- Population  
- Indicateurs climatiques : précipitations extrêmes, vagues de chaleur, sécheresse  
- Indicateurs de catastrophes naturelles  
- Conflits par habitant  
- Vulnérabilité climatique  
- Variable ajoutée : **taux de chômage** (Banque mondiale)

Les valeurs manquantes sont imputées via **missForest()**.

### 2.4 Variables explicatives bilatérales
- Contiguïté  
- Langue commune  
- Monnaie commune  
- Relations coloniales  
- Distance géographique entre pays  

---

## 3. Analyse des taux d’émigration et d’immigration

### 3.1 Construction des indicateurs
- Calcul des flux entrants et sortants par pays  
- Fusion avec les covariables nationales  
- Création des variables :
  - **EmigrationRate = outflow / population**
  - **ImmigrationRate = inflow / population**
  - **NetMigration = ImmigrationRate – EmigrationRate**

### 3.2 Analyse exploratoire
- Corrélations entre variables explicatives et taux migratoires  
- Cartes thématiques :
  - Taux d’émigration  
  - Taux d’immigration  
  - Taux net de migration  
- Identification des zones à forte pression migratoire

### 3.3 Autocorrélation spatiale
- Matrice de poids spatiaux (contiguïté + k plus proches voisins)  
- Moran scatterplot  
- Tests de Moran I  
- Cartographie des clusters LISA (HH, LL, HL, LH)

### 3.4 Modèles spatiaux
- Estimation OLS pour les deux variables dépendantes  
- Tests de dépendance spatiale sur les résidus  
- Sélection du modèle via stratégie **specific-to-general** :
  - SAR (Spatial Autoregressive Model)  
  - SEM (Spatial Error Model)  
  - SAC / SDM selon les cas  
- Interprétation des effets directs et indirects

---

## 4. Modélisation des flux migratoires bilatéraux

### 4.1 Préparation du jeu de données
- Fusion des flux bilatéraux avec :
  - caractéristiques du pays d’origine (Xo)  
  - caractéristiques du pays de destination (Xd)  
  - variables bilatérales (G)  
- Filtrage des paires valides présentes dans la base géographique

### 4.2 Calcul des distances
- Extraction des coordonnées géographiques  
- Calcul des distances entre capitales ou centroïdes  
- Ajout au modèle gravitaire

### 4.3 Modèle gravitaire estimé
Forme générale :  
**y = Xo·βo + Xd·βd + G·γ + ε**

- Effets significatifs des variables économiques et climatiques  
- Rôle majeur de la distance et des proximités culturelles  
- Comparaison des résultats selon la période (1990–1995 vs 2015–2020)

---

## 5. Technologies utilisées
- **R**  
- Packages : `sf`, `dplyr`, `ggplot2`, `spdep`, `missForest`, `geosphere`, `tidyr`, `tibble`  
- R Markdown pour la génération du rapport final

---

## 6. Structure du dépôt
```
spatial-econometrics-migration
│
├── data/
│   ├── mig_data/                 # Flux migratoires (Abel & Cohen)
│   ├── covariates/               # Variables explicatives nationales
│   ├── pairs/                    # Variables bilatérales
│   └── world_boundaries/         # Données géographiques (sf)
│
├── src/
│   ├── 01_load_and_clean_data.R          # Chargement + nettoyage des données
│   ├── 02_compute_migration_rates.R      # Taux d’émigration/immigration
│   ├── 03_spatial_autocorrelation.R      # Matrices W, Moran, LISA
│   ├── 04_spatial_models.R               # OLS, SAR, SEM, SDM
│   ├── 05_gravity_model.R                # Modèle gravitaire bilatéral
│   └── utils.R                           # Fonctions auxiliaires
│
├── reports/
│   ├── Projet_Spatial_OUZZINESAID.pdf    # Rapport final généré via R Markdown
│   └── figures/                          # Graphiques, cartes, diagnostics
│
├── notebooks/
│   └── Projet_Spatial_OUZZINESAID.Rmd    # Script R Markdown complet
│
├── README.md
├── requirements.txt                       # Packages R nécessaires
└── .gitignore
```

---

## 7. Auteur
**Said OUZZINE**    
Data Scientist | Machine Learning | Risk Modeling  

Contact :  
- LinkedIn : https://www.linkedin.com/in/said-ouzzine/  
- Email : sadouzzine@email.com


