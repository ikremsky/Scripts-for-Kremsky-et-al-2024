#Stephen Justinen
library(MASS)
args=commandArgs(trailingOnly=TRUE)
i=1

spreadsheet=read.delim(as.character(args[i]), header=T, sep="\t"); i=i+1
outName=as.character(args[i])

#Reference Column Names: Retina_6W-GL_log2FoldChange    Retina_6W-GL_padj  UON_6W-GL_log2FoldChange   UON_6W-GL_padj  MON_6W-GL_log2FoldChange  MON_6W-GL_padj
M=spreadsheet[,1:length(colnames(spreadsheet)), drop=F]

ENSEMBL_Names=grep("ENSEMBL",colnames(M))
Gene_Names=grep("SYMBOL",colnames(M))
RTN_colnames=c(ENSEMBL_Names, Gene_Names, grep("Retina.*padj", colnames(M)), grep("Retina.*log2FoldChange", colnames(M)))
UON_colnames=c(ENSEMBL_Names, Gene_Names, grep("UON.*padj", colnames(M)), grep("UON.*log2FoldChange", colnames(M)))
MON_colnames=c(ENSEMBL_Names, Gene_Names, grep("MON.*padj", colnames(M)), grep("MON.*log2FoldChange", colnames(M)))

matrixRTN=M[, RTN_colnames]
matrixUON=M[, UON_colnames]
matrixMON=M[, MON_colnames]

RTN_Filename=paste("Retina_", outName, ".txt", sep = "", collapse = NULL)
UON_Filename=paste("UON_", outName, ".txt", sep = "", collapse = NULL)
MON_Filename=paste("MON_", outName, ".txt", sep = "", collapse = NULL)

write.matrix(matrixRTN, file = RTN_Filename, sep = "\t")
write.matrix(matrixUON, file = UON_Filename, sep = "\t")
write.matrix(matrixMON, file = MON_Filename, sep = "\t")
