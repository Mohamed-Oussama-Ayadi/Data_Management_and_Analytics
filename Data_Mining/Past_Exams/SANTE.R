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

#************************************variables qualitatives*******************************************

# Matrice de nuages de points (scatterplot) pour "age", "cigsPerDay", "totChol", "sysBP"
scatterplot <- c("age", "cigsPerDay", "totChol", "sysBP")

scatterplot_matrix <- ggplot(sante, aes(x = sante[[scatterplot[1]]], 
                                        y = sante[[scatterplot[2]]])) +
  geom_point() +
  labs(title = "Matrice de Nuages de Points",
       x = scatterplot[1],
       y = scatterplot[2])

# Afficher la matrice de nuages de points
print(scatterplot_matrix)

