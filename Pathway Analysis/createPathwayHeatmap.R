.libPaths(c("/home/samir/R/x86_64-pc-linux-gnu-library/4.0/", .libPaths()))
library("ComplexHeatmap")
library("circlize")

### Load data
args=as.character(commandArgs(trailingOnly=T))
i=1
data=read.delim(args[i], header=T, sep="\t", row.names=2); i=i+1
name=args[i]; i=i+1
sample=args[i]; i=i+1
M=data[,1:length(colnames(data)), drop=F]


### Get the top 10 significant gene symbols
log=as.numeric(M[, 2])
ordr=order(abs(log), decreasing=T)
N=M[ordr, ]
M=head(N, n=10)
nrow(M)


### Create the individual matricies that will go into the combined heatmap
# Create 0G Matrix
Ocolnames=c(grep("_0G", colnames(M)))
GO_matrix=M[, Ocolnames]
FLT_0G_columns=c(grep("FLT", colnames(GO_matrix)))
FLT_0G_average=rowMeans(GO_matrix[, FLT_0G_columns])

# Create 0.33G Matrix
Threecolnames=c(grep("_0.33G", colnames(M)))
GO.33_matrix=M[, Threecolnames]
FLT_0.33G_columns=c(grep("FLT", colnames(GO.33_matrix)))
FLT_0.33G_average=rowMeans(GO.33_matrix[, FLT_0.33G_columns])

# Create 0.67G Matrix
Sixcolnames=c(grep("_0.67G", colnames(M)))
GO.67_matrix=M[, Sixcolnames]
FLT_0.67G_columns=c(grep("FLT", colnames(GO.67_matrix)))
FLT_0.67G_average=rowMeans(GO.67_matrix[, FLT_0.67G_columns])

# Create 1G Matrix
Onecolnames=c(grep("_1G", colnames(M)))
G1_matrix=M[, Onecolnames]
FLT_1G_columns=c(grep("FLT", colnames(G1_matrix)))
FLT_1G_average=rowMeans(G1_matrix[, FLT_1G_columns])

# Create HGC Matrix
HGCcolnames=c(grep("HGC", colnames(M)))
HGC_matrix=M[, HGCcolnames]
HGC_columns=c(grep("HGC", colnames(HGC_matrix)))
HGC_average=rowMeans(HGC_matrix[, HGC_columns])



### Create Combined Average Matrix
Average_M=cbind(FLT_0G_average, FLT_0.33G_average, FLT_0.67G_average, FLT_1G_average, HGC_average)
hclust_avg=hclust(dist(Average_M))
A_M=Average_M[hclust_avg$order,]


title=c(paste(name, "_", sample, sep=""))



### Make Histogram to determine legend range and breakpoints
AM_vector=as.vector(A_M)
png(paste("Histogram_", title, "_Pathway.png", sep=""), height = 2000, width = 2000, res = 300)
hist(AM_vector, breaks=100)
dev.off()


### Establishing breakpoint and color parameters for each heatmap
#p53 ON
breakpoints=seq(0, 17000, by = 2000)
color=colorRamp2(c(0, 50, 17000), c("green", "white", "black"))


#PPAR RTN
breakpoints=seq(0, 1500, by = 500)
color=colorRamp2(c(0, 25, 1500), c("green", "white", "black"))



### Formation of average Pathway Heatmaps
png(paste(title, "_Pathway", "_AvgHeatmap", ".png", sep=""), height = 2000, width = 2000, res = 300)
pdf(file=paste("Pathway_Heatmap_", title, ".pdf", sep=""))
Average_heatmap=Heatmap(A_M, name=title, col = color, heatmap_legend_param = list(at = breakpoints), show_row_names = T, cluster_rows = TRUE, cluster_columns = FALSE)
draw(Average_heatmap)
dev.off()