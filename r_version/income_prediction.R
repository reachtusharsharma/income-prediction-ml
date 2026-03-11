#importing dataset

dataset= read.csv('adult.csv')


#missing data

dataset$age= ifelse(is.na(dataset$age),
                    ave(dataset$age, FUN = function(x)mean(x,na.rm=TRUE)),
                    dataset$age)
dataset$hours.per.week= ifelse(is.na(dataset$hours.per.week),
                       ave(dataset$hours.per.week, FUN = function(x)mean(x,na.rm=TRUE)),
                       dataset$hours.per.week)

#categorical data

dataset$income =factor(dataset$income,levels=c('<=50K','>50K'),labels=c(0,1))
dataset$gender=factor(dataset$gender,levels=c('Male','Female'),labels=c(1,2))

#preparing
dataset$income =ifelse(dataset$income=='0',0,1)

#training and test
#install.packages("caTools")
library(caTools)
split =sample.split(dataset,SplitRatio = 0.8)
training_set=subset(dataset,split==TRUE)
test_set=subset(dataset,split==FALSE)

#feature scale

training_set[,]=scale(training_set[,])
test_set[,]=scale(test_set[,])



#PREDICTIVE MODELS

#(A) Logistic Regression

model<- glm(income~hours.per.week+age+educational.num+gender+occupation,training_set,family= "binomial")
summary(model)
res<-predict(model,test_set,type="response")
res
confusionmatrix_lr<-table(Actualvalue=test_set$income,predicted_val=res>0.5)
accuract_lr <- (confusionmatrix_lr[1,1] + confusionmatrix_lr[2,2])/sum(confusionmatrix_lr)
#install.packages("ROCR")
res2=predict(model,training_set,type="response")
library(ROCR)
ROCPred=prediction(res2,training_set$income)
ROCProd=performance(ROCPred,"tpr","fpr")
plot(ROCProd,colorize=TRUE,print.cutoffs.at=seq(0.1,by=0.1))

#(B) RANDOM FOREST MODEL IMPLEMENTATION

bestmtry<-tuneRF(training_set,training_set$income,stepFactor=1.2,improve=0.01,trace=T,plot=T)
install.packages("randomForest")
library(randomForest)
trainSmall = training_set[sample(nrow(training_set), 5000), ]
model2<-randomForest(income~.,data=trainSmall)
census_predict_randomforest = predict(model2, newdata = test_set, type = "prob")
confusionmatrix_rf<-table(test_set$income, census_predict_randomforest[, 2] >= 0.5)
confusionmatrix_rf
accuract_rf <- (confusionmatrix_rf[1,1] + confusionmatrix_rf[2,2])/sum(confusionmatrix_rf)
library(ROCR)
ROC_randomforest = prediction(census_predict_randomforest[, 2], test_set$income)
as.numeric(performance(ROC_randomforest, "auc")@y.values)
performance3 = performance(ROC_randomforest, "tpr", "fpr")
plot(performance3, main = "Random Forest Model")
vu = varUsed(model2, count=TRUE)
vusorted = sort(vu, decreasing = FALSE, index.return = TRUE)
dotchart(vusorted$x, names(model2$forest$xlevels[vusorted$ix]))

#(C)Support Vector Machine implementation
install.packages("kernlab")
library(kernlab)
svm <- ksvm(income ~hours.per.week+age+educational.num+gender+occupation, data = training_set)
svm.pred.prob <- predict(svm, newdata = test_set, type = 'decision')
svm.pred <- predict(svm, newdata = test_set, type = 'response')
confusionmatrix_svm <- table(svm.pred, test_set$income)
confusionmatrix_svm
accuract_svm <- (confusionmatrix_svm[1,1] + confusionmatrix_svm[2,2])/sum(confusionmatrix_svm)
pr <- prediction(svm.pred.prob, test_set$income)
prf_svm <- performance(pr, measure = "tpr", x.measure = "fpr")
plot(prf_svm, main="Support Vector Machine Model")

#(D)NAIVE BAYES CLASSIFIER
install.packages("e1071")
library(e1071)
library(ROCR)
NB_model <- naiveBayes(income~age+educational.num+occupation+race+hours.per.week+native.country, data=training_set)
nbprediction = predict(NB_model, test_set, type='raw')
NB_p <- predict(NB_model, test_set[,-12])
pr_nb<-prediction(NB_p,test_set$income)
perf_nb <- performance(nbprediction, measure='tpr', x.measure='fpr')
plot(ROCProd,colorize=TRUE,print.cutoffs.at=seq(0.1,by=0.1))

accuracy <- sum(NB_p==test_set$income)/length(NB_p)
accuracy
