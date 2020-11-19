
setwd("/Users/neerjasingh/Desktop")
ny <- read.csv("AB_NYC_2019.csv", header = T)

#Reading in test and train
train <- read.csv("train.csv", sep=",",header = TRUE)
test <- read.csv("test.csv", sep=",",header = TRUE)

data$isQ1 <- ifelse(data$price<70,1,0)
data$isQ2 <- ifelse(data$price<107&data$price>69,1,0)
data$isQ3 <- ifelse(data$price<176&data$price>106,1,0)
data$isQ4 <- ifelse(data$price>175,1,0)

table(data$isQ1, data$price)

nrows(data$price)

is.numeric(data$isQ1)

summary(ny$neighbourhood_group)

Bronx <- ny[ny$neighbourhood_group == "Bronx",]
median(Bronx$price) #65

Brooklyn <- ny[ny$neighbourhood_group == "Brooklyn",]
median(Brooklyn$price) #90

Manhattan <- ny[ny$neighbourhood_group == "Manhattan",]
median(Manhattan$price) #150

Queens <- ny[ny$neighbourhood_group == "Queens",]
median(Queens$price) #75

Staten <- ny[ny$neighbourhood_group == "Staten Island",]
median(Staten$price) #75

#Get rid of NAs
train$reviews_per_month[is.na(train$reviews_per_month)] <- 0
test$reviews_per_month[is.na(test$reviews_per_month)] <- 0

#Standardize/Factor Variables

train[["minimum_nights"]] = train[["minimum_nights"]]/sd(train[["minimum_nights"]])
train[["reviews_per_month"]] = train[["reviews_per_month"]]/sd(train[["reviews_per_month"]])
train[["number_of_reviews"]] = train[["number_of_reviews"]]/sd(train[["number_of_reviews"]])
train[["calculated_host_listings_count"]] = train[["calculated_host_listings_count"]]/sd(train[["calculated_host_listings_count"]])
train[["availability_365"]] = train[["availability_365"]]/sd(train[["availability_365"]])
train[["dist_from_timessquare"]] = train[["dist_from_timessquare"]]/sd(train[["dist_from_timessquare"]])

test[["minimum_nights"]] = test[["minimum_nights"]]/sd(test[["minimum_nights"]])
test[["reviews_per_month"]] = test[["reviews_per_month"]]/sd(test[["reviews_per_month"]])
test[["number_of_reviews"]] = test[["number_of_reviews"]]/sd(test[["number_of_reviews"]])
test[["calculated_host_listings_count"]] = test[["calculated_host_listings_count"]]/sd(test[["calculated_host_listings_count"]])
test[["availability_365"]] = test[["availability_365"]]/sd(test[["availability_365"]])
test[["dist_from_timessquare"]] = test[["dist_from_timessquare"]]/sd(test[["dist_from_timessquare"]])

train[["isQ1"]] = as.factor(train[["isQ1"]])
test[["isQ1"]] = as.factor(test[["isQ1"]])

train[["isQ4"]] = as.factor(train[["isQ4"]])
test[["isQ4"]] = as.factor(test[["isQ4"]])

######Trying SVM with 2 classes######

train_sub = cbind(train$neighbourhood_group, train$room_type, 
              train$reviews_per_month, train$number_of_reviews, 
              train$calculated_host_listings_count, train$availability_365,
              train$dist_from_timessquare)

test_sub = cbind(test$neighbourhood_group, test$room_type, 
             test$reviews_per_month, test$number_of_reviews, 
             test$calculated_host_listings_count, test$availability_365,
             test$dist_from_timessquare)

#SVM--------------------------------------------------------------------

#Q1---------------------------------------------------------------------

#linear-----------------------------------------------------------------
library(e1071)

res_Q1_lin = svm(train_sub, train$isQ1, kernel = "linear", probability = TRUE)
pred_Q1_lin = predict(res_Q1_lin, test_sub, probability = TRUE)

#predict vs. true
cbind(as.numeric(pred_Q1_lin) - 1, as.numeric(test$isQ1) - 1)

#error count
err_Q1_lin = sum(abs(as.numeric(pred_Q1_lin) - as.numeric(test$isQ1)))
err_Q1_lin #1849

#confusion matrix
table(pred_Q1_lin, test$isQ1)

#precision = tp/tp + fp
precision_Q1_lin <- 1199/(1199 + 485)
precision_Q1_lin #.712

#recall = tp/tp + tn
recall_Q1_lin <- 1199/(1199 + 1364)
recall_Q1_lin #.468

#F1 = 2*((precision*recall)/(precision + recall))
F1_Q1_lin <- 2*((precision_Q1_lin * recall_Q1_lin)/(precision_Q1_lin + recall_Q1_lin))
F1_Q1_lin #.565

#AUC
library(pROC)

score_Q1_lin = attr(pred_Q1_lin, "probabilities")
score_Q1_lin <- ifelse(pred_Q1_lin == "0", 1-score_Q1_lin, score_Q1_lin)

modelroc_Q1_lin =  roc(test$isQ1, score_Q1_lin)
plot_Q1_lin <- plot(modelroc_Q1_lin, print.auc=TRUE, auc.polygon=TRUE, grid=c(0.1, 0.2),
                    grid.col = c("green", "red"), max.auc.polygon=TRUE,
                    auc.polygon.col = "skyblue")

#AUC = .896

#polynomial------------------------------------------------------------

res_Q1_pol = svm(train_sub, as.factor(train$isQ1), kernel = "polynomial", probability = TRUE)
pred_Q1_pol = predict(res_Q1_pol, test_sub, probability = TRUE)

#predict vs. true
cbind(as.numeric(pred_Q1_pol) - 1, as.numeric(test$isQ1) - 1)

#error count
err_Q1_pol = sum(abs(as.numeric(pred_Q1_pol) - as.numeric(test$isQ1)))
err_Q1_pol #1813

#confusion matrix
table(pred_Q1_pol, test$isQ1)

#precision = tp/tp + fp
precision_Q1_pol <- 1142/(1142 + 392)
precision_Q1_pol #.744

#recall = tp/tp + tn
recall_Q1_pol <- 1142/(1142 + 1421)
recall_Q1_pol #.446

#F1 = 2*((precision*recall)/(precision + recall))
F1_Q1_pol <- 2*((precision_Q1_pol * recall_Q1_pol)/(precision_Q1_pol + recall_Q1_pol))
F1_Q1_pol #.558

#AUC
library(pROC)

score_Q1_pol = attr(pred_Q1_pol, "probabilities")
score_Q1_pol <- ifelse(pred_Q1_pol == "0", 1-score_Q1_pol, score_Q1_pol)

modelroc_Q1_pol =  roc(test$isQ1, score_Q1_pol)
plot_Q1_pol <- plot(modelroc_Q1_pol, print.auc=TRUE, auc.polygon=TRUE, grid=c(0.1, 0.2),
                    grid.col = c("green", "red"), max.auc.polygon=TRUE,
                    auc.polygon.col = "skyblue")



#Q4-----------------------------------------------------------------------

#linear------------------------------------------------------------------

res_Q4_lin = svm(train_sub, as.factor(train$isQ4), kernel = "linear", probability = T)

pred_Q4_lin = predict(res_Q4_lin, test_sub, probability = T)

#predict vs. true
cbind(as.numeric(pred_Q4_lin) - 1, as.numeric(test$isQ4) - 1)

#error count
err_Q4_lin = sum(abs(as.numeric(pred_Q4_lin) - as.numeric(test$isQ4)))
err_Q4_lin #1878

#confusion matrix
table(pred_Q4_lin, test$isQ4)

#precision = tp/tp + fp
precision_Q4_lin <- 1628/(1628 + 501)
precision_Q4_lin #.765

#recall = tp/tp + tn
recall_Q4_lin <- 1628/(1628 + 1379)
recall_Q4_lin #.541

#F1 = 2*((precision*recall)/(precision + recall))
F1_Q4_lin <- 2*((precision_Q4_lin * recall_Q4_lin)/(precision_Q4_lin + recall_Q4_lin))
F1_Q4_lin #.634

score_Q4_lin = attr(pred_Q4_lin, "probabilities")
score_Q4_lin <- ifelse(pred_Q4_lin == "0", 1-score_Q4_lin, score_Q4_lin)

modelroc_Q4_lin =  roc(test$isQ4, score_Q4_lin)
plot_Q4_lin <- plot(modelroc_Q4_lin, print.auc=TRUE, auc.polygon=TRUE, grid=c(0.1, 0.2),
                    grid.col = c("green", "red"), max.auc.polygon=TRUE,
                    auc.polygon.col = "skyblue")

#AUC = .601

#polynomial------------------------------------------------------------

res_Q4_pol = svm(train_sub, as.factor(train$isQ4), kernel = "polynomial", probability = T)
pred_Q4_pol = predict(res_Q4_pol, test_sub, probability = T)

#predict vs. true
cbind(as.numeric(pred_Q4_pol) - 1, as.numeric(test$isQ4) - 1)

#error count
err_Q4_pol = sum(abs(as.numeric(pred_Q4_pol) - as.numeric(test$isQ4)))
err_Q4_pol #2092

#confusion matrix
table(pred_Q4_pol, test$isQ4)

#precision = tp/tp + fp
precision_Q4_pol <- 1362/(1362 + 447)
precision_Q4_pol #.753

#recall = tp/tp + tn
recall_Q4_pol <- 1362/(1362 + 1645)
recall_Q4_pol #.453

#F1 = 2*((precision*recall)/(precision + recall))
F1_Q4_pol <- 2*((precision_Q4_pol * recall_Q4_pol)/(precision_Q4_pol + recall_Q4_pol))
F1_Q4_pol #.565

score_Q4_pol <- attr(pred_Q4_pol, "probabilities")
score_Q4_pol <- ifelse(pred_Q4_pol == "0", 1-score_Q4_pol, score_Q4_pol)

modelroc_Q4_pol =  roc(test$isQ4, score_Q4_pol)
plot_Q4_pol <- plot(modelroc_Q4_pol, print.auc=TRUE, auc.polygon=TRUE, grid=c(0.1, 0.2),
                    grid.col = c("green", "red"), max.auc.polygon=TRUE,
                    auc.polygon.col = "skyblue")

#AUC = .680
