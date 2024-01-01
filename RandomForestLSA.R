#libraries
library(tidyverse)
library(ranger)
library(MASS)
library(pROC)

#read in data
path <- '/Users/adarekar/Documents/College/Senior/ST 495/Project/'
data <- read_csv(paste(path, 'cleaned-maude-2016-2019.csv', sep = ""))

#preprocessing
data <- as.data.frame(data)
data <- na.omit(data)
data <- subset(data, select <- -c(...1, PATIENT_PROBLEM_DESCRIPTION, DEVICE_PROBLEM_DESCRIPTION, MDR_REPORT_KEY, DEVICE_PROBLEM_CODE, PATIENT_PROBLEM_CODE, REPORTER_OCCUPATION_CODE, DEVICE_REPORT_PRODUCT_CODE, REPORTER_COUNTRY_CODE))
data$EVENT_TYPE <- as.factor(data$EVENT_TYPE)


#cross validation 70%/30% split
K<-5
n<-nrow(data)
train.prop <-0.7
train.size <-ceiling(n*train.prop) #integer above number 


rf1.err.cv <-rep(NA, K)
rf2.err.cv <-rep(NA, K)
rf3.err.cv <-rep(NA, K)



for (i in 1:K) {
  set.seed(234)
  indices <- sample(n, train.size)
  train.data <- data[indices,]
  test.data <- data[-indices,]
  

  
  tree1 <- ranger(EVENT_TYPE~., data = train.data, mtry = 3, num.trees = 50, importance = "impurity")
  tree2 <- ranger(EVENT_TYPE~., data = train.data, mtry = 3, num.trees = 100, importance = "impurity")
  tree3 <- ranger(EVENT_TYPE~., data = train.data, mtry = 3, num.trees = 200, importance = "impurity")
  
  pred.tree1 <- predict(tree1, data = subset(test.data, select = -c(EVENT_TYPE)))
  pred.tree2 <- predict(tree2, data = subset(test.data, select = -c(EVENT_TYPE)))
  pred.tree3 <- predict(tree3, data = subset(test.data, select = -c(EVENT_TYPE)))
  
  rf1.err.cv[i] <- sum(pred.tree1$predictions != test.data$EVENT_TYPE)/nrow(test.data)
  rf2.err.cv[i] <- sum(pred.tree2$predictions != test.data$EVENT_TYPE)/nrow(test.data)
  rf3.err.cv[i] <- sum(pred.tree3$predictions != test.data$EVENT_TYPE)/nrow(test.data)
  
}

mean(rf1.err.cv)
mean(rf2.err.cv)
mean(rf3.err.cv)


#go with tree 3 (mtry = 3, num.trees = 200) with 70%/30% split
set.seed(234)
train <- sample(n, ceiling(0.7*n))
train_data <- data[train,]
test <- data[-train,]


#training and evaluating tree
tree <- ranger(EVENT_TYPE~., data = train_data, mtry = 3, num.trees = 200, importance = "impurity")
pred.tree <- predict(tree, data = subset(test, select = -c(EVENT_TYPE)))
table(test$EVENT_TYPE, pred.tree$predictions)
sum(pred.tree$predictions != test$EVENT_TYPE)/nrow(test)


#roc curve 
roc_score<-multiclass.roc(pred.tree$predictions, as.numeric(test$EVENT_TYPE))


plot.roc(roc_score$rocs[[1]], col = 'green', 
         print.auc=T,
         legacy.axes = T)
plot.roc(roc_score$rocs[[2]],
         add=T, col = 'red',
         print.auc = T,
         legacy.axes = T,
         print.auc.adj = c(0,3))
plot.roc(roc_score$rocs[[3]],add=T, col = 'blue',
         print.auc=T,
         legacy.axes = T,
         print.auc.adj = c(0,5))


legend('bottomright',
       legend = c('Death-Injury',
                  'Death-Malfunction',
                  'Injury-Malfunction'),
       col=c('green', 'red', 'blue'),lwd=2)


#distribution of response to show uneven distribution
table(data$EVENT_TYPE)



