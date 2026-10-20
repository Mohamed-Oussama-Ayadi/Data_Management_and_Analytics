install.packages('arules')
library(arules)
data(Groceries)
transaction<-Groceries
?inspect
inspect(transaction)
summary(transaction)
nrow(transaction)
?itemFrequencyPlot
itemFrequencyPlot(transaction,support=0.1,cex.names=0.8)
?eclat
freq.items<-eclat(transaction,parameter = list(supp=0.075))
inspect(freq.items)
x<-apriori(transaction)
summary(x)
rules<-apriori(Groceries,parameter = list(support=0.009,confidence=0.25,minlen=2))
inspect(rules)
inspect(head(sort(rules,by="lift"),10))
inspect(sort(sort(rules,by="support"),by="confidence")[1:5])
milk.rules<-sort(subset(rules,subset=rhs%in%"whole milk"),by="confidence")
?subset
inspect(milk.rules)
