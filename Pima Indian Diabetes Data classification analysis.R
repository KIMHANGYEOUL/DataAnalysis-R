getwd()
setwd('C:/Users/user/Desktop/���Ѱ�/������ ���̴�')
Pima<-read.csv('Pima Indian Diabetes.csv')
Pima
install.packages("rpart")
install.packages("e1071")
install.packages("mass")
install.packages("C50")
install.packages("class")
library(e1071)
library(MASS)
library(rpart)
library(class)
library(C50)
library(randomForest)

plot(Pima)
##����ġ ó��
Pima.NA<-Pima
Pima.NA[Pima.NA$PGC==0,]$PGC<-NA
Pima.NA[Pima.NA$DBP==0,]$DBP<-NA
Pima.NA[Pima.NA$TSFT==0,]$TSFT<-NA
Pima.NA[Pima.NA$SI2H==0,]$SI2H<-NA
Pima.NA[Pima.NA$BMI==0,]$BMI<-NA
##class 0, 1
Pima.NA_0<-Pima.NA[Pima.NA$Target==0,]
Pima.NA_1<-Pima.NA[Pima.NA$Target==1,]
##�Ʒ����� ������ 8:2 �н��ڷ� ����
set.seed(1128)
sample.no_0<-sample(1:nrow(Pima.NA_0),nrow(Pima.NA_0)*0.8)
sample.no_1<-sample(1:nrow(Pima.NA_1),nrow(Pima.NA_1)*0.8)
Pima_train.NA<-rbind(Pima.NA_0[sample.no_0,],Pima.NA_1[sample.no_1,])
Pima_test.NA<-rbind(Pima.NA_0[-sample.no_0,],Pima.NA_1[-sample.no_1,])

##naiveBayesian �𵨻���
library(e1071)
fit.NA.naive<-naiveBayes(as.factor(Target)~.,data=Pima_train.NA)
fit.NA.naive
##�Ʒ����� ���з�ǥ
pred_tr.NA.naive_C<-predict(fit.NA.naive, newdata=Pima_train.NA)
CM_tr.NA.naive<-table(actual=Pima_train.NA$Target,predicted=pred_tr.NA.naive_C)
CM_tr.NA.naive 
##������ ���з�ǥ
pred_te.NA.naive_C<-predict(fit.NA.naive, newdata=Pima_test.NA)
CM_te.NA.naive<-table(actual=Pima_test.NA$Target,predicted=pred_te.NA.naive_C)
CM_te.NA.naive

##rpart �� ���� 
tuning.NA.cart<-tune.rpart(Target~.,data=Pima_train.NA,minsplit=14:21,minbucket=4:11)
tuning.NA.cart
fit.NA.cart<-rpart(as.factor(Target)~.,data=Pima_train.NA, control=list(minsplit=tuning.NA.cart$best.parameters[,1],minbucket=tuning.NA.cart$best.parameters[,2]))
fit.NA.cart
##�Ʒ����� ���з�ǥ
pred_tr.NA.cart_C<-predict(fit.NA.cart,newdata=Pima_train.NA,type="class")
CM_tr.NA.cart<-table(actual=Pima_train.NA$Target,predicted=pred_tr.NA.cart_C)
CM_tr.NA.cart
##������ ���з�ǥ
pred_te.NA.cart_C<-predict(fit.NA.cart,newdata=Pima_test.NA,type="class")
CM_te.NA.cart<-table(actual=Pima_test.NA$Target,predicted=pred_te.NA.cart_C)
CM_te.NA.cart

#########C5.0 �� ����
fit.NA.C50<-C5.0(as.factor(Target)~.,data=Pima_train.NA,control=C5.0Control(minCases=10))
summary(fit.NA.C50)
##�Ʒ����� ���з�ǥ
pred_tr.NA.C50<-predict(fit.NA.C50,newdata=Pima_train.NA,type="class")
CM_tr.NA.C50<-table(actual=Pima_train.NA$Target,predicted=pred_tr.NA.C50)
CM_tr.NA.C50
##������ ���з�ǥ
pred_te.NA.C50_C<-predict(fit.NA.C50,newdata=Pima_test.NA,type="class")
CM_te.NA.C50<-table(actual=Pima_test.NA$Target,predicted=pred_te.NA.C50_C)
CM_te.NA.C50
###����ġ�� class mean���� ��ü
Pima.NA_rep=Pima.NA 
classMean_PGC<-tapply(Pima.NA[!is.na(Pima.NA$PGC),]$PGC,Pima[!is.na(Pima.NA$PGC),]$Target,mean)
classMean_PGC
Pima.NA_rep$PGC[is.na(Pima.NA_rep$PGC)&Pima.NA_rep$Target==0]<-classMean_PGC[1]
Pima.NA_rep$PGC[is.na(Pima.NA_rep$PGC)&Pima.NA_rep$Target==1]<-classMean_PGC[2]

classMean_DBP<-tapply(Pima.NA[!is.na(Pima.NA$DBP),]$DBP,Pima[!is.na(Pima.NA$DBP),]$Target,mean)
classMean_DBP
Pima.NA_rep$DBP[is.na(Pima.NA_rep$DBP)&Pima.NA_rep$Target==0]<-classMean_DBP[1]
Pima.NA_rep$DBP[is.na(Pima.NA_rep$DBP)&Pima.NA_rep$Target==1]<-classMean_DBP[2]

classMean_TSFT<-tapply(Pima.NA[!is.na(Pima.NA$TSFT),]$TSFT,Pima[!is.na(Pima.NA$TSFT),]$Target,mean)
classMean_TSFT
Pima.NA_rep$TSFT[is.na(Pima.NA_rep$TSFT)&Pima.NA_rep$Target==0]<-classMean_TSFT[1]
Pima.NA_rep$TSFT[is.na(Pima.NA_rep$TSFT)&Pima.NA_rep$Target==1]<-classMean_TSFT[2]

classMean_SI2H<-tapply(Pima.NA[!is.na(Pima.NA$SI2H),]$SI2H,Pima[!is.na(Pima.NA$SI2H),]$Target,mean)
classMean_SI2H
Pima.NA_rep$SI2H[is.na(Pima.NA_rep$SI2H)&Pima.NA_rep$Target==0]<-classMean_SI2H[1]
Pima.NA_rep$SI2H[is.na(Pima.NA_rep$SI2H)&Pima.NA_rep$Target==1]<-classMean_SI2H[2]

classMean_BMI<-tapply(Pima.NA[!is.na(Pima.NA$BMI),]$BMI,Pima[!is.na(Pima.NA$BMI),]$Target,mean)
classMean_BMI
Pima.NA_rep$BMI[is.na(Pima.NA_rep$BMI)&Pima.NA_rep$Target==0]<-classMean_BMI[1]
Pima.NA_rep$BMI[is.na(Pima.NA_rep$BMI)&Pima.NA_rep$Target==1]<-classMean_BMI[2]

##class 0, class1
Pima.NA_rep_0<-Pima.NA_rep[Pima.NA_rep$Target==0,]
Pima.NA_rep_1<-Pima.NA_rep[Pima.NA_rep$Target==1,]
##�Ʒ����� ���� 8:2
set.seed(1128)
sample.no_rep_0<-sample(1:nrow(Pima.NA_rep_0),nrow(Pima.NA_rep_0)*0.8)
sample.no_rep_1<-sample(1:nrow(Pima.NA_rep_1),nrow(Pima.NA_rep_1)*0.8)
Pima_train_rep.NA<-rbind(Pima.NA_rep_0[sample.no_rep_0,],Pima.NA_rep_1[sample.no_rep_1,])
Pima_test_rep.NA<-rbind(Pima.NA_rep_0[-sample.no_rep_0,],Pima.NA_rep_1[-sample.no_rep_1,])

##naiveBayesian ����ġ ��ü classmean
fit.NA.naive_rep<-naiveBayes(as.factor(Target)~.,data=Pima_train_rep.NA)
fit.NA.naive_rep
##�Ʒ����� ���з�ǥ
pred_tr.NA.naive_rep_C<-predict(fit.NA.naive_rep, newdata=Pima_train_rep.NA)
CM_tr.NA.naive_rep<-table(actual=Pima_train_rep.NA$Target,predicted=pred_tr.NA.naive_rep_C)
CM_tr.NA.naive_rep 
##������ ���з�ǥ
pred_te.NA.naive_rep_C<-predict(fit.NA.naive_rep, newdata=Pima_test_rep.NA)
CM_te.NA.naive_rep<-table(actual=Pima_test_rep.NA$Target,predicted=pred_te.NA.naive_rep_C)
CM_te.NA.naive_rep

##rpart ����ġ ��ü classmean
tuning.NA.cart_rep<-tune.rpart(Target~.,data=Pima_train_rep.NA,minsplit=14:21,minbucket=4:11)
tuning.NA.cart_rep
fit.NA.cart_rep<-rpart(as.factor(Target)~.,data=Pima_train_rep.NA,
                       control=list(minsplit=tuning.NA.cart_rep$best.parameters[,1],minbucket=tuning.NA.cart_rep$best.parameters[,2]))
fit.NA.cart_rep
##�Ʒ����� ���з�ǥ
pred_tr.NA.cart_rep_C<-predict(fit.NA.cart_rep,newdata=Pima_train_rep.NA,type="class")
CM_tr.NA.cart_rep<-table(actual=Pima_train_rep.NA$Target,predicted=pred_tr.NA.cart_rep_C)
CM_tr.NA.cart_rep
##������ ���з�ǥ
pred_te.NA.cart_rep_C<-predict(fit.NA.cart_rep,newdata=Pima_test_rep.NA,type="class")
CM_te.NA.cart_rep<-table(actual=Pima_test_rep.NA$Target,predicted=pred_te.NA.cart_rep_C)
CM_te.NA.cart_rep
##C5.0 �� ���� ����ġ ��ü classmean
fit.NA.C50_rep<-C5.0(as.factor(Target)~.,data=Pima_train_rep.NA,control=C5.0Control(minCases=10))
summary(fit.NA.C50_rep)
##�Ʒ����� ���з�ǥ
pred_tr.NA.C50_rep<-predict(fit.NA.C50_rep,newdata=Pima_train_rep.NA,type="class")
CM_tr.NA.C50_rep<-table(actual=Pima_train_rep.NA$Target,predicted=pred_tr.NA.C50_rep)
CM_tr.NA.C50_rep
##������ ���з�ǥ
pred_te.NA.C50_rep_C<-predict(fit.NA.C50_rep,newdata=Pima_test_rep.NA,type="class")
CM_te.NA.C50_rep<-table(actual=Pima_test_rep.NA$Target,predicted=pred_te.NA.C50_rep_C)
CM_te.NA.C50_rep

##knn �� ����
set.seed(1128)
tuning.knn<-tune.knn(x=Pima_train_rep.NA[,-9],y=as.factor(Pima_train_rep.NA$Target),k=seq(5,19,by=2))
tuning.knn
##�Ʒ����� ���з�ǥ
pred_tr.NA.knn_rep_C<-knn(Pima_train_rep.NA[,-9],Pima_train_rep.NA[,-9],
                          cl=as.factor(Pima_train_rep.NA$Target),
                          k=tuning.knn$best.parameters[,1])
CM_tr.NA.knn_rep<-table(actual=as.factor(Pima_train_rep.NA$Target),predicted=pred_tr.NA.knn_rep_C)
CM_tr.NA.knn_rep
##������ ���з�ǥ
pred_te.NA.knn_rep_C<-knn(Pima_train_rep.NA[,-9],Pima_test_rep.NA[,-9],
                          cl=as.factor(Pima_train_rep.NA$Target),
                          k=tuning.knn$best.parameters[,1])
CM_te.NA.knn_rep<-table(actual=as.factor(Pima_test_rep.NA$Target),predicted=pred_te.NA.knn_rep_C)
CM_te.NA.knn_rep

#logit �� ����(1) All Variables
fit.NA.logit_rep<-glm(Target~.,data=Pima_train_rep.NA,family="binomial")
summary(fit.NA.logit_rep)
##�Ʒ����� ���з�ǥ
pred_tr.NA.logit_rep<-predict(fit.NA.logit_rep,newdata=Pima_train_rep.NA,type="response")
pred_tr.NA.logit_rep_C<-ifelse(pred_tr.NA.logit_rep>0.5,1,0)
CM_tr.NA.logit_rep<-table(actual=Pima_train_rep.NA$Target,predicted=pred_tr.NA.logit_rep_C)
CM_tr.NA.logit_rep
##������ ���з�ǥ
pred_te.NA.logit_rep<-predict(fit.NA.logit_rep,newdata=Pima_test_rep.NA,type="response")
pred_te.NA.logit_rep_C<-ifelse(pred_te.NA.logit_rep>0.5,1,0)
CM_te.NA.logit_rep<-table(actual=Pima_test_rep.NA$Target,predicted=pred_te.NA.logit_rep_C)
CM_te.NA.logit_rep

##logit �� ����(2) Stepwise regression (��������)
fit.NA.step_rep<-stepAIC(fit.NA.logit_rep,direction = "both")
summary(fit.NA.step_rep)
##�Ʒ����� ���з�ǥ
pred_tr.NA.step_rep<-predict(fit.NA.step_rep,newdata=Pima_train_rep.NA,type="response")
pred_tr.NA.step_rep_C<-ifelse(pred_tr.NA.step_rep>0.5,1,0)
CM_tr.NA.step_rep<-table(actual=Pima_train_rep.NA$Target,predicted=pred_tr.NA.step_rep_C)
CM_tr.NA.step_rep
##������ ���з�ǥ
pred_te.NA.step_rep<-predict(fit.NA.step_rep,newdata=Pima_test_rep.NA,type="response")
pred_te.NA.step_rep_C<-ifelse(pred_te.NA.step_rep>0.5,1,0)
CM_te.NA.step_rep<-table(actual=Pima_test_rep.NA$Target,predicted=pred_te.NA.step_rep_C)
CM_te.NA.step_rep

##lda �𵨻���
fit.NA.lda_rep<-lda(Target~.,data=Pima_train_rep.NA)
head(fit.NA.lda_rep)
##�Ʒ����� ���з�ǥ
pred_tr.NA.lda_rep<-predict(fit.NA.lda_rep,newdata=Pima_train_rep.NA)
CM_tr.NA.lda_rep<-table(actual=Pima_train_rep.NA$Target,predicted=pred_tr.NA.lda_rep$class)
CM_tr.NA.lda_rep
##������ ���з�ǥ
pred_te.NA.lda_rep<-predict(fit.NA.lda_rep,newdata=Pima_test_rep.NA)
CM_te.NA.lda_rep<-table(actual=Pima_test_rep.NA$Target,predicted=pred_te.NA.lda_rep$class)
CM_te.NA.lda_rep

##linear svm �� ����
set.seed(1128)
##tuning parameters
tuning.linearSVM<-tune.svm(Target~.,cost=c(seq(0.1,1,by=0.1),1:5),kernel="linear",
                           data=Pima_train_rep.NA)
tuning.linearSVM$best.parameters
fit.NA.linearSVM_rep<-svm(Target~.,cost=tuning.linearSVM$best.parameters[,1],
                          kernel="linear",data=Pima_train_rep.NA)
summary(fit.NA.linearSVM_rep)
##�Ʒ����� ���з�ǥ
pred_tr.NA.linearSVM_C<-predict(fit.NA.linearSVM_rep,newdata=Pima_train_rep.NA)
CM_tr.NA.linearSVM_rep<-table(actual=Pima_train_rep.NA$Target,predicted=pred_tr.NA.linearSVM_C)
CM_tr.NA.linearSVM_rep
##������ ���з�ǥ
pred_te.NA.linearSVM_C<-predict(fit.NA.linearSVM_rep,newdata=Pima_test_rep.NA)
CM_te.NA.linearSVM_rep<-table(actual=Pima_test_rep.NA$Target,predicted=pred_te.NA.linearSVM_C)
CM_te.NA.linearSVM_rep

##polynomial svm �� ����
##tuning parameters
set.seed(1128)
tuning.polySVM<-tune.svm(Target~.,cost=c(seq(0.1,1,by=0.1),1:5),kernel="polynomial",
                         degree=2:5,data=Pima_train_rep.NA)
tuning.polySVM$best.parameters
fit.NA.polySVM_rep<-svm(Target~.,kernel="polynomial",cost=tuning.polySVM$best.parameters[,2],
                        degree=tuning.polySVM$best.parameters[,1],
                        data=Pima_train_rep.NA)
summary(fit.NA.polySVM_rep)
##�Ʒ����� ���з�ǥ
pred_tr.NA.polySVM_C<-predict(fit.NA.polySVM_rep,newdata=Pima_train_rep.NA)
CM_tr.NA.polySVM_rep<-table(actual=Pima_train_rep.NA$Target,predicted=pred_tr.NA.polySVM_C)
CM_tr.NA.polySVM_rep
##������ ���з�ǥ
pred_te.NA.polySVM_C<-predict(fit.NA.polySVM_rep,newdata=Pima_test_rep.NA)
CM_te.NA.polySVM_rep<-table(actual=Pima_test_rep.NA$Target,predicted=pred_te.NA.polySVM_C)
CM_te.NA.polySVM_rep

##radial svm �� ����
set.seed(1128)
tuning.radSVM<-tune.svm(Target~.,data=Pima_train_rep.NA,cost=c(seq(0.1,1,by=0.1),1:5),
                        kernel="radial",gamma=10^(-4:2))
tuning.radSVM$best.parameters
fit.NA.radSVM_rep<-svm(Target~.,kernel="radial",cost=tuning.radSVM$best.parameters[,2],
                       gamma=tuning.radSVM$best.parameters[,1],
                       data=Pima_train_rep.NA)
summary(fit.NA.radSVM_rep)
##�Ʒ����� ���з�ǥ
pred_tr.NA.radSVM_C<-predict(fit.NA.radSVM_rep,newdata=Pima_train_rep.NA)
CM_tr.NA.radSVM_rep<-table(actual=Pima_train_rep.NA$Target,predicted=pred_tr.NA.radSVM_C)
CM_tr.NA.radSVM_rep
##������ ���з�ǥ
pred_te.NA.radSVM_C<-predict(fit.NA.radSVM_rep,newdata=Pima_test_rep.NA)
CM_te.NA.radSVM_rep<-table(actual=Pima_test_rep.NA$Target,predicted=pred_te.NA.radSVM_C)
CM_te.NA.radSVM_rep

##randimForest �� ����
set.seed(1128)
tuning.RF<-tune.randomForest(Target~.,data=Pima_test_rep.NA,
                             ntree=seq(50,150,by=10),mtry=3:5)
tuning.RF$best.parameters
fit.NA.RFSVM_rep<-randomForest(Target~.,ntree=tuning.RF$best.parameters[,2],
                               mtry=tuning.RF$best.parameters[,1],do.trace=30,
                               nodesize=10,importance=T,data=Pima_train_rep.NA)
fit.NA.RFSVM_rep
##�Ʒ����� ���з�ǥ
pred_tr.NA.RFSVM_C<-predict(fit.NA.RFSVM_rep,newdata=Pima_train_rep.NA,type="class")
CM_tr.NA.RFSVM_rep<-table(actual=Pima_train_rep.NA$Target,predicted=pred_tr.NA.RFSVM_C)
CM_tr.NA.RFSVM_rep
##������ ���з�ǥ
pred_te.NA.RFSVM_C<-predict(fit.NA.RFSVM_rep,newdata=Pima_test_rep.NA)
CM_te.NA.RFSVM_rep<-table(actual=Pima_test_rep.NA$Target,predicted=pred_te.NA.RFSVM_C)
CM_te.NA.RFSVM_rep

##����ġ ��ü(2) Missing Indicators �߰�
TSFT_I<-0
SI2H_I<-0
Pima.NA_I<-cbind(Pima.NA_rep,TSFT_I,SI2H_I)
Pima.NA_I[is.na(Pima.NA$TSFT),10]<-1
Pima.NA_I[is.na(Pima.NA$SI2H),11]<-1
Pima.NA_I$TSFT_I<-as.factor(Pima.NA_I$TSFT_I)
Pima.NA_I$SI2H_I<-as.factor(Pima.NA_I$SI2H_I)

##class 0, class1
Pima.NA_I_0<-Pima.NA_I[Pima.NA_I$Target==0,]
Pima.NA_I_1<-Pima.NA_I[Pima.NA_I$Target==1,]
##������ ���� 8:2
set.seed(1128)
sample.no_I_0<-sample(1:nrow(Pima.NA_I_0),nrow(Pima.NA_I_0)*0.8)
sample.no_I_1<-sample(1:nrow(Pima.NA_I_1),nrow(Pima.NA_I_1)*0.8)
Pima_train_I.NA<-rbind(Pima.NA_I_0[sample.no_I_0,],Pima.NA_I_1[sample.no_I_1,])
Pima_test_I.NA<-rbind(Pima.NA_I_0[-sample.no_I_0,],Pima.NA_I_1[-sample.no_I_1,])

##naiveBayesian ����ġ ��ü Missing Indicators �߰�
fit.NA.naive_I<-naiveBayes(as.factor(Target)~.,data=Pima_train_I.NA)
fit.NA.naive_I
##�Ʒ����� ���з�ǥ
pred_tr.NA.naive_I_C<-predict(fit.NA.naive_I, newdata=Pima_train_I.NA)
CM_tr.NA.naive_I<-table(actual=Pima_train_I.NA$Target,predicted=pred_tr.NA.naive_I_C)
CM_tr.NA.naive_I 
##������ ���з�ǥ
pred_te.NA.naive_I_C<-predict(fit.NA.naive_I, newdata=Pima_test_I.NA)
CM_te.NA.naive_I<-table(actual=Pima_test_I.NA$Target,predicted=pred_te.NA.naive_I_C)
CM_te.NA.naive_I

##rpart ����ġ ��ü Missing Indicators �߰�
tuning.NA.cart_I<-tune.rpart(Target~.,data=Pima_train_I.NA,minsplit=14:21,minbucket=4:11)
tuning.NA.cart_I
fit.NA.cart_I<-rpart(as.factor(Target)~.,data=Pima_train_I.NA,
                     control=list(minsplit=tuning.NA.cart_I$best.parameters[,1],minbucket=tuning.NA.cart_I$best.parameters[,2]))
fit.NA.cart_I
##�Ʒ����� ���з�ǥ
pred_tr.NA.cart_I_C<-predict(fit.NA.cart_I,newdata=Pima_train_I.NA,type="class")
CM_tr.NA.cart_I<-table(actual=Pima_train_I.NA$Target,predicted=pred_tr.NA.cart_I_C)
CM_tr.NA.cart_I
##������ ���з�ǥ
pred_te.NA.cart_I_C<-predict(fit.NA.cart_I,newdata=Pima_test_I.NA,type="class")
CM_te.NA.cart_I<-table(actual=Pima_test_I.NA$Target,predicted=pred_te.NA.cart_I_C)
CM_te.NA.cart_I
##C5.0 �� ���� ����ġ ��ü Missing Indicators �߰�
fit.NA.C50_I<-C5.0(as.factor(Target)~.,data=Pima_train_I.NA,control=C5.0Control(minCases=10))
summary(fit.NA.C50_I)
##�Ʒ����� ���з�ǥ
pred_tr.NA.C50_I<-predict(fit.NA.C50_I,newdata=Pima_train_I.NA,type="class")
CM_tr.NA.C50_I<-table(actual=Pima_train_I.NA$Target,predicted=pred_tr.NA.C50_I)
CM_tr.NA.C50_I
##������ ���з�ǥ
pred_te.NA.C50_I_C<-predict(fit.NA.C50_I,newdata=Pima_test_I.NA,type="class")
CM_te.NA.C50_I<-table(actual=Pima_test_I.NA$Target,predicted=pred_te.NA.C50_I_C)
CM_te.NA.C50_I

##knn �� ���� ����ġ ��ü Missing Indicators �߰�
set.seed(1128)
tuning.knn<-tune.knn(x=Pima_train_I.NA[,-9],y=as.factor(Pima_train_I.NA$Target),k=seq(5,19,by=2))
tuning.knn
##�Ʒ����� ���з�ǥ
pred_tr.NA.knn_I_C<-knn(Pima_train_I.NA[,-9],Pima_train_I.NA[,-9],
                        cl=as.factor(Pima_train_I.NA$Target),
                        k=tuning.knn$best.parameters[,1])
CM_tr.NA.knn_I<-table(actual=as.factor(Pima_train_I.NA$Target),predicted=pred_tr.NA.knn_I_C)
CM_tr.NA.knn_I
##������ ���з�ǥ
pred_te.NA.knn_I_C<-knn(Pima_train_I.NA[,-9],Pima_test_I.NA[,-9],cl=as.factor(Pima_train_I.NA$Target),
                        k=tuning.knn$best.parameters[,1])
CM_te.NA.knn_I<-table(actual=Pima_test_I.NA$Target,predicted=pred_te.NA.knn_I_C)
CM_te.NA.knn_I

#logit �� ����(1) ����ġ ��ü Missing Indicators �߰�, All Variables 
fit.NA.logit_I<-glm(Target~.,data=Pima_train_I.NA,family="binomial")
summary(fit.NA.logit_I)
##�Ʒ����� ���з�ǥ
pred_tr.NA.logit_I<-predict(fit.NA.logit_I,newdata=Pima_train_I.NA,type="response")
pred_tr.NA.logit_I_C<-ifelse(pred_tr.NA.logit_I>0.5,1,0)
CM_tr.NA.logit_I<-table(actual=Pima_train_I.NA$Target,predicted=pred_tr.NA.logit_I_C)
CM_tr.NA.logit_I
##������ ���з�ǥ
pred_te.NA.logit_I<-predict(fit.NA.logit_I,newdata=Pima_test_I.NA,type="response")
pred_te.NA.logit_I_C<-ifelse(pred_te.NA.logit_I>0.5,1,0)
CM_te.NA.logit_I<-table(actual=Pima_test_I.NA$Target,predicted=pred_te.NA.logit_I_C)
CM_te.NA.logit_I

##logit �� ����(2) ����ġ ��ü Missing Indicators �߰�, Stepwise regression (��������)
fit.NA.step_I<-stepAIC(fit.NA.logit_I,direction = "both")
summary(fit.NA.step_I)
##�Ʒ����� ���з�ǥ
pred_tr.NA.step_I<-predict(fit.NA.step_I,newdata=Pima_train_I.NA,type="response")
pred_tr.NA.step_I_C<-ifelse(pred_tr.NA.step_I>0.5,1,0)
CM_tr.NA.step_I<-table(actual=Pima_train_I.NA$Target,predicted=pred_tr.NA.step_I_C)
CM_tr.NA.step_I
##������ ���з�ǥ
pred_te.NA.step_I<-predict(fit.NA.step_I,newdata=Pima_test_I.NA,type="response")
pred_te.NA.step_I_C<-ifelse(pred_te.NA.step_I>0.5,1,0)
CM_te.NA.step_I<-table(actual=Pima_test_I.NA$Target,predicted=pred_te.NA.step_I_C)
CM_te.NA.step_I

##lda �𵨻��� ����ġ ��ü Missing Indicators �߰�
fit.NA.lda_I<-lda(Target~.,data=Pima_train_I.NA)
head(fit.NA.lda_I)
##�Ʒ����� ���з�ǥ
pred_tr.NA.lda_I<-predict(fit.NA.lda_I,newdata=Pima_train_I.NA)
CM_tr.NA.lda_I<-table(actual=Pima_train_I.NA$Target,predicted=pred_tr.NA.lda_I$class)
CM_tr.NA.lda_I
##������ ���з�ǥ
pred_te.NA.lda_I<-predict(fit.NA.lda_I,newdata=Pima_test_I.NA)
CM_te.NA.lda_I<-table(actual=Pima_test_I.NA$Target,predicted=pred_te.NA.lda_I$class)
CM_te.NA.lda_I

##linear svm �� ���� ����ġ ��ü Missing Indicators �߰�
set.seed(1128)
##tuning parameters
tuning.linearSVM<-tune.svm(Target~.,cost=c(seq(0.1,1,by=0.1),1:5),kernel="linear",
                           data=Pima_train_I.NA)
tuning.linearSVM$best.parameters
fit.NA.linearSVM_I<-svm(Target~.,cost=tuning.linearSVM$best.parameters[,1],
                        kernel="linear",data=Pima_train_I.NA)
summary(fit.NA.linearSVM_I)
##�Ʒ����� ���з�ǥ
pred_tr.NA.linearSVM_C<-predict(fit.NA.linearSVM_I,newdata=Pima_train_I.NA)
CM_tr.NA.linearSVM_I<-table(actual=Pima_train_I.NA$Target,predicted=pred_tr.NA.linearSVM_C)
CM_tr.NA.linearSVM_I
##������ ���з�ǥ
pred_te.NA.linearSVM_C<-predict(fit.NA.linearSVM_I,newdata=Pima_test_I.NA)
CM_te.NA.linearSVM_I<-table(actual=Pima_test_I.NA$Target,predicted=pred_te.NA.linearSVM_C)
CM_te.NA.linearSVM_I

##polynomial svm �� ���� ����ġ ��ü Missing Indicators �߰�
##tuning parameters
set.seed(1128)
tuning.polySVM<-tune.svm(Target~.,cost=c(seq(0.1,1,by=0.1),1:5),kernel="polynomial",
                         degree=2:5,data=Pima_train_I.NA)
tuning.polySVM$best.parameters
fit.NA.polySVM_I<-svm(Target~.,kernel="polynomial",cost=tuning.polySVM$best.parameters[,2],
                      degree=tuning.polySVM$best.parameters[,1],
                      data=Pima_train_I.NA)
summary(fit.NA.polySVM_I)
##�Ʒ����� ���з�ǥ
pred_tr.NA.polySVM_C<-predict(fit.NA.polySVM_I,newdata=Pima_train_I.NA)
CM_tr.NA.polySVM_I<-table(actual=Pima_train_I.NA$Target,predicted=pred_tr.NA.polySVM_C)
CM_tr.NA.polySVM_I
##������ ���з�ǥ
pred_te.NA.polySVM_C<-predict(fit.NA.polySVM_I,newdata=Pima_test_I.NA)
CM_te.NA.polySVM_I<-table(actual=Pima_test_I.NA$Target,predicted=pred_te.NA.polySVM_C)
CM_te.NA.polySVM_I

##radial svm �� ���� ����ġ ��ü Missing Indicators �߰�
set.seed(1128)
tuning.radSVM<-tune.svm(Target~.,data=Pima_train_I.NA,cost=c(seq(0.1,1,by=0.1),1:5),
                        kernel="radial",gamma=10^(-4:2))
tuning.radSVM$best.parameters
fit.NA.radSVM_I<-svm(Target~.,kernel="radial",cost=tuning.radSVM$best.parameters[,2],
                     gamma=tuning.radSVM$best.parameters[,1],
                     data=Pima_train_I.NA)
summary(fit.NA.radSVM_I)
##�Ʒ����� ���з�ǥ
pred_tr.NA.radSVM_C<-predict(fit.NA.radSVM_I,newdata=Pima_train_I.NA)
CM_tr.NA.radSVM_I<-table(actual=Pima_train_I.NA$Target,predicted=pred_tr.NA.radSVM_C)
CM_tr.NA.radSVM_I
##������ ���з�ǥ
pred_te.NA.radSVM_C<-predict(fit.NA.radSVM_I,newdata=Pima_test_I.NA)
CM_te.NA.radSVM_I<-table(actual=Pima_test_I.NA$Target,predicted=pred_te.NA.radSVM_C)
CM_te.NA.radSVM_I

##randimForest �� ����
set.seed(1128)
tuning.RF<-tune.randomForest(Target~.,data=Pima_test_I.NA,
                             ntree=seq(50,150,by=10),mtry=3:5)
tuning.RF$best.parameters
fit.NA.RFSVM_I<-randomForest(Target~.,ntree=tuning.RF$best.parameters[,2],
                             mtry=tuning.RF$best.parameters[,1],do.trace=30,
                             nodesize=10,importance=T,data=Pima_train_I.NA)
fit.NA.RFSVM_I
##�Ʒ����� ���з�ǥ
pred_tr.NA.RFSVM_C<-predict(fit.NA.RFSVM_I,newdata=Pima_train_I.NA,type="class")
CM_tr.NA.RFSVM_I<-table(actual=Pima_train_I.NA$Target,predicted=pred_tr.NA.RFSVM_C)
CM_tr.NA.RFSVM_I
##������ ���з�ǥ
pred_te.NA.RFSVM_C<-predict(fit.NA.RFSVM_I,newdata=Pima_test_I.NA)
CM_te.NA.RFSVM_I<-table(actual=Pima_test_I.NA$Target,predicted=pred_te.NA.RFSVM_C)
CM_te.NA.RFSVM_I
