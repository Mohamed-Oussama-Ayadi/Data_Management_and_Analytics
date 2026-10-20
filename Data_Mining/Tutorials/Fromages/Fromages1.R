#**************************************DATA_FROMAGES************************************************
#**************************************Salma Damak & Med Azyz Nguira*********************************
#**************************************4ERP-BI4******************************************************
#*****Comprehension des donnees**************************************************************
#sélectionner un fichier à partir du système de fichiers
fromages<-read.table(file = file.choose(),header = TRUE,row.names=1, sep = "\t",dec=".")
#afficher la Base de données fromages
View(fromages)
#génère un résumé statistique des variables contenues dans fromages
summary(fromages)
#renvoie les noms des colonnes (variables) de fromages
names(fromages)
#affiche la structure de fromages
str(fromages)
dim(fromages)
#*****preparation des donnees*****************************************************************
#graphique - croisement deux à deux
pairs(fromages)
#on elimine les données qualitatives (si on n'a pas utlisé row.names=1)
#fromages.seg<-fromages[,2:10] # fromages[lignes,colonnes] 
#dim(fromages.seg)
#View(fromages.seg)
#***************************************************************
#centrage réduction des données
#pour éviter que variables à forte variance pèsent indûment sur les résultats
fromages.cr <- scale(fromages,center=T,scale=T)
#center=T la fonction effectue le centrage des données. 
#scale=T la fonction effectue la réduction des données.
#******Modelisation des données***************************************************************
#pour connaitre le nombre de clusters à choisir
fviz_nbclust(fromages.seg,kmeans,method="wss")
#************K-MEANS**************************************************************************
k<-kmeans(fromages.seg,4) #4 c'est le nombre de classes
k
k$centers
library(cluster)
#visualisation des clusters
if(!require(devtools)) install.packages("devtools")
devtools::install_github("kassambara/factoextra")
library(factoextra)
install.packages("ggpubr",
                 repos = "https://cloud.r-project.org/",
                 dependencies = TRUE)
?fviz_cluster
fviz_cluster(k, fromages.seg,
             label="both",
             repel=TRUE,
             palette = c("#2E9FDF", "#00AFBB", "#E7B800","#FF6688"), 
             geom = "point",
             ellipse.type = "convex", 
             ggtheme = theme_bw()
)
#**************Evaluation************************************************************************************
#matrice de frequence des clusters
table(fromages$Fromages,k$cluster)
# Création d'un tableau de fréquence des clusters
cluster_freq <- table(fromages$Fromages, k$cluster)
# Création d'un diagramme à barres pour visualiser le nombre de fromages dans chaque cluster
#barplot(cluster_freq, beside = TRUE, col = rainbow(max(k$cluster)), 
#        xlab = "Fromages", ylab = "Nombre de fromages par cluster", 
#        main = "Nombre de fromages par cluster")
# Affichage de la matrice sous forme de heatmap
heatmap(cluster_freq, col = colorRampPalette(c("white", "blue"))(20), 
        xlab = "Clusters", ylab = "Fromages", main = "Matrice de fréquence des clusters")
#************ CAH ************************************************************************************
library(cluster)
#matrice des distances entre individus
dm<-dist(fromages.cr) 
#utilisant le carré de la distance (WARD)
dendo<-hclust(dm,method = "ward.D")
summary(dendo)
#affichage dendrogramme
plot(dendo)
#dendrogramme avec matérialisation des groupes
rect.hclust(dendo,k=5)
#découpage en 5 groupes
groupes.cah <- cutree(dendo,k=5)
#afficher les groupes
print(sort(groupes.cah))
#L'inertie est une mesure de la similarité des clusters
inertie<-sort(dendo$height,decreasing = TRUE)
#Verifier si notre choix de nombre des clusters est juste
plot(inertie[1:20],type="S",xlab="Nombre de classes",ylab="Inertie")
