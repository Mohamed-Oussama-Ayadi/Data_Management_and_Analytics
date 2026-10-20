install.packages('arules')
library(arules)
data(Groceries)
transaction <- Groceries
class(transaction)
?inspect
inspect(head(transaction))
summary(transaction)
nrow(transaction)
?itemFrequencyPlot
itemFrequencyPlot(transaction,support=0.1,cex.names=0.8)
?eclat
freq.items <- eclat(transaction,parameter=list(supp=0.075))
inspect(freq.items)
x<-apriori(transaction)
summary(x)
  
rules <- apriori(Groceries, parameter = list(support = 0.009 , confidence = 0.25 , minlen=2))
summary(rules)
inspect(rules)
inspect(head(sort(rules, by= "lift"),5))
inspect(sort(sort(rules, by="support") , by ="confidence")[1:5])
?subset
milk.rules <- sort (
  subset(rules, 
         subset = rhs %in% "whole milk"), by = "confidence")
inspect(milk.rules)
which(Groceries@itemInfo$labels == 'yogurt')
which(Groceries@itemInfo$labels == 'rice')
rules<-apriori(Groceries,parameter = NULL, appearance = NULL , control = NULL)
rules<-apriori(Groceries,parameter = list(supp = 0.5, conf = 0.9, target = "rules"))
inspect(head(sort(rules,by="lift"),10))
rules <-apriori(Groceries, control = NULL,
                 parameter = list(minlen=2, supp=0.005, conf=0.8))
quality(rules) <- round(quality(rules), digits=3)
rules.sorted <- sort(rules, by="lift")
inspect(rules.sorted)
