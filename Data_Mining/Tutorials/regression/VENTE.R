#**************************************DATA_VENTES************************************************
#Importation et affichage des données
library(readxl)
vente_train <- read_excel(file.choose(), sheet = "VENTES.TRAIN")
View(vente_train)
print(summary(vente_train))
#régression complète sur l'échantillon d'apprentissage
modele.full <- lm( VENTES~ ., data = vente_train)
print(modele.full)
resume <- summary(modele.full)
print(resume)
#modèle avec sélection de variables
library(MASS)
modele.selection <- stepAIC(modele.full)  # Spécifiez l'objet de régression
print(summary(modele.selection))
#charger les données - échantillon test
vente_test <- read_excel(file.choose(), sheet = "VENTES.TEST")
#prédiction du modèle par défaut
pred.def <- mean(vente_train$VENTES)
ssr.ref <- sum((vente_test$VENTES - pred.def)^2)
print(ssr.ref)
# Prédiction du modèle complet
pred.full <- predict(modele.full, newdata = vente_test)
ssr.full <- sum((vente_test$VENTES - pred.full)^2)
print(ssr.full)
# Comparaison par rapport à la référence
rsq.full <- 1.0 - ssr.full/ssr.ref
print(rsq.full)
# Prédiction du modèle avec sélection de variables
pred.sel <- predict(modele.selection, newdata = vente_test)
ssr.selection <- sum((vente_test$VENTES - pred.sel)^2)
print(ssr.selection)
rsq.selection <- 1.0 - ssr.selection/ssr.ref
print(rsq.selection)
#*****Etude des points atypiques*****************
# Calcul du résidu standardisé
res.standard <- rstandard(modele.full)
# Risque alpha = 0.1
alpha <- 0.1
# Calcul du seuil à partir de la loi de Student à (n-p-1) ddl
seuil.standard <- qt(1 - alpha / 2, 31 - 4 - 1)
# Construction du graphique des résidus standardisés
plot(vente_train$VENTES, res.standard)
# Ajout des seuils dans le graphique
abline(h = -seuil.standard)
abline(h = +seuil.standard)
abline(h = 0)
# Détection des points en dehors des tuyaux, on obtient le tableau des obs. atypiques
ab.standard <- vente_train[res.standard < -seuil.standard | res.standard > +seuil.standard,]
# Mettre en évidence les points atypiques dans le graphique
for (i in 1:nrow(ab.standard)) {
  # On récupère une chaîne de caractères, la désignation du véhicule
  aty <- row.names(ab.standard)[i]
  # On place le point atypique (au sens du résidu standardisé) dans le graphique
  text(vente_train[aty, "VENTES"], res.standard[aty], aty)
}
