#!/usr/bin/env Rscript
  
#libraries
library(scater) #object processing
library(harmony) #Harmony

args <- R.utils::commandArgs(asValues=TRUE)

if (is.null(args[["input"]])) {
  print("Provide a valid input file name --> RDS file")
  }
if (is.null(args[["output"]])) {
  print("Provide a valid outpsut file name --> RDS file")
    }

#INPUT!
dataset <- readRDS(args[["input"]])

#run PCA
dataset <- runPCA(dataset, exprs_values = "logcounts", ncomponents = 25)
pca <- dataset@reducedDims@listData[["PCA"]]
#cell batch label vector
batch_vector <-  as.character(dataset$Batch)

#run Harmony
dataset@reducedDims@listData[['corrected_embedding']] <- HarmonyMatrix(pca, batch_vector, theta=4, do_pca = F)
#Harmony outputs empty rownames for corrected_embedding. Add rownames
rownames(dataset@reducedDims@listData[['corrected_embedding']]) <- colnames(dataset)

print("congratulations, HARMONY worked!!!")

#OUTPUT!
saveRDS(dataset, args[["output"]])
