#**************************************DATA_AUTOMOBILES************************************************
autos<-read.table(file = file.choose(),header = TRUE, row.names=1, sep = "\t",dec=".")
View(autos)
head(autos)
summary(autos)
#Régression linaire multiple 
?lm
autos
attach(autos)
scale(autos)
reg<-lm(conso ~ ., data= autos)
print(reg)
# intercept = alpha 0 , prix = alpha 1 .....
#le plus important : puissance,poids, prix, cylindree
summary(reg)
attributes(summary(reg))
#manipulation directe des coefficients 
resume <- summary(reg)
print(resume)
print(resume$coefficients)
nrow(resume$coefficients)
print(resume$coefficients[1,"Std. Error"])
print(resume$coefficients[1,2])
?qqnorm
qqnorm(reg$fitted.values)
#MODELE REDUIT
??stepAIC
library(MASS)
?stepAIC
modele_reduit<-stepAIC(reg)
summary(modele_reduit)
#TEST
autos_test <- autos[1:4, ]
autos_test$consoG <- predict(reg, newdata = autos_test)
autos_test$consoR <- predict(modele_reduit, newdata = autos_test)
#graphiques des résidus
# Assuming 'modele_reduit' is your final model
residuals <- residuals(modele_reduit)

# Check lengths of autos[, j] and residuals for each variable
for (j in 1:5) {
  print(paste("Checking lengths for", names(autos)[j]))
  print(paste("Length of", names(autos)[j], ":", length(autos[, j])))
  print(paste("Length of residuals:", length(residuals)))
}

# Plot residuals against each variable with adjusted margins
par(mfrow = c(3, 2), mar = c(4, 4, 2, 2))
for (j in 1:5) {
  if (length(autos[, j]) == length(residuals)) {
    print(paste("Plotting for", names(autos)[j]))
    plot(autos[, j], residuals, ylab = "Résidus", xlab = names(autos)[j])
    abline(h = 0)
  } else {
    warning(paste("Skipping plot for", names(autos)[j], "due to length mismatch"))
  }
}
layout(1)  # Réinitialiser après coup l’espace graphique
#calcul du résidu studentisé
res.student <- rstudent(reg)
#risque alpha = 0.1
alpha <- 0.1
#calcul du seuil à partir de la loi de Student à (n-p-2) ddl
seuil.student <- qt(1-alpha/2,31-4-2)
#construction du graphique des résidus standardisés
plot(autos$conso,res.student)
abline(h=-seuil.student)
abline(h=+seuil.student)
abline(h=0)
#détection des points en dehors des tuyaux
ab.student <- autos[res.student < -seuil.student | res.student > +seuil.student,]
#mettre en évidence les points atypiques dans le graphique
for (i in 1:nrow(ab.student)){
  vehicule <- row.names(ab.student)[i]
  text(autos[vehicule,"conso"],res.student[vehicule],vehicule)
}
# Calculate the threshold for leverage values
seuil.hat <- qnorm(1 - 0.1 / 2) / sqrt(nrow(autos))
# Vecteur booléen indicateur de suspicion pour résidu studentisé
b.student <- (res.student < -seuil.student | res.student > +seuil.student)
# Vecteur booléen indicateur de suspicion pour le levier
b.hat <- (hatvalues(modele_reduit) > seuil.hat)
# Booléen indicateur de détection au moins une fois
b.suspicious <- b.student | b.hat
# Booléen indicateur de non détection
b.not.suspicious <- !b.suspicious
# Data.frame autos sans les données suspectes Æ 26 obs. a priori
autos.clean <- autos[b.not.suspicious, ]
print(nrow(autos.clean))
print(autos.clean)
# Régression sur les données "clean"
reg.clean <- lm(conso ~ ., data = autos.clean)
# Afficher le résumé de la régression
summary(reg.clean)

