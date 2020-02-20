rm(list=ls()) # Removes all objects from the current workspace (R memory)
options(scipen=999) # Do not print with Scientific Notation

# Program Details: Overview -----------------------------------------------
# *************************************************************************
script.meta <- list(
  Programmer   = "Ben Rommelaere",
  Project			 = "",
  Program      = "",
  Version      = 1,
  Date_Created = "MM/DD/YYYY",
  Last_Updated = "MM/DD/YYYY",
  ############################
  Description  = 
    "Description of program",
  ############################
  Notes        = 
    "Program notes"
)
# packages ----------------------------------------------------------------
library(tidyverse)
library(AppliedPredictiveModeling) # For data
library(randomForest) # For Random Forest
library(MASS) # For QDA
library(caret) # For sensititivity/specificity, etc
library(pROC) # For ROC Curve & its related statistics
# Paths -------------------------------------------------------------------
main <- "~/Project-Folder"
untouched <- file.path(main, "01 Untouched")
raw <- file.path(main, "02 Raw")
base <- file.path(main, "03 Base")
temp <- file.path(main, "04 Intermediate")
output <- file.path(main, "05 Output")
# *************************************************************************

# ----------------------------------------------------------
# 1: Setting Up Example Data and Prediction Models
# ----------------------------------------------------------
set.seed(975)
simulatedTrain <- quadBoundaryFunc(500)
simulatedTest <- quadBoundaryFunc(1000)
head(simulatedTrain)

# Random Forest Model
rfModel <- randomForest(class ~ X1 + X2,
                          data = simulatedTrain,
                          ntree = 2000)
# The random forest model requires two calls to the predict function to get the
# predicted classes and the class probabilities
rfTestPred <- predict(rfModel, simulatedTest, type = "prob")
simulatedTest$RFprob <- rfTestPred[,"Class1"]
simulatedTest$RFclass <- predict(rfModel, simulatedTest)

### Simple QDA Model
  # Estimate the model
  qdaModel <- qda(class ~ X1 + X2, data = simulatedTrain)
  # Get predictions for training dataset
  qdaTrainPred <- predict(qdaModel, simulatedTrain)
  # Get Class Probability for training dataset
  simulatedTrain$QDAprob <- qdaTrainPred$posterior[,"Class1"]
  
  # Predict the model for the test dataset
  qdaTestPred <- predict(qdaModel, simulatedTest)
  simulatedTest$QDAprob <- qdaTestPred$posterior[,"Class1"]

# 1.a: Specificity & Sensititvity ----------------------------------
## Class 1 will be used as the event of interest

# Random Forest Model    
sensitivity(data = simulatedTest$RFclass,
                  reference = simulatedTest$class,
                  positive = "Class1")
 
specificity(data = simulatedTest$RFclass,
              reference = simulatedTest$class,
              negative = "Class2")   

# Predictive values can also be computed either by using the prevalence found
# in the data set
posPredValue(data = simulatedTest$RFclass,
             reference = simulatedTest$class,
             positive = "Class1")

negPredValue(data = simulatedTest$RFclass,
             reference = simulatedTest$class,
             positive = "Class2")

# Change the prevalence manually
posPredValue(data = simulatedTest$RFclass,
                 reference = simulatedTest$class,
                 positive = "Class1",
                 prevalence = .9)

# Easily use the confusion matrix function from caret
# to calcluate confusion matrix and associated statistics
confusionMatrix(data = simulatedTest$RFclass,
                reference = simulatedTest$class,
                positive = "Class1")

## ROC Curve
rocCurve <- roc(response = simulatedTest$class,
                predictor = simulatedTest$RFprob,
                ## This function assumes that the second
                ## class is the event of interest, so we
                ## reverse the labels.
                levels = rev(levels(simulatedTest$class)),
                auc=TRUE,
                ci=TRUE,
                plot=TRUE
                ## Also, another curve can be added using
                ## add = TRUE the next time plot.auc is used.
                )
