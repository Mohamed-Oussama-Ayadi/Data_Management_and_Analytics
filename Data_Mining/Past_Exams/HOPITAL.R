#**************************************DATA_HOPITAL************************************************
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

#**************************************CHARGEMENT DES DONNÉES********************************************
hopital <- read.csv(file.choose())
View(hopital)
summary(hopital)

#**************************************PRÉPARATION DES DONNÉES********************************************
# Remplacer les valeurs manquantes par NULL
hopital <- hopital %>% mutate_all(~ ifelse(is.na(.), -1, .))

# Convertir les variables binaires en facteurs
binary_vars <- c('male', 'prevalentStroke', 'prevalentHyp', 'diabetes', 'BPMeds', 'TenYearCHD')
hopital[binary_vars] <- lapply(hopital[binary_vars], as.factor)

#**************************************VISUALISATION********************************************
# Ouvrir une nouvelle fenêtre graphique avec une taille personnalisée
windows(width = 12, height = 10)

# Définir le nombre de rangées et de colonnes pour les sous-plots
par(mfrow = c(4, 1))

# Tracer les histogrammes
hist(hopital$age, main = "Distribution des Âges", xlab = "Âge", col = "lightblue", border = "black")
hist(hopital$sysBP, main = "Distribution de SYSBP", xlab = "SYSBP", col = "lightgreen", border = "black")
hist(hopital$diaBP, main = "Distribution de DIABP", xlab = "DIABP", col = "lightcoral", border = "black")
hist(hopital$BMI, main = "Distribution de BMI", xlab = "BMI", col = "lightgoldenrodyellow", border = "black")

# Diagramme de dispersion
pairs(~age+sysBP+diaBP+BMI, data = hopital, main = "Diagramme de Dispersion")

# Matrice de corrélation
cor_matrix <- cor(hopital[, c('age', 'sysBP', 'diaBP', 'BMI')])
corrplot(cor_matrix, method = "color")
dev.off()
#**************************************MODELISATION********************************************
# Arbre de décision
ad_hopital <- rpart(TenYearCHD ~ age + education + currentSmoker + cigsPerDay + BPMeds + prevalentStroke + prevalentHyp + diabetes + totChol + sysBP + diaBP + BMI + heartRate + glucose, 
                    data = hopital, 
                    method = "class", 
                    control = rpart.control(minsplit = 1))

# Convertir la variable cible en facteur
hopital$TenYearCHD <- as.factor(hopital$TenYearCHD)

# Échantillonnage des données pour l'arbre de décision
index_tree <- sample(1:nrow(hopital), 0.8 * nrow(hopital))
train_data_tree <- hopital[index_tree, ]
test_data_tree <- hopital[-index_tree, ]

# Construction de l'arbre de décision avec rpart
ad_hopital <- rpart(TenYearCHD ~ age + education + currentSmoker + cigsPerDay + BPMeds + prevalentStroke + prevalentHyp + diabetes + totChol + sysBP + diaBP + BMI + heartRate + glucose, 
                    data = train_data_tree, 
                    method = "class", 
                    control = rpart.control(minsplit = 5))

# Afficher des informations sur le modèle
print(ad_hopital)

# Ajuster les marges
par(mar = c(2, 2, 2, 2))

# Tracer l'arbre de décision
plot(ad_hopital)
text(ad_hopital, use.n = TRUE, all = TRUE, cex = 0.7)


#**************************************ÉVALUATION********************************************
# Évaluation du modèle sur les données de test
pred_tree <- predict(ad_hopital, test_data_tree, type = "class")
conf_matrix_tree <- table(pred_tree, test_data_tree$TenYearCHD)
conf_matrix_tree

# Courbe ROC
roc_curve <- roc(as.numeric(test_data_tree$TenYearCHD), as.numeric(pred_tree))
plot(roc_curve)
auc(roc_curve)

# K-Means avec 4 clusters
hopital_kmeans <- hopital[, c('age', 'sysBP', 'diaBP', 'BMI', 'heartRate', 'glucose')]
hopital_kmeans_scaled <- scale(hopital_kmeans, center = TRUE, scale = TRUE)
kmeans_model <- kmeans(hopital_kmeans_scaled, centers = 4)

# Spécifier les couleurs
my_colors <- c("blue", "red", "green", "yellow")

# Visualisation des clusters pour K-Mean
fviz_cluster(kmeans_model, data = hopital_kmeans_scaled, 
             label = "none",  
             repel = TRUE,
             ggtheme = theme_bw(),
             palette = my_colors
)
