#**************************************CREDIT_GERMAIN************************************************
#**************************************Salma Damak & Med Azyz Nguira*********************************
#**************************************4ERP-BI4******************************************************
#sélectionner un fichier à partir du système de fichiers
bd<-read.table(file = file.choose(),header = TRUE,sep = "\t")
#afficher la Base de données bd
View(bd)
#génère un résumé statistique des variables contenues dans bd
summary(bd)
#renvoie les noms des colonnes (variables) de bd
names(bd)
#affiche la structure de bd
str(bd)
#affiche les premières lignes de bd
head(bd)
#***********************************Attribute checking_status***********************************************
#génère un résumé statistique spécifique à la variable 'checking_status'
summary(bd$checking_status)
#afficher la structure de la variable 'checking_status'
str(bd$checking_status)
#recoder la variable 'checking_status' en fonction des conditions ci-dessous
bd$checking_status <- ifelse(bd$checking_status == "<0", "A11",
                             ifelse(bd$checking_status == "0<=X<200", "A12",
                                    ifelse(bd$checking_status == ">=200" | bd$disc_duration == "lo_1_year", "A13",
                                           ifelse(bd$checking_status == "no checking", "A14", bd$checking_status))))
#afficher la nouvelle version de bd 
View(bd)
#***********************************Attribute disc_duration***********************************************
#génère un résumé statistique spécifique à la variable 'disc_duration'
summary(bd$disc_duration)
#affiche la structure de 'disc_duration'
str(bd$disc_duration)
#crée un vecteur 'duration_mapping' qui associe les valeurs existantes de la variable 'disc_duration' à des durées spécifiques (12,18,24 mois)
duration_mapping <- c("lo_1_year" = 12, "1_2_years" = 18, "up_2_years" = 24)
#recode la variable 'disc_duration' (mise a jour de 'disc_duration')
bd$disc_duration <- ifelse(bd$disc_duration %in% names(duration_mapping), duration_mapping[bd$disc_duration], bd$disc_duration)
#afficher la nouvelle version de bd
View(bd)
#***********************************Attribute credit_history***********************************************
#génère un résumé statistique spécifique à la variable 'credit_history'
summary(bd$credit_history)
#affiche la structure de 'credit_history'
str(bd$credit_history)
#recoder la variable 'credit_history' en fonction des conditions ci-dessous 
bd$credit_history <- ifelse(bd$credit_history == "no credits/all paid", "A30",
                            ifelse(bd$credit_history == "all paid", "A31",
                                   ifelse(bd$credit_history == "existing paid", "A32",
                                          ifelse(bd$credit_history == "delayed previously", "A33",
                                                 ifelse(bd$credit_history == "critical/other existing" | bd$credit_history == "critical/other existing ", "A34", bd$credit_history)))))
#afficher la nouvelle version de bd
View(bd)
#***********************************Attribute purpose***********************************************
#affiche la structure de 'purpose'
str(bd$purpose)
#recoder la variable 'purpose' en fonction des conditions ci-dessous 
bd$purpose <- ifelse(bd$purpose == "new car", "A40",
                     ifelse(bd$purpose == "used car", "A41",
                            ifelse(bd$purpose == "furniture/equipment", "A42",
                                   ifelse(bd$purpose == "radio/tv", "A43", 
                                          ifelse(bd$purpose == "domestic appliance", "A44",
                                                 ifelse(bd$purpose == "repairs", "A45", 
                                                        ifelse(bd$purpose == "education", "A46",  
                                                               ifelse(bd$purpose == "vacation", "A47", 
                                                                      ifelse(bd$purpose == "retraining", "A48",  
                                                                             ifelse(bd$purpose == "business", "A49",  
                                                                                    ifelse(bd$purpose == "other", "A410",bd$purpose)))))))))))
#afficher la nouvelle version de bd
View(bd)            
#***********************************Attribute disc_amount***********************************************
#affiche la structure de 'disc_amount'
str(bd$disc_amount)
#crée un vecteur 'disc_mapping' pour associer des catégories spécifiques à des valeurs numériques (1000,1500,2000)
disc_amount_mapping <- c("lo_1000" = 1000, "1000_2000" = 1500, "up_2000" = 2000)
#recode la variable 'disc_amount' (mise a jour de 'disc_amount')
bd$disc_amount <- ifelse(bd$disc_amount %in% names(disc_amount_mapping), disc_amount_mapping[bd$disc_amount], bd$disc_amount)
#afficher la nouvelle version de bd
View(bd)                             
#***********************************Attribute saving_status***********************************************
#affiche la structure de 'saving_status'
str(bd$savings_status)
#recoder la variable 'saving_status' en fonction des conditions ci-dessous 
bd$savings_status <- ifelse(bd$savings_status == "<100", "A61",
                            ifelse(bd$savings_status == "100<=X<500", "A62",
                                   ifelse(bd$savings_status == "500<=X<1000", "A63",
                                          ifelse(bd$savings_status == ">=1000", "A64", 
                                                 ifelse(bd$savings_status == "no known savings", "A65", bd$savings_status)))))
#afficher la nouvelle version de bd
View(bd)
#***********************************Attribute employment***********************************************
#affiche la structure de 'employment'
str(bd$employment)
#recoder la variable 'employment' en fonction des conditions ci-dessous 
bd$employment <- ifelse(bd$employment == "unemployed", "A71",
                        ifelse(bd$employment == "<1", "A72",
                               ifelse(bd$employment == "1<=X<4", "A73",
                                      ifelse(bd$employment == "4<=X<7", "A74",
                                             ifelse(bd$employment == ">=7", "A75", bd$employment)))))
#afficher la nouvelle version de bd
View(bd)
#***********************************Attribute personal_status***********************************************
#affiche la structure de 'personal_status'
str(bd$personal_status)
#recoder la variable 'personal_status' en fonction des conditions ci-dessous 
bd$personal_status <- ifelse(bd$personal_status == "male div/sep", "A91",
                             ifelse(bd$personal_status == "female div/dep/mar", "A92",
                                    ifelse(bd$personal_status == "male single", "A93",
                                           ifelse(bd$personal_status == "male mar/wid", "A94", 
                                                  ifelse(bd$personal_status == "female single", "A95", bd$personal_status)))))
#afficher la nouvelle version de bd
View(bd)
#***********************************Attribute other_parties***********************************************
#affiche la structure de 'other_parties'
str(bd$other_parties)
#recoder la variable 'other_parties' en fonction des conditions ci-dessous 
bd$other_parties <- ifelse(bd$other_parties == "none", "A101",
                           ifelse(bd$other_parties == "co applicant", "A102",
                                  ifelse(bd$other_parties == "guarantor", "A103", bd$other_parties)))
#afficher la nouvelle version de bd
View(bd)
#***********************************Attribute property_magnitude***********************************************
#affiche la structure de 'property_magnitude'
str(bd$property_magnitude)
#recoder la variable 'property_magnitude' en fonction des conditions ci-dessous 
bd$property_magnitude <- ifelse(bd$property_magnitude == "real estate", "A121",
                                ifelse(bd$property_magnitude == "life insurance", "A122",
                                       ifelse(bd$property_magnitude == "car", "A123",
                                              ifelse(bd$property_magnitude == "no known property", "A124", bd$property_magnitude))))
#afficher la nouvelle version de bd
View(bd)
#***********************************Attribute age***********************************************
#affiche la structure de 'age'
str(bd$age)
#crée un vecteur 'age_mapping' pour associer des catégories spécifiques à des valeurs numérique(25,40,60)
age_mapping <- c(">=55" = 60,"<30" = 25,"30<=X<55" = 40)
#recode la variable 'age' (mise a jour de 'age')
bd$age <- age_mapping[bd$age]
#afficher la nouvelle version de bd
View(bd)
#***********************************Attribute other_payment_plans***********************************************
#affiche la structure de 'other_payment_plans'
str(bd$other_payment_plans)                          
#recoder la variable 'other_payment_plans' en fonction des conditions ci-dessous 
bd$other_payment_plans <- ifelse(bd$other_payment_plans == "bank", "A141",
                                 ifelse(bd$other_payment_plans == "stores", "A142",
                                        ifelse(bd$other_payment_plans == "none", "A143", bd$other_payment_plans)))
#afficher la nouvelle version de bd
View(bd)
#***********************************Attribute housing***********************************************
#affiche la structure de 'housing'
str(bd$housing)                          
#recoder la variable 'housing' en fonction des conditions ci-dessous 
bd$housing <- ifelse(bd$housing == "rent", "A151",
                     ifelse(bd$housing == "own", "A152",
                            ifelse(bd$housing == "for free", "A153", bd$housing)))
#afficher la nouvelle version de bd
View(bd) 
#***********************************Attribute existing_credits***********************************************
#affiche la structure de 'existing_credits'
str(bd$existing_credits)
#recoder la variable 'existing_credits' en fonction des conditions ci-dessous 
bd$existing_credits <- ifelse(bd$existing_credits == "one", "1",
                              ifelse(bd$existing_credits == "two", "2",
                                     ifelse(bd$existing_credits == "three", "3",
                                            ifelse(bd$existing_credits == "four", "4", bd$existing_credits))))
#afficher la nouvelle version de bd
View(bd)    
#***********************************Attribute job***********************************************
#affiche la structure de 'job'
str(bd$job)                          
#recoder la variable 'job' en fonction des conditions ci-dessous 
bd$job <- ifelse(bd$job == "unemp/unskilled non res", "A171",
                 ifelse(bd$job == "unskilled resident", "A172",
                        ifelse(bd$job == "skilled", "A173",
                               ifelse(bd$job == "high qualif/self emp/mgm", "A174", bd$job))))
#afficher la nouvelle version de bd
View(bd)  
#***********************************Attribute num_dependents***********************************************
#affiche la structure de 'num_dependents'
str(bd$num_dependents)                          
#recoder la variable 'num_dependents' en fonction des conditions ci-dessous 
bd$num_dependents <- ifelse(bd$num_dependents == "one", "1",
                            ifelse(bd$num_dependents == "two", "2",
                                   ifelse(bd$num_dependents == "three", "3",
                                          ifelse(bd$num_dependents == "four", "4", bd$num_dependents))))
#afficher la nouvelle version de bd
View(bd)  
#***********************************Attribute own_telephone***********************************************
#affiche la structure de 'own_telephone'
str(bd$own_telephone)                          
#recoder la variable 'own_telephone' en fonction des conditions ci-dessous 
bd$own_telephone <- ifelse(bd$own_telephone == "none", "A191",
                           ifelse(bd$own_telephone == "yes", "A192", bd$own_telephone))
#afficher la nouvelle version de bd
View(bd)                         
#***********************************Attribute foreign_worker***********************************************
#affiche la structure de 'foreign_worker'
str(bd$foreign_worker)                          
#recoder la variable 'foreign_worker' en fonction des conditions ci-dessous 
bd$foreign_worker <- ifelse(bd$foreign_worker == "no", "A201",
                            ifelse(bd$foreign_worker == "yes", "A202", bd$foreign_worker))
#afficher la nouvelle version de bd
View(bd)  
#***********************************Attribute class***********************************************
#affiche la structure de 'class'
str(bd$class)
install.packages("caret")
#afficher la bd
View(bd)
#générer un tableau .csv
write.table(bd,"German_Credit_data.csv", sep = ",")
# Obtenir le répertoire de travail actuel afin de changer le dossier sur le dossier de cours (DATA MINING)
getwd()
