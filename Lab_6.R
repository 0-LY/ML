# Support Vector Machine (SVM)

# Download the data

set.seed(123)
f_train <- read.csv2('Data/bank_train.csv', header = TRUE, encoding = 'UNICOD')
f_test <- read.csv2('Data/bank_test.csv', header = TRUE, encoding = 'UNICOD')
f_train <- f_train[-1]
f_test <- f_test[-1]


# Fitting SVM model

library(e1071)
class_svm_l = svm(delays ~ age + income, data = f_train, kernel = 'linear')
summary(class_svm_l)


# Predicting

p <- predict(class_svm_l, f_test[, c('age','income')])
y <- ifelse(p > 0.5, 1, 0)


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
p_grid = predict(class_svm_l, grid_set)
y_grid <- ifelse(p_grid > 0.5, 1, 0)
plot(set[, -3],
     main = 'SVM',
     xlab = 'Age', ylab = 'Income',
     xlim = range(X1), ylim = range(X2))
contour(X1, X2, matrix(as.numeric(y_grid), length(X1), length(X2)), add = TRUE)
points(grid_set, pch = '.', col = ifelse(y_grid == 1, 'tomato', 'springgreen3'))
points(set, pch = 21, bg = ifelse(set[, 3] == 1, 'red3', 'green4'))


# Fitting RBF-kernel model

library(e1071)
class_svm_r = svm(delays ~ age + income, data = f_train, kernel = 'radial')
summary(class_svm_r)


# Predicting

p <- predict(class_svm_r, f_test[, c('age','income')])
y <- ifelse(p > 0.5, 1, 0)


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
p_grid = predict(class_svm_r, grid_set)
y_grid <- ifelse(p_grid > 0.5, 1, 0)
plot(set[, -3],
     main = 'SVM',
     xlab = 'Age', ylab = 'Income',
     xlim = range(X1), ylim = range(X2))
contour(X1, X2, matrix(as.numeric(y_grid), length(X1), length(X2)), add = TRUE)
points(grid_set, pch = '.', col = ifelse(y_grid == 1, 'tomato', 'springgreen3'))
points(set, pch = 21, bg = ifelse(set[, 3] == 1, 'red3', 'green4'))

