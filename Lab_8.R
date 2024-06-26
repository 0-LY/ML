# Naive Bayes

# Download the data

set.seed(123)
f_train <- read.csv2('Data/bank_train.csv', header = TRUE, encoding = 'UNICOD')
f_test <- read.csv2('Data/bank_test.csv', header = TRUE, encoding = 'UNICOD')
f_train <- f_train[-1]
f_test <- f_test[-1]


# Fitting 

# install.packages('e1071')
library(e1071)
f_train$delays <- as.factor(f_train$delays)
f_test$delays <- as.factor(f_test$delays)
class_nb = naiveBayes(delays ~ age + income, data = f_train)


# Predicting

y <- predict(class_nb, f_test[, c('age','income')])


## Confusion Matrix

cm = table(f_test[, 'delays'], y)
print(cm)


# Visualising the Test set results

library(ggplot2)
set = f_test[,c('age','income','delays')]
X1 = seq(min(set['age']) - 1, max(set['age']) + 1, by = 0.01)
X2 = seq(min(set['income']) - 1, max(set['income']) + 1, by = 0.01)
grid_set = expand.grid(X1, X2)
colnames(grid_set) = c('age', 'income')
y_grid = predict(class_nb, grid_set)
plot(set[, -3],
     main = 'Naive Bayes',
     xlab = 'Age', ylab = 'Income',
     xlim = range(X1), ylim = range(X2))
contour(X1, X2, matrix(as.numeric(y_grid), length(X1), length(X2)), add = TRUE)
points(grid_set, pch = '.', col = ifelse(y_grid == 1, 'tomato', 'springgreen3'))
points(set, pch = 21, bg = ifelse(set[, 3] == 1, 'red3', 'green4'))

