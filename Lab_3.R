# LINEAR REGRESSION 

# Download the data

f_train <- read.csv2('Data/flats_train.csv', header = TRUE, encoding = 'UNICOD')
f_train <- f_train[,-1]
f_test <- read.csv2('Data/flats_test.csv', header = TRUE, encoding = 'UNICOD')
f_test <- f_test[,-1]


# Correlations

library (psych)
pairs.panels(f_train, lm=TRUE, 
             method = "pearson", 
             hist.col = "#00AFBB"
             )


# Simple Linear Regression (one factor - m2)

## Fitting Simple Linear Regression to the Training set

sr <- lm(price ~ m2, f_train)
summary(sr)


## Predicting

p_sr <- predict(sr, f_test)
train_mse_sr <- sum((f_train$price-predict(sr, f_train))^2)/length(f_train$price)
test_mse_sr <- sum((f_test$price-p_sr)^2)/length(p_sr)

train_mse_sr
test_mse_sr


## Visualising

library(ggplot2)
ggplot() +
  geom_point(aes(f_train$m2, f_train$price),colour = 'red') +
  geom_point(aes(f_test$m2, f_test$price),colour = 'dark green') +
  geom_line(aes(f_test$m2, p_sr),colour = 'blue') +
  ggtitle('Price vs m2') +
  xlab('m2') +
  ylab('price')


# Multiple Linear Regression (many factors)

## All factors

mr <- lm(price ~ ., f_train) 
summary(mr)  


## Optimized model

mr_opt <- lm(price ~ rooms + location + condition + m2, f_train) 
summary(mr_opt)  


## Prediction

p_mr <- predict(mr_opt, f_test)

train_mse_opt <- sum((f_train$price-predict(mr_opt, f_train))^2)/length(f_train$price)
test_mse_opt <- sum((f_test$price-p_mr)^2)/length(p_mr)

train_mse_opt
test_mse_opt


## Visualising

ggplot() +
  geom_point(aes(f_train$m2, f_train$price),colour = 'red') +
  geom_point(aes(f_test$m2, f_test$price),colour = 'dark green') +
  geom_line(aes(f_test$m2, p_mr),colour = 'blue') +
  ggtitle('Price vs m2') +
  xlab('m2') +
  ylab('price')


# Polynomial Linear Regression (one factor - m2)

## Features extending 

f_train_poly <- f_train[,c('price', 'm2')]
f_test_poly <- f_test[,c('price', 'm2')]
f_train_poly$m22 <- f_train_poly$m2^2
f_train_poly$m23 <- f_train_poly$m2^3
f_test_poly$m22 <- f_test_poly$m2^2
f_test_poly$m23 <- f_test_poly$m2^3


## 3 powers

pr <- lm(price ~ m22 + m23, f_train_poly) 
summary(pr)  


## Predicting

p_pr <- predict(pr, f_test_poly)

train_mse_poly <- sum((f_train_poly$price-predict(pr, f_train_poly))^2)/length(f_train_poly$price)
test_mse_poly <- sum((f_test_poly$price-p_pr)^2)/length(p_pr)

train_mse_poly
test_mse_poly


## Visualising

ggplot() +
  geom_point(aes(f_train_poly$m2, f_train_poly$price),colour = 'red') +
  geom_point(aes(f_test_poly$m2, f_test_poly$price),colour = 'dark green') +
  geom_line(aes(f_test_poly$m2, p_pr),colour = 'blue') +
  ggtitle('Price vs m2') +
  xlab('m2') +
  ylab('price')


# Saving results

fit <- data.frame(f_test$price, p_sr, p_mr, p_pr)
write.csv2(fit, file = "Data/flats_fit.csv")

