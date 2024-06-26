# NONLINEAR REGRESSION 
# Download the data

f_train <- read.csv2('Data/flats_train.csv', header = TRUE, encoding = 'UNICOD')
f_test <- read.csv2('Data/flats_test.csv', header = TRUE, encoding = 'UNICOD')


# Decision Tree Regression

## Fitting simple tree

library(rpart)
dt <- rpart(price ~ m2, f_train, control = rpart.control(minsplit = 50))
plot(dt)
text(dt, pos = 1, cex = .75, col = 1, font = 1)


## Predicting

p_dt <- predict(dt, f_test)

train_mse_dt <- sum((f_train$price-predict(dt, f_train))^2) /length(f_train$price)
test_mse_dt <- sum((f_test$price-p_dt)^2)/length(p_dt)

train_mse_dt
test_mse_dt


## Visualising

library(ggplot2)
x_grid <- seq(min(f_train$m2), max(f_train$m2), 0.01)
ggplot() +
  geom_point(aes(f_train$m2, f_train$price),colour = 'red') +
  geom_point(aes(f_test$m2, f_test$price),colour = 'dark green') +
  geom_line(aes(x_grid, predict(dt, data.frame(m2 = x_grid))),colour = 'blue') +
  ggtitle('Price vs m2') +
  xlab('m2') +
  ylab('price')


## Fitting full tree

library(rpart)
dt <- rpart(price ~ rooms + location + condition + m2, f_train, control = rpart.control(minsplit = 2))
plot(dt)
text(dt, pos = 1, cex = .75, col = 1, font = 1)


## Predicting

p_dt <- predict(dt, f_test)

train_mse_dt <- sum((f_train$price-predict(dt, f_train))^2)/length(f_train$price)
test_mse_dt <- sum((f_test$price-p_dt)^2)/length(p_dt)

train_mse_dt
test_mse_dt


# Random forest

## Fitting

library(randomForest)
set.seed(1234)
rf = randomForest(x = f_train['m2'],
                         y = f_train$price,
                         ntree = 5)


## Predicting

p_rf <- predict(rf, f_test)

train_mse_rf <- sum((f_train$price-predict(rf, f_train))^2)/length(f_train$price)
test_mse_rf <- sum((f_test$price-p_rf)^2)/length(p_rf)

train_mse_rf
test_mse_rf


## Visualising

ggplot() +
  geom_point(aes(f_train$m2, f_train$price),colour = 'red') +
  geom_point(aes(f_test$m2, f_test$price),colour = 'dark green') +
  geom_line(aes(x_grid, predict(rf, data.frame(m2 = x_grid))),colour = 'blue') +
  ggtitle('Price vs m2') +
  xlab('m2') +
  ylab('price')


# Saving results

fit <- read.csv2('flats_fit.csv', header = TRUE, encoding = 'UNICOD')
fit$p_dt <- p_dt
fit$p_rf <- p_rf
head(fit)
write.csv2(fit[-1], file = "flats_fit.csv")


# Compare models

g_sr <- ggplot(fit, aes(x=f_test.price, y=p_sr)) + 
  geom_abline(intercept=0, slope=1) +
  geom_point(alpha=0.5) + labs(title="Linear Regression", x="Real Price", y="Predicted Price") + 
  theme(plot.title=element_text(size=10), axis.title.x=element_text(size=7), axis.title.y=element_text(size=7), axis.text.x=element_text(size=5), axis.text.y=element_text(size=5)) + theme(legend.position="none")

g_mr <- ggplot(fit, aes(x=f_test.price, y=p_mr)) + 
  geom_abline(intercept=0, slope=1) +
  geom_point(alpha=0.5) + labs(title="Multiple Regression", x="Real Price", y="Predicted Price") + 
  theme(plot.title=element_text(size=10), axis.title.x=element_text(size=7), axis.title.y=element_text(size=7), axis.text.x=element_text(size=5), axis.text.y=element_text(size=5)) + theme(legend.position="none")

g_pr <- ggplot(fit, aes(x=f_test.price, y=p_pr)) + 
  geom_abline(intercept=0, slope=1) +
  geom_point(alpha=0.5) + labs(title="Polynomial Regression", x="Real Price", y="Predicted Price") + 
  theme(plot.title=element_text(size=10), axis.title.x=element_text(size=7), axis.title.y=element_text(size=7), axis.text.x=element_text(size=5), axis.text.y=element_text(size=5)) + theme(legend.position="none") 

g_dt <- ggplot(fit, aes(x=f_test.price, y=p_dt)) + 
  geom_abline(intercept=0, slope=1) +
  geom_point(alpha=0.5) + labs(title="Regression Tree", x="Real Price", y="Predicted Price") + 
  theme(plot.title=element_text(size=10), axis.title.x=element_text(size=7), axis.title.y=element_text(size=7), axis.text.x=element_text(size=5), axis.text.y=element_text(size=5)) + theme(legend.position="none")

g_rf <- ggplot(fit, aes(x=f_test.price, y=p_rf)) + 
  geom_abline(intercept=0, slope=1) +
  geom_point(alpha=0.5) + labs(title="Random Forest", x="Real Price", y="Predicted Price") + 
  theme(plot.title=element_text(size=10), axis.title.x=element_text(size=7), axis.title.y=element_text(size=7), axis.text.x=element_text(size=5), axis.text.y=element_text(size=5)) + theme(legend.position="none")

gridExtra::grid.arrange(g_sr,g_mr,g_pr,g_dt,g_rf,ncol=2)


# Calc prediction error and visualize it

sr <- mean ((fit$f_test.price - fit$p_sr) ^ 2)
mr <- mean ((fit$f_test.price - fit$p_mr) ^ 2)
pr <- mean ((fit$f_test.price - fit$p_pr) ^ 2)
dt <- mean ((fit$f_test.price - fit$p_dt) ^ 2)
rf <- mean ((fit$f_test.price - fit$p_rf) ^ 2)
mse <- data.frame(sr,mr,pr,dt,rf)
head(mse)

install.packages("reshape") # !!!!!

mse1 <- reshape::melt.data.frame(mse)
head(mse1)

b1 <- ggplot(mse1, aes(x=variable, y=value)) +
  geom_bar(stat="summary", fun.y="mean", fill = 'royalblue')
b1
