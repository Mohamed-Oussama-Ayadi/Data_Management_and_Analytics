#**************************************DATA_ACCOUCHEMENT************************************************
rm(list=ls())
library("readxl")
accouchement<-read_excel(file.choose())
accouchement
View(accouchement)
index <- sample(1:nrow(accouchement),0.8*nrow(accouchement)) #il va prendre aleatoirement des données
train_data<-accouchement[index,]
test_data<-accouchement[-index,]
?knn #knn(train, test, cl, k = 1, l = 0, prob = FALSE, use.all = TRUE)
library("class")
#cl	 factor of true classifications of training set cl= train$var_cible
knn_model<-knn(train = train_data[,1:13],test = test_data[,1:13],cl= train_data$PREMATURE,k=17)
knn_model
table(knn_model,test_data$PREMATURE)
#MATRICE DE CONTIGENCE
#knn_model negatif positif
#negatif       9      10
#positif      18      41
library(caret)
confusionMatrix(knn_model,as.factor(test_data$PREMATURE)) #as.factor pour les matrix
# Accuracy : 0.641 > 0.5 +/- acceptable (si on diminue le nombre de test (au lieu de 17), il va etre plus performant)
#precision 'specificity' = 0.8 , sensivitivity = 0.33 il sait classer les negatifs mais pas les positifs (plus performant dans -)
levels(test_data$PREMATURE)
View(test_data)
summary(test_data)
#which tester si notre dataset est equilibree !!!!!!!!!
#which(test_data, , )
#******************************ROC*****************************************************
predicted_labels<-as.factor(knn_model)
true_labels<-as.factor(test_data$PREMATURE)
library(pROC)
#create ROC curve (2 modalites ROC, multi-mod MROC)
#roc_curve<-roc(true_labels,predicted_probabilities)
roc_curve<-roc(as.numeric(true_labels),as.numeric(predicted_labels))
plot(roc_curve)
auc(roc_curve)
#  *** CLASSIFICATION AVEC REGRESSION LOGISTIQUE
model.glm<-glm(PREMATURE$.,)
model.glm<-
pred.glm<-predict()
table(model.glm,test_data)
?svm (e1070)
