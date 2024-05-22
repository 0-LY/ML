# DATA PREPARATION

# Download data
f <- read.csv2('Data/flats.csv', header = TRUE, encoding = 'UNICOD')
library (psych)
describe(f)

## Remove mistakes

f <- f[f$price < 300000, ]
f <- f[f$price > 10000, ]
describe(f[,c('rooms','m2','price')])

# Visualising

## Histogram

library(ggplot2)
par(mfrow = c(1, 3))
hist(f$rooms, col = 'dark blue', main = 'rooms', xlab = 'Value')
hist(f$m2, col = 'dark blue', main = 'm2', xlab = 'Value')
hist(f$price, col = 'dark blue', main = 'price', xlab = 'Value')


## Box-plot

par(mfrow = c(1, 3))
boxplot(f$rooms)
boxplot(f$m2)
boxplot(f$price)


## Box-plot

qplot(data = f, 
      x = condition, 
      y = price, 
      geom = "boxplot")
qplot(data = f, 
      x = location, 
      y = price, 
      geom = "violin")


# Preprocessing

## Factors as numeric

f$location <- as.numeric(as.factor(f$location))-1
f$condition <- as.numeric(as.factor(f$condition))-1
f$type <- as.numeric(as.factor(f$type))-1


## Missing data

f$rooms <- ifelse(is.na(f$rooms),round(mean(f$rooms,na.rm = TRUE)),f$rooms)
f$type <- ifelse(is.na(f$type),round(mean(f$type,na.rm = TRUE)),f$type)


# Visualising

library(ggplot2)
par(mfrow = c(2, 3))
hist(f$rooms, col = 'dark blue', main = 'rooms', xlab = 'Value')
hist(f$m2, col = 'dark blue', main = 'm2', xlab = 'Value')
hist(f$price, col = 'dark blue', main = 'price', xlab = 'Value')
hist(log(f$rooms), col = 'dark blue', main = 'rooms', xlab = 'Value')
hist(log(f$m2), col = 'dark blue', main = 'm2', xlab = 'Value')
hist(log(f$price), col = 'dark blue', main = 'price', xlab = 'Value')


## Log

f$rooms <- log(f$rooms)
f$m2 <- log(f$m2)
f$price <- log(f$price)
describe(f[,c('rooms','m2','price')])


## Replace ejections with max (no need)

f$rooms <- ifelse(f$rooms < mean(f$rooms)+sd(f$rooms)*3,f$rooms,mean(f$rooms)+sd(f$rooms)*3)
f$rooms <- ifelse(f$rooms > mean(f$rooms)-sd(f$rooms)*3,f$rooms,mean(f$rooms)-sd(f$rooms)*3)

f$price <- ifelse(f$price < mean(f$price)+sd(f$price)*3,f$price,mean(f$price)+sd(f$price)*3)
f$price <- ifelse(f$price > mean(f$price)-sd(f$price)*3,f$price,mean(f$price)-sd(f$price)*3)

f$m2 <- ifelse(f$m2 < mean(f$m2)+sd(f$m2)*3,f$m2,mean(f$m2)+sd(f$m2)*3)
f$m2 <- ifelse(f$m2 > mean(f$m2)-sd(f$m2)*3,f$m2,mean(f$m2)-sd(f$m2)*3)

describe(f[,c('rooms','m2','price')])


# Splitting the dataset into the TRAIN set and TEST set

set.seed(123)
library(caTools)
split = sample.split(f$price, SplitRatio = 0.8)
f_train = subset(f, split == TRUE)
f_test = subset(f, split == FALSE)
#Write prepared data to the file
write.csv2(f_train, file = "Data/flats_train.csv")
write.csv2(f_test, file = "Data/flats_test.csv")
