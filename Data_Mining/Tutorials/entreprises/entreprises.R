#sélectionner un fichier à partir du système de fichiers
entreprise<-read.table(file = file.choose(),header = TRUE,row.names=1, sep = "\t",dec=".")
#*****Comprehension des donnees**************************************************************
#afficher la Base de données 
View(entreprise)
#génère un résumé statistique des variables contenues dans la bd
summary(entreprise)
#renvoie les noms des colonnes (variables) 
names(entreprise)
#affiche la structure de la bd
str(entreprise)
dim(entreprise)
#on elimine les données qualitatives
entreprise.seg<-entreprise[,1:4]
dim(entreprise.seg)
View(entreprise.seg)
#ACP
ACP<-PCA(entreprise.seg)
summary(ACP)
#matrice de correlation
cor(entreprise.seg)
library(factoextra)
#Cercle de correlation
fviz_pca_var(ACP, col.var = "cos2", 
                     gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"), repel = TRUE )
#Qualité de representation
#interpreter le graphique (voir pdf)
#cos2 total des variables sur Dim1 et Dim2
library(FactoMineR)
# Calcul de la qualité de représentation des variables
qualite <- entreprise.seg$cos2[,1:2]
# Calcul de la somme des cos2 des variables
qualite.total <- sum(qualite)
# Affichage de la qualité de représentation des variables
qualite.total

#Biplot variables - individus
fviz_pca_biplot(ACP)



