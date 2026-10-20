#**************************************DATA_BREAST************************************************
#Preparation des données
rm(list=ls())
#chargement des package necessaires
library(rpart)
#chargement de l’échantillon d'apprentissage
breast <- read_excel(file.choose())
#chargement de l’échantillon test
breast.test <- breast[,-10] 
#appel du package 'rpart' pour l'induction des arbres
ad.breast.cnt<- rpart.control (minsplit = 1)
#Comprehension des données
View(breast)
summary(breast)
head(breast)
#arbre de décision avec paramètres par défaut
ad.breast.cnt<- rpart.control (minsplit = 1)
ad.breast <- rpart(classe ~ clump + ucellsize + ucellshape + mgadhesion + sepics +bnuclei + bchromatin + normnucl + mitoses  , data = breast, control = ad.breast.cnt)
summary(ad.breast)
# Tracer l'arbre
plot(ad.breast)
# Ajouter du texte aux nœuds
text(ad.breast, use.n = TRUE, all = TRUE, cex = 0.7)
#prédiction sur l'échantillon test
pred.classe <- predict(ad.breast, newdata = breast.test, type = "class")
print(summary(pred.classe))
plot(pred.classe)
#matrice de confusion
names(breast.test)
str(breast.test)
mc <- table(breast.test$clump, pred.classe)
print(mc)
plot(mc)
#taux d'erreur
erreur <- (mc[2,1]+mc[1,2])/sum(mc)
print(erreur)


