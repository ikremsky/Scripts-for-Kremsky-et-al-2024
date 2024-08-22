.libPaths(c("/home/samir/R/x86_64-pc-linux-gnu-library/4.0/", .libPaths()))

### Load in data
args=commandArgs(trailingOnly=T)
data=read.delim(args[1])

celltype=args[2]
type=args[3]

### Read the matrix from a file
mat <- as.matrix(read.table(args[1], header = TRUE))

### Make sure matrix is numeric
numeric=mat[,1:length(colnames(mat))]
numeric_cols <- apply(numeric, 2, function(x) as.numeric(as.character(x)))

### Take the log of each element in the matrix, adding 1 to each element first
dataset <- log(numeric_cols + 1)

cormat <- round(cor(dataset),3)
library(reshape2)
melted_cormat <- melt(cormat)
library(ggplot2)

### Make scatterplot
png(paste("Heatmap_", celltype, "cor_", type, ".png", sep=""), height = 2000, width = 2000, res = 300)
# pdf(file=paste("Correlate_", celltype, "_", type, ".pdf", sep=""))
ggplot(data = melted_cormat, aes(Var2, Var1, fill = value))+
 geom_tile(color = "white")+
 scale_fill_gradient2(low = "yellow", high = "blue", mid = "white", 
   midpoint = 0.75, limit = c(0.5,1), space = "Lab", 
   name="Pearson\nCorrelation") +
  theme_minimal()+ 
 theme(axis.text.x = element_text(angle = 45, vjust = 1, 
    size = 12, hjust = 1))+
 coord_fixed()
dev.off()
