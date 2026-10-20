#**************************************DATA_TENNIS************************************************
#*****Comprehension des donnees*******************************************************************
tennis<-read.table(file = file.choose(),header = TRUE,fileEncoding = 'latin1')
View(tennis)
tennis
summary(tennis)
library(rpart)
?rpart
?rpart.control
#par defaut 20 observations, or dans notre dataset on n'a que 14 
ad.tennis.cnt<-rpart.control(minsplit = 1)
ad.tennis<-rpart(Jouer~Ciel+Température+Humidité+Vent,tennis,control=ad.tennis.cnt)
text(ad.tennis, use.n = TRUE, all = TRUE, cex = 0.7)
ad.tennis
#*****Interpretation des résultats:*********
#  une '*' = une décision = une feuille
# n=14, nbr d'obs initiales; 5 classées oui
# SI Ciel=couvert [Noeud pur, IG=0]                                       -> Jouer = OUI 
# SI Ciel= ensoleillé, pluie -> Humidité(>=82.2) -> Température (>=20.25) -> Jouer = NON
#                                                -> Température (<20)     -> Jouer = OUI 
#                            -> Humidité(<82.5)  -> Température (<18.25)  -> Jouer = NON
#                                                -> Température (>=18.25) -> Jouer = OUI
#Taille de l'arbre = NOMBRE DE NOEUDS (ici c'est 4)
plot (ad.tennis, uniform=T); text (ad.tennis, use.n=T, all=T)
plot (ad.tennis, branch=0); plot (ad.tennis, branch=.7); text (ad.tennis, use.n=T)
plot (ad.tennis, branch=.4, uniform=T, compress=T); text (ad.tennis, all=T,use.n=T)
plot (ad.tennis, branch=.2, uniform=T, compress=T, margin=.1); text (ad.tennis, all=T, use.n=T, fancy=T)
#predict (modele, data_test)
tennis2<-read.table(file = file.choose(),header = TRUE,fileEncoding = 'latin1')
View(tennis2)
predict(ad.tennis,tennis2)



