# Hierarchical clustering

# Download the data

library(dplyr)
set.seed(123)

library(arules)
f <- read.transactions ('Data/mini-market.csv', sep = ',', rm.duplicates = TRUE)
summary(f)
itemFrequencyPlot(f, topN = 19)


# Eclat

model_eclat = eclat(data = f, parameter = list(support = 0.017, minlen = 2))
inspect(sort(model_eclat, by = 'support')[1:10])


# Apriori

model_ap = apriori(data = f, parameter = list(support = 0.01, confidence = 0.2))
inspect(sort(model_ap, by = 'lift')[1:10])


# Graph

library(arulesViz)
plot(model_ap, measure = c("support", "confidence"), shading = "lift")



plot(head(sort(model_ap, by = "support"), 30), method = "graph",
     control = list(nodeCol = rainbow(16), 
                    edgeCol = grey(.85), alpha = 1))

