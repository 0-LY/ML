# Download data
f <- read.csv("Data/ITC_NSE_24_Year_Stock_Data.csv", header = TRUE, sep = ",", encoding = "UTF-8")
library(psych) 
describe(f)


## Visualising
# Histogram
library(ggplot2)
par(mfrow = c(1, 2))
hist(f$high, col = 'dark blue', main = 'high' , xlab = 'Value')
hist(f$low, col = 'dark blue', main = 'low', xlab = 'Value')

# Box-plot
par(mfrow = c(1, 2))
boxplot(f$high)
boxplot(f$low)

# Box-plot
qplot(data = f, x = high, y = open, geom = "boxplot")
qplot(data = f, x = low, y = open, geom = "violin")

## Preprocessing
# Factors as numeric
f$open <- as.numeric(as.factor(f$open))-1
f$high <- as.numeric(as.factor(f$high))-1
f$low <- as.numeric(as.factor(f$low))-1
f$close <- as.numeric(as.factor(f$close))-1

## Visualising
library(ggplot2)
par(mfrow = c(2, 4))
hist(f$open, col = 'dark blue', main = 'open' , xlab = 'Value')
hist(f$high, col = 'dark blue', main = 'high', xlab = 'Value')
hist(f$low, col = 'dark blue', main = 'low', xlab = 'Value')
hist(f$close, col = 'dark blue', main = 'close', xlab = 'Value')
hist(log(f$open), col = 'dark blue', main = 'open', xlab = 'Value')
hist(log(f$high), col = 'dark blue', main = 'high', xlab = 'Value')
hist(log(f$low), col = 'dark blue', main = 'low', xlab = 'Value')
hist(log(f$close), col = 'dark blue', main = 'close', xlab = 'Value')

# Log
f$open <- log(f$open)
f$high <- log(f$high)
f$low <- log(f$low)
f$close <- log(f$close)
describe(f[, c('open', 'high', 'low', 'close')])

# Splitting the dataset into the TRAIN set and TEST set
set.seed(123)
library(caTools)

split = sample.split(f$high, SplitRatio = 0.8)
f_train = subset(f, split == TRUE)
f_test = subset(f, split == FALSE)
write.csv2(f_train, file = "flats_train.csv")
write.csv2(f_test, file = "flats_test.csv")
