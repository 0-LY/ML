# K-Nearest Neighbors (K-NN)

# Download the data

set.seed(123)
f_train <- read.csv2('Data/bank_train.csv', header = TRUE, encoding = 'UNICOD')
f_test <- read.csv2('Data/bank_test.csv', header = TRUE, encoding = 'UNICOD')
f_train <- f_train[-1]
f_test <- f_test[-1]


# Fitting & predicting

library(class)
y = knn(train = f_train[,c('age','income')],
        test = f_test[,c('age','income')],
        cl = f_train[, 'delays'],
        k = 20,
        prob = TRUE)


## Confusion Matrix

cm = table(f_test[, 'delays'], y == '1')
print(cm)


## Visualising the Test set results

library(ggplot2)
set = f_test[,c('age','income','delays')]
X1 = seq(min(set['age']) - 1, max(set['age']) + 1, by = 0.01)
X2 = seq(min(set['income']) - 1, max(set['income']) + 1, by = 0.01)
grid_set = expand.grid(X1, X2)
colnames(grid_set) = c('age', 'income')
y_grid = knn(train = f_train[,c('age','income')], test = grid_set, cl = f_train[, 'delays'], k = 5)
plot(set[, -3],
     main = 'KNN',
     xlab = 'Age', ylab = 'Income',
     xlim = range(X1), ylim = range(X2))
contour(X1, X2, matrix(as.numeric(y_grid), length(X1), length(X2)), add = TRUE)
points(grid_set, pch = '.', col = ifelse(y_grid == 1, 'tomato', 'springgreen3'))
points(set, pch = 21, bg = ifelse(set[, 3] == 1, 'red3', 'green4'))

