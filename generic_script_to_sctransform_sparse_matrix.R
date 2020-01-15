#Load libraries.

library(sctransform)
library(Matrix)

#Accept paths to input sparse matrix file and output file prefix on command line.
#Input file can be either zipped or unzipped, I believe.

args <- commandArgs(trailingOnly=TRUE)
input_file <- args[1]
output_file_prefix <- args[2]

#Read in data.

raw_data <- readMM(input_file)

#Give data generic row and column names.

rownames(raw_data) <- paste0("Feature",1:nrow(raw_data))
colnames(raw_data) <- paste0("Cell",1:ncol(raw_data))

#Change matrix to appropriate class.
#Function readMM originally outputs dgTMatrix class. 
#Get error "matrix x needs to be of class matrix or dgCMatrix" if don't do this step.

raw_data <- as(raw_data,"dgCMatrix")

#Normalize data.

normalized_data <- sctransform::vst(raw_data)$y

#Change normalized matrix to appropriate class.
#Get error "unable to find an inherited method for function ‘writeMM’ for signature ‘"matrix"’" if don't do this step.

normalized_data <- as(normalized_data,"dgCMatrix")

#Output data.

writeMM(normalized_data,file=paste0(output_file_prefix,"_sctransform_normalized.mtx"))

#Normalization will only have been done on certain features.
#Output the indices of the features chosen to a separate text file.

feature_indices <- sapply(strsplit(rownames(normalized_data),"Feature"),"[[",2) #Change e.g. "Feature6" to "6".

write.table(feature_indices,file=paste0(output_file_prefix,"_sctransform_normalization_feature_indices.txt"),row.names=FALSE,col.names=FALSE,quote=FALSE)
