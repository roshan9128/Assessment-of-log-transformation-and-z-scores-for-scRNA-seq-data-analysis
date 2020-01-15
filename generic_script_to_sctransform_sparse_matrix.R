#Load libraries.

library(sctransform)
library(Matrix)
library(feather)

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
#Assuming input already cleaned, so set min_cells=1.

normalized_data <- sctransform::vst(raw_data,min_cells=1)$y

#Save as feather file.

write_feather(x=as.data.frame(normalized_data),path=paste0(output_prefix,"_sctransform_normalized.feather"))
