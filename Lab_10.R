# Hierarchical clustering

# Download the data

set.seed(123)
f <- read.csv('Data/bank.csv', header = TRUE, encoding = 'UNICOD')
head(f)


## Factors as numeric

f <- f[,-1] #exclude ID column
f$sex <- as.numeric(as.factor(f$sex))-1
f$married <- as.numeric(as.factor(f$married))-1
f$car <- as.numeric(as.factor(f$car))-1
f$mortgage <- as.numeric(as.factor(f$mortgage))-1
f$delays <- as.numeric(as.factor(f$delays))-1
head (f)


# Hierarchical clustering

model_hc <- hclust(dist(f), method = "ward.D" )
plot(model_hc, main = paste('Dendrogram'))


## Fitting HC to the dataset

y_hc <- cutree(model_hc, k = 3)
#cluster cores
aggregate(f,by=list(y_hc),FUN=mean)
#Cluster stat
f$hc <- y_hc
table(f$hc)


## Plotting the dendrogram

plot(model_hc, cex = 0.7, labels = FALSE)
rect.hclust(model_hc, k = 3, border = 2:5)


## Visualising the clusters

library(cluster)
clusplot(f[,c('age','income')],
         y_hc,
         lines = 0,
         shade = TRUE,
         color = TRUE,
         labels= 0,
         plotchar = FALSE,
         span = TRUE,
         main = paste('Clusters of customers'),
         xlab = 'Age',
         ylab = 'Income')
