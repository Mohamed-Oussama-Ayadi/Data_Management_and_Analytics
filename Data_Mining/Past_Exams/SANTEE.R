#**************************************DATA_SANTE************************************************
rm(list=ls())
library("readxl")
library(tidyverse)
library(cluster)
library(factoextra)  
library(class)
library(caret)
library(pROC)
library(rpart)
library(corrplot)
library(ggplot2)
library(scatterplot3d)
library(imputeTS)
library(caTools)
library(kknn)
library(e1071)
library(MASS)
library(car)
library(DAAG)
library(boot)
library(randomForest)

#**************************************CHARGEMENT DES DONNÉES********************************************
sante <- read.csv(file.choose())
#************************************Comprehension des donnees*******************************************
View(sante)
summary(sante)
dim(sante)
str(sante)

#************************************variables quantitatives*******************************************
#**************************************BOXPLOTS******************************************************
# Variables à inclure dans les boxplots
quantit <- c("age", "sysBP", "diaBP", "BMI")

# Ouvrir une nouvelle fenêtre graphique avec une taille personnalisée
windows(width = 12, height = 10)

# Définir le nombre de rangées et de colonnes pour les sous-plots
par(mfrow = c(1, 4))

# Tracer les boxplots avec ggplot2
ggplot(sante, aes(x = factor(1))) +
  geom_boxplot(aes(y = sante[[quantit[1]]]), position = position_dodge(width = 0.8), width = 0.5) +
  geom_boxplot(aes(y = sante[[quantit[2]]]), position = position_dodge(width = 1.6), width = 0.5) +
  geom_boxplot(aes(y = sante[[quantit[3]]]), position = position_dodge(width = 2.4), width = 0.5) +
  geom_boxplot(aes(y = sante[[quantit[4]]]), position = position_dodge(width = 3.2), width = 0.5) +
  labs(title = "Distribution des données Médicales (ggplot2)",
       y = "Valeurs") +
  scale_x_discrete(labels = quantit) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Tracer les boxplots avec la base R
for (variable in quantit) {
  boxplot(sante[[variable]], main = paste("Distribution de", variable), col = "lightblue", border = "black")
}
#**************************************HISTOGRAMMES******************************************************

# Ouvrir une nouvelle fenêtre graphique avec une taille personnalisée
windows(width = 12, height = 10)

# Définir le nombre de rangées et de colonnes pour les sous-plots
par(mfrow = c(4, 1))

# Tracer les histogrammes pour les variables quantitatives
hist(sante$age, main = "Distribution des Âges", xlab = "Âge", col = "lightblue", border = "black")
hist(sante$sysBP, main = "Distribution de SYSBP", xlab = "SYSBP", col = "lightgreen", border = "black")
hist(sante$diaBP, main = "Distribution de DIABP", xlab = "DIABP", col = "lightcoral", border = "black")
hist(sante$BMI, main = "Distribution de BMI", xlab = "BMI", col = "lightgoldenrodyellow", border = "black")

#**************************************SCATTERPLOT******************************************************

# Ouvrir une nouvelle fenêtre graphique avec une taille personnalisée
windows(width = 12, height = 10)

# Définir le nombre de rangées et de colonnes pour les sous-plots
par(mfrow = c(4, 1))

# Sélectionner les variables
mat_nuage <- sante[, c("age", "cigsPerDay", "sysBP", "BMI")]
# Créer la matrice de nuages de points
pairs(mat_nuage,
      label = c("Âge", "Cigarettes par jour", "Pression artérielle systolique","Indice de masse corporelle
"))


#************************************variables qualitatives*******************************************
#************************************diagramme en barres *******************************************

# Sélectionner les variables qualitatives d'intérêt
qualit<- c("male", "currentSmoker", "diabetes", "prevalentHyp")

# Créer un sous-ensemble du dataframe avec les variables d'intérêt
df_qualitatives <- sante[, qualit]

# Rassembler les données pour le graphique en barres
df_melted <- reshape2::melt(df_qualitatives)

# Ouvrir une nouvelle fenêtre graphique avec une taille personnalisée
windows(width = 12, height = 10)

# Définir le nombre de rangées et de colonnes pour les sous-plots
par(mfrow = c(4, 1))

# Tracer le barplot
ggplot(df_melted, aes(x = variable, fill = factor(value))) +
  geom_bar() +
  labs(title = "Distribution des variables qualitatives",
       x = "Variables qualitatives",
       y = "Count") +
  scale_fill_manual(values = c("0" = "skyblue", "1" = "salmon")) +  # Couleurs pour les variables binaires
  theme_minimal()

#************************************diagramme en secteurs *******************************************
# Ouvrir une nouvelle fenêtre graphique avec une taille personnalisée
windows(width = 12, height = 12)

# Définir le nombre de rangées et de colonnes pour les sous-plots
par(mfrow = c(3, 2))

# Fonction pour créer un diagramme en secteurs avec des couleurs spécifiques et les pourcentages
draw_pie_chart <- function(data, labels, main, colors) {
  # Calculer le pourcentage
  percentage <- table(data) / length(data) * 100
  
  # Tracer le diagramme en secteurs avec les pourcentages
  pie(percentage, labels = paste(labels, sprintf("%.1f%%", percentage)),
      main = main,
      col = colors)
}

# Définir des couleurs pour chaque variable
colors_current_smoker <- c("skyblue", "salmon")
colors_bpmeds <- c("lightgreen", "lightcoral")
colors_stroke <- c("gold", "darkorange")
colors_hyp <- c("lightblue", "lightpink")
colors_diabetes <- c("lightcyan", "darkorange")
colors_male <- c("lightgrey", "darkgrey")

# Tracer les diagrammes en secteurs pour chaque variable
draw_pie_chart(sante$currentSmoker, c("Non-Smoker", "Smoker"), "Current Smoker", colors_current_smoker)
draw_pie_chart(sante$BPMeds, c("No BPMeds", "BPMeds"), "BPMeds", colors_bpmeds)
draw_pie_chart(sante$prevalentStroke, c("No Stroke", "Stroke"), "Prevalent Stroke", colors_stroke)
draw_pie_chart(sante$prevalentHyp, c("No Hypertension", "Hypertension"), "Prevalent Hypertension", colors_hyp)
draw_pie_chart(sante$diabetes, c("No Diabetes", "Diabetes"), "Diabetes", colors_diabetes)
draw_pie_chart(sante$male, c("Female", "Male"), "Gender", colors_male)


#************************************Préparation des données*******************************************
#*************************************Nettoyage des données**********************************************
# Variables avec des valeurs manquantes
variables_manquantes <- c("education", "cigsPerDay", "BPMeds", "totChol", "BMI", "heartRate", "glucose")

# Imputation avec la médiane
for (variable in variables_manquantes) {
  median_value <- median(sante[[variable]], na.rm = TRUE)
  sante[[variable]][is.na(sante[[variable]])] <- median_value
}
summary(sante)

# Supprimer temporairement la variable "TenYearCHD"
sante_test <- subset(sante, select = -TenYearCHD)

# Variables binaires à convertir en facteurs
binaires <- c("male", "currentSmoker", "BPMeds", "prevalentStroke", "prevalentHyp", "diabetes")

# Convertir les variables binaires en facteurs
sante_test[binaires] <- lapply(sante_test[binaires], as.factor)

# Vérifier le résultat
str(sante_test)
View(sante_test)

#*****************************************K-MEANS*************************************************
# Sélectionner les variables à utiliser pour le clustering
variables_clustering <- c("age", "sysBP", "diaBP", "BMI", "cigsPerDay", "totChol", "heartRate", "glucose")

# Créer un sous-ensemble du dataframe avec les variables à clusteriser
data_cluster <- sante_test[variables_clustering]

# Normaliser les données pour le K-means
scaled_data <- scale(data_cluster)

# Déterminer le nombre optimal de clusters
wss <- numeric(10)
for (i in 1:10) {
  wss[i] <- sum(kmeans(scaled_data, centers = i)$withinss)
}

# Tracer le graphique pour choisir le nombre optimal de clusters
plot(1:10, wss, type = "b", xlab = "Nombre de clusters", ylab = "Within Sum of Squares")

# Choisir le nombre optimal de clusters (par exemple, 3)
k_optimal <- 3

# Appliquer K-means
kmeans_result <- kmeans(scaled_data, centers = k_optimal)

# Ajouter les résultats au dataframe
sante_test$cluster <- as.factor(kmeans_result$cluster)


# Tracer le graphique de clusters
fviz_cluster(list(data = scaled_data, cluster = kmeans_result$cluster), geom = "point",
             ellipse.type = "convex", main = "Cluster Plot", ggtheme = theme_minimal())

#*****************************************ACP*************************************************
# Sélectionner les variables pour l'ACP
variables_acp <- c("age", "sysBP", "diaBP", "BMI", "cigsPerDay", "totChol", "heartRate", "glucose")

# Créer un sous-ensemble du dataframe avec les variables pour l'ACP
data_acp <- sante_test[variables_acp]

# Standardiser les données pour l'ACP
scaled_data_acp <- scale(data_acp)

# Appliquer l'ACP
acp_result <- prcomp(scaled_data_acp, center = TRUE, scale = TRUE)

# Résumé des composantes principales
summary(acp_result)


# Tracer le graphique des valeurs propres avec les noms des variables
fviz_eig(acp_result, addlabels = TRUE, ylim = c(0, 40))

# Tracer le biplot des deux premières composantes principales
biplot(acp_result, scale = 0)

#*****************************************CAH*************************************************
# Calculer la matrice de distances euclidiennes
distances <- dist(scaled_data_acp)

# Effectuer l'analyse hiérarchique ascendante (CAH)
cah_result <- hclust(distances, method = "ward.D2")

# Découper l'arbre en k clusters 
k_clusters <- 2
clusters <- cutree(cah_result, k = k_clusters)

# Visualiser le dendrogramme et les clusters
plot(cah_result, hang = -1, main = "Dendrogramme CAH")
rect.hclust(cah_result, k = k_clusters, border = 2:k_clusters)

# Ajouter les informations de cluster à votre dataframe
sante_test$cluster <- clusters

# Visualiser la répartition des clusters
table(sante_test$cluster)

# Calculer les moyennes des variables d'ACP pour chaque cluster
cluster_means <- aggregate(. ~ cluster, data = sante_test[, c("cluster", variables_acp)], mean)
print(cluster_means)

#************************************Modélisation*******************************************
summary(sante)
#************************************KNN****************************************************
#On va determiner K (quel nombre choisir)
# Sélectionner la variable cible
variable_cible <- "TenYearCHD"

# Diviser les données en ensemble d'apprentissage et d'essai
set.seed(123)
indices <- createDataPartition(sante$TenYearCHD, p = 0.7, list = FALSE)
train_data <- sante[indices, ]
test_data <- sante[-indices, ]

# Utiliser la fonction train avec la validation croisée pour déterminer K
grid_k <- data.frame(k = seq(1, 20, by = 2))
ctrl <- trainControl(method = "cv", number = 10)
model <- train(
  x = train_data[, setdiff(names(sante), variable_cible)],
  y = train_data$TenYearCHD,
  method = "knn",
  trControl = ctrl,
  tuneGrid = grid_k
)

# Afficher les résultats
print(model)

# Utiliser le modèle k-NN avec le K optimal
k_optimal <- model$bestTune$k
knn_model <- knn(
  train = train_data[, setdiff(names(sante), variable_cible)],
  test = test_data[, setdiff(names(sante), variable_cible)],
  cl = train_data$TenYearCHD,
  k = k_optimal
)

# Afficher la matrice de confusion
confusion_matrix <- confusionMatrix(knn_model, as.factor(test_data$TenYearCHD))
print(confusion_matrix)


#************************************Régression Logistique****************************************************
# Diviser les données en ensembles d'apprentissage et de test
set.seed(123)
indices <- createDataPartition(sante$TenYearCHD, p = 0.7, list = FALSE)
train_data <- sante[indices, ]
test_data <- sante[-indices, ]

# Convertir les variables binaires en facteurs
binaires <- c("male", "currentSmoker", "BPMeds", "prevalentStroke", "prevalentHyp", "diabetes")
train_data[binaires] <- lapply(train_data[binaires], as.factor)
test_data[binaires] <- lapply(test_data[binaires], as.factor)

# Sélectionner les variables explicatives
variables_explicatives <- setdiff(names(sante), "TenYearCHD")

# Entraîner le modèle de Régression Logistique
logistic_model <- glm(
  formula = as.formula(paste("TenYearCHD ~", paste(variables_explicatives, collapse = "+"))),
  data = train_data,
  family = "binomial"
)

# Faire des prédictions sur l'ensemble de test
logistic_predictions_prob <- predict(logistic_model, newdata = test_data, type = "response")
logistic_predictions <- ifelse(logistic_predictions_prob > 0.5, 1, 0)

# Créer la matrice de confusion
confusion_matrix_logistic <- confusionMatrix(as.factor(logistic_predictions), as.factor(test_data$TenYearCHD))
print(confusion_matrix_logistic)

#************************************Régression Linéaire****************************************************
# Diviser les données en ensembles d'apprentissage et de test
set.seed(123)
indices <- createDataPartition(sante$cigsPerDay, p = 0.7, list = FALSE)
train_data <- sante[indices, ]
test_data <- sante[-indices, ]

# Définir la formule pour le modèle de régression linéaire avec cigsPerDay comme variable cible
formule <- as.formula("cigsPerDay ~ age + sysBP + diaBP + BMI + male + currentSmoker + BPMeds + prevalentStroke + prevalentHyp + diabetes + totChol + heartRate + glucose")

# Entraîner le modèle de régression linéaire
linear_model <- lm(formula = formule, data = train_data)

# Faire des prédictions sur l'ensemble de test
linear_predictions <- predict(linear_model, newdata = test_data)

# Afficher le résumé du modèle
summary(linear_model)

# Évaluer la performance du modèle de régression linéaire
rmse <- sqrt(mean((linear_predictions - test_data$cigsPerDay)^2))
print(paste("RMSE:", rmse))

# Visualiser les prédictions par rapport aux valeurs réelles
plot(test_data$cigsPerDay, linear_predictions, main = "Régression Linéaire : Prédictions vs. Réalités", xlab = "Valeurs Réelles", ylab = "Prédictions")
abline(0, 1, col = "red")  # Ajouter la ligne d'identité

#************************************ADD****************************************************
# Définir les variables explicatives et la variable cible
variables_explicatives <- setdiff(names(train_data), "cigsPerDay")
variable_cible <- "cigsPerDay"

# Convertir les variables binaires en facteurs
binaires <- c("male", "currentSmoker", "BPMeds", "prevalentStroke", "prevalentHyp", "diabetes")
train_data[binaires] <- lapply(train_data[binaires], as.factor)
test_data[binaires] <- lapply(test_data[binaires], as.factor)

# Entraîner le modèle Random Forest
rf_model <- randomForest(x = train_data[, variables_explicatives],
                         y = train_data[, variable_cible],
                         importance = TRUE,
                         ntree = 500)
# Afficher les résultats
print(rf_model)

# Prédictions sur l'ensemble de test
rf_predictions <- predict(rf_model, newdata = test_data)

# Évaluation de la performance
rmse_rf <- sqrt(mean((rf_predictions - test_data$cigsPerDay)^2))
print(paste("RMSE (Random Forest):", rmse_rf))

# Tracer le graphique des prédictions par rapport aux vraies valeurs
plot(test_data$cigsPerDay, rf_predictions, main = "Prédiction vs Vraies valeurs",
     xlab = "Vraies valeurs", ylab = "Prédiction", pch = 16, col = "blue")

# Tracer la droite d'identité (y = x)
abline(0, 1, col = "red")

#************************************Evaluation*******************************************
# ************************************Classification****************************************************

# ************************************KNN****************************************************

# Afficher la courbe ROC pour le modèle KNN
roc_knn <- roc(test_data$TenYearCHD, as.numeric(knn_model))
auc_knn <- auc(roc_knn)

# Tracer la courbe ROC
plot(roc_knn, main = "Courbe ROC - k-NN",
     col = "blue", lwd = 2, cex.lab = 1.2, cex.axis = 1.2)
text(0.5, 0.1, paste("AUC = ", round(auc_knn, 3)), col = "blue", cex = 1.2)

# ************************************Régression Logistique****************************************************

# Afficher la courbe ROC pour le modèle de régression logistique
roc_logistic <- roc(test_data$TenYearCHD, logistic_predictions_prob)
auc_logistic <- auc(roc_logistic)

# Tracer la courbe ROC
plot(roc_logistic, main = "Courbe ROC - Régression Logistique",
     col = "red", lwd = 2, cex.lab = 1.2, cex.axis = 1.2)
text(0.5, 0.1, paste("AUC = ", round(auc_logistic, 3)), col = "red", cex = 1.2)

# ************************************Régression Linéaire****************************************************

# Tracer le graphique des prédictions par rapport aux vraies valeurs
plot(test_data$cigsPerDay, linear_predictions, main = "Régression Linéaire : Prédictions vs. Réalités", xlab = "Valeurs Réelles", ylab = "Prédictions")
abline(0, 1, col = "red")  # Ajouter la ligne d'identité

# ************************************ADD****************************************************

# Afficher la courbe ROC pour le modèle ADD
roc_rf <- roc(test_data$cigsPerDay, rf_predictions)
auc_rf <- auc(roc_rf)

# Tracer la courbe ROC
plot(roc_rf, main = "Courbe ROC - ADD",
     col = "green", lwd = 2, cex.lab = 1.2, cex.axis = 1.2)
text(0.5, 0.1, paste("AUC = ", round(auc_rf, 3)), col = "green", cex = 1.2)

# Tracer la droite d'identité (y = x)
abline(0, 1, col = "red")

# Tracer le graphique des prédictions par rapport aux vraies valeurs
plot(test_data$cigsPerDay, rf_predictions, main = "Prédiction vs Vraies valeurs",
     xlab = "Vraies valeurs", ylab = "Prédiction", pch = 16, col = "green")

# Tracer la droite d'identité (y = x)
abline(0, 1, col = "red")

# ************************************Dépoloiement****************************************************

# Charger les données de test (vous pouvez utiliser la même méthode que pour les données d'apprentissage)
# Assurez-vous que les données de test ont les mêmes transformations que les données d'apprentissage

# Convertir les variables binaires en facteurs
binaires_test <- c("male", "currentSmoker", "BPMeds", "prevalentStroke", "prevalentHyp", "diabetes")
test_data[binaires_test] <- lapply(test_data[binaires_test], as.factor)

# Sélectionner les variables explicatives
variables_explicatives_test <- setdiff(names(test_data), "TenYearCHD")

# Faire des prédictions sur l'ensemble de test avec le modèle de régression logistique
logistic_predictions_prob_test <- predict(logistic_model, newdata = test_data, type = "response")
logistic_predictions_test <- ifelse(logistic_predictions_prob_test > 0.5, 1, 0)

# Créer la matrice de confusion
confusion_matrix_logistic_test <- confusionMatrix(as.factor(logistic_predictions_test), as.factor(test_data$TenYearCHD))
print(confusion_matrix_logistic_test)

# Afficher la courbe ROC pour le modèle de régression logistique sur l'ensemble de test
roc_logistic_test <- roc(test_data$TenYearCHD, logistic_predictions_prob_test)
auc_logistic_test <- auc(roc_logistic_test)

# Tracer la courbe ROC
plot(roc_logistic_test, main = "Courbe ROC - Régression Logistique (Ensemble de Test)",
     col = "blue", lwd = 2, cex.lab = 1.2, cex.axis = 1.2)
text(0.5, 0.1, paste("AUC = ", round(auc_logistic_test, 3)), col = "blue", cex = 1.2)








