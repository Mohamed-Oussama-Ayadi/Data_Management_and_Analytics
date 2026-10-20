View(iris)
#*****Comprehension des donnees**************************************************************
dim(iris)
levels(iris$Species)
summary(iris)
#boxplot(iris)
#*********************************************************************************************
#*****preparation des donnees*****************************************************************
#on elimine les données qualitatives
iris.seg<-iris[,1:4] #ou bien [,-5] // iris[lignes,colonnes] 
dim(iris.seg)
#*********************************************************************************************
#******Modelisation des données***************************************************************
#*pour connaitre le nombre de classes On commence par CAH, car K-means a besoin de savoir le nombre des classes
#************K-MEANS**************************************************************************
?kmeans
k<-kmeans(iris.seg,3) #3 c'est le nombre de classes
k
k$centers
?plot
library(cluster)
#visualisation des clusters (clusplot / fviz-cluster)
#***********METHODE 1 : fviz_cluster ********************************************************
if(!require(devtools)) install.packages("devtools")
devtools::install_github("kassambara/factoextra")
library(factoextra)
install.packages("ggpubr",
                 repos = "https://cloud.r-project.org/",
                 dependencies = TRUE)
?fviz_cluster
fviz_cluster(k, iris.seg,
             palette = c("#2E9FDF", "#00AFBB", "#E7B800"), 
             geom = "point",
             ellipse.type = "convex", 
             ggtheme = theme_bw()
)
#*********METHODE 2 : clusplot*********************************************************************
install.packages("ClusterR")
library(ClusterR)
library(cluster)
?clusplot
y_kmeans<-k$cluster
clusplot(iris.seg[,c("Sepal.Length","Sepal.Width")],
         y_kmeans,
         lines=0,
         shade=TRUE,
         color=TRUE,
         labels=2,plotchar=FALSE,
         span=TRUE,
         main=paste("Cluster iris"),
         xlab='Sepal.Length',ylab='Sepal.width')
#create plot of number of clusters vs total within sum of squares (si je n'ai pas une idée sur le nombre de clusters)
fviz_nbclust(iris.seg,kmeans,method="wss")
#pour visualiser le nombre de clusters
#wss : inertie totale
#on remarque que la stabilisation de l'"elbow" entre 2 et 3 (donc on va choisir soit 2 ou 3 clusters)
#**************Evaluation************************************************************************************
table(iris$Species,k$cluster)
#on va voir le TBC & TMC (taux de bonne classification et taux de mauvaise classification)
# Accuracy (précision) :: TBC= [(50+48+36)/150]   =89%
#TMC = 100-89 = 11%
#taux de bonne classification par cluster
#TBC3 = 50/50 = 100% (TMC=0%)
#TBC1 = 48/62 = 77%  (TMC=23%)
#TBC2 = 36/38 = 94%  (TMC=6%)
#************ CAH ************************************************************************************
library(cluster)
dm1<-dist(iris.seg) #150*15 (matrice de distance)
?hclust
dendo1<-hclust(dm1,method = "ward")
summary(dendo1)
plot(dendo1)
inertie<-sort(dendo1$height,decreasing = TRUE)
plot(inertie[1:20],type="S",xlab="Nombre de classes",ylab="Inertie")
