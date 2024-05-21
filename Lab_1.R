# R INSTALLATION

# Встановлення бібліотек
install.packages(c(
  "dplyr", "ggplot2", "psych", "caTools",  # Підготовка даних
  "rpart", "randomForest",                 # Регресія
  "ROCR", "ElemStatLearn", "e1071", "class",  # Класифікація
  "cluster",                               # Кластеризація
  "arules", "arulesViz",                   # Асоціативні правила
  "tm", "SnowballC",                       # Обробка природної мови
  "nnet", "neuralnet", "kohonen", "forecast", # Штучні нейронні мережі
  "keras", "tensorflow"                    # Глибоке навчання
))

## Підключення бібліотек за замовчуванням
library(base)
library(datasets)
library(graphics)
library(grDevices)
library(methods)
library(stats)
library(utils)

## Підключення бібліотек, що потребують завантаження
library(dplyr)
library(ggplot2)
library(psych)
library(caTools)

library(rpart)
library(randomForest)

library(ROCR)
library(ElemStatLearn) # !!!!!
library(e1071)
library(class)

library(cluster)

library(arules)
library(arulesViz)

library(tm)
library(SnowballC)

library(nnet)
library(neuralnet)
library(kohonen)
library(forecast)

library(keras)
library(tensorflow)
