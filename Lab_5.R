# LOGISTIC REGRESSION

# Download the data

set.seed(123)
f <- read.csv('Data/bank.csv', header = TRUE, encoding = 'UNICOD')
head (f)


# Statistics

## Descriptive statistics

library (psych)
describe(f)


## Factors as numeric

f <- f[,-1]
f$sex <- as.numeric(as.factor(f$sex))-1
f$married <- as.numeric(as.factor(f$married))-1
f$car <- as.numeric(as.factor(f$car))-1
f$mortgage <- as.numeric(as.factor(f$mortgage))-1
f$delays <- as.numeric(as.factor(f$delays))-1
head (f)


# Splitting the scaled dataset into the TRAIN set and TEST set

set.seed(123)
library(caTools)
split = sample.split(f$delays, SplitRatio = 2/3)
f_train = subset(f, split == TRUE)
f_test = subset(f, split == FALSE)


# Features Scaling

mage <- mean(f_train$age)
sage <- sd(f_train$age)
mincome <- mean(f_train$income)
sincome <- sd(f_train$income)
mchildren <- mean(f_train$children)
schildren <- sd(f_train$children)

f_train$age <- (f_train$age-mage)/sage
f_test$age <- (f_test$age-mage)/sage

f_train$income <- (f_train$income-mincome)/sincome
f_test$income <- (f_test$income-mincome)/sincome

f_train$children <- (f_train$children-mchildren)/schildren
f_test$children <- (f_test$children-mchildren)/schildren

head (f_train)
head(f_test)

# Fitting (Benchmark model)

class_lr <- glm(delays ~ ., f_train, family = binomial)
summary(class_lr)


## Optimized model

class_opt <- glm(delays ~ age + income, f_train, family = binomial)
summary(class_opt)


# Predicting

p <- predict(class_opt, f_test[, c('age','income')], type = 'response')
y <- ifelse(p > 0.5, 1, 0)


## Confusion Matrix

cm = table(f_test[, 'delays'], y > 0.5)
print(cm)


## ROC

library(ROCR)
pref <- prediction(p, f_test$delays)
perf <- performance(pref, "tpr", "fpr")
plot(perf)


# Visualising the Test set results

library(ggplot2)
set = f_test[,c('age','income','delays')]
X1 = seq(min(set['age']) - 1, max(set['age']) + 1, by = 0.01)
X2 = seq(min(set['income']) - 1, max(set['income']) + 1, by = 0.01)
grid_set = expand.grid(X1, X2)
colnames(grid_set) = c('age', 'income')
prob_set = predict(class_opt, grid_set, type = 'response')
y_grid = ifelse(prob_set > 0.7, 1, 0)
plot(set[, -3],
     main = 'Logistic Regression',
     xlab = 'Age', ylab = 'Income',
     xlim = range(X1), ylim = range(X2))
contour(X1, X2, matrix(as.numeric(y_grid), length(X1), length(X2)), add = TRUE)
points(grid_set, pch = '.', col = ifelse(y_grid == 1, 'tomato', 'springgreen3'))
points(set, pch = 21, bg = ifelse(set[, 3] == 1, 'red3', 'green4'))


# Write prepared data to the file

write.csv2(f_train, file = "Data/bank_train.csv")
write.csv2(f_test, file = "Data/bank_test.csv")
