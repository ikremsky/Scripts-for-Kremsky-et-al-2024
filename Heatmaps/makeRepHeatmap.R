.libPaths(c("/home/samir/R/x86_64-pc-linux-gnu-library/4.0/", .libPaths()))
# Load required packages
library("ComplexHeatmap")
library("circlize")

# Load data
args=as.character(commandArgs(trailingOnly=T))
data=read.delim(args[1], header=T, sep="\t", row.names=1)
M=as.matrix(data[,1:length(colnames(data))])
heatmap_name=args[2]


###############################################################
### The first half of this script is for the creation of the 0G vs HGC heatmaps for both ON and RTN

### Create 0G replicates + HGC replicates matrix
patterns=c("0G", "HGC")
cols=colnames(M)[grep(paste(patterns, collapse = "|"), colnames(M))]
GO_matrix=M[, cols]

### Create Log2fc matrix
log2fc_data=read.delim(args[3], header=T, sep="\t", row.names=1)
log2fc_matrix=as.matrix(log2fc_data)
ordered_reps=log2fc_matrix

### Match row order
log2fc_matrix=log2fc_matrix[rownames(data),]

### Order the replicates matrix by the Log2fc values
ordrM=GO_matrix[order(log2fc_data),]
ordrLog=log2fc_data[order(log2fc_data),]



##############################
### Creation of histogram to see the distribution of the data to know where to put the breakpoints
### Make Histogram to determine legend range and breakpoints
GO_vector=as.vector(GO_matrix)
png(paste("Histogram_", heatmap_name, ".png", sep=""), height = 2000, width = 2000, res = 300)
hist(GO_vector, breaks=100)
dev.off()
##############################



### Heatmap Creation
### ON Breakpoints (commemt out as needed based on the celltype you grep for in the associated bash script)
breakpoints=seq(0, 8000, by = 500)
colorpoints=colorRamp2(c(0, 5, 100, 1000, 8000), c("white", "green", "purple", "orange", "black"))

### RTN Breakpoints (commemt out as needed based on the celltype you grep for in the associated bash script)
breakpoints=seq(0, 4000, by = 400)
colorpoints=colorRamp2(c(0, 5, 50, 200, 4000), c("white", "green", "purple", "orange", "black"))


png(paste("Heatmap_", "Color_", heatmap_name, "_0GvsHGC_0.05", ".png", sep=""), height = 2000, width = 2000, res = 300)
pdf(file=paste("Heatmap_", heatmap_name, "_0GvsHGC.pdf", sep=""))
Normalized_heatmap=Heatmap(ordrM, name=heatmap_name, col = colorpoints, heatmap_legend_param = list(at = breakpoints), show_row_names = FALSE, cluster_rows = TRUE, cluster_columns = FALSE)
Log2_heatmap=Heatmap(ordrLog, name = "Log2Fold", col = colorRamp2(c(-3, 0, 3), c("blue","white", "red")), show_row_names = FALSE, cluster_rows = FALSE)
draw(Log2_heatmap + Normalized_heatmap)
dev.off()




###############################################################
### The second half of this script is for the creation of the average heatmaps for both ON and RTN


### Create the individual matricies that will go into the combined heatmap
### Create 0G Matrix
Ocolnames=c(grep("_0G", colnames(M)))
GO_matrix=M[, Ocolnames]
FLT_0G_average=rowMeans(GO_matrix[, colnames(GO_matrix)])

### Create 0.33G Matrix
Threecolnames=c(grep("_0.33G", colnames(M)))
GO.33_matrix=M[, Threecolnames]
FLT_0.33G_average=rowMeans(GO.33_matrix[, colnames(GO.33_matrix)])

### Create 0.67G Matrix
Sixcolnames=c(grep("_0.67G", colnames(M)))
GO.67_matrix=M[, Sixcolnames]
FLT_0.67G_average=rowMeans(GO.67_matrix[, colnames(GO.67_matrix)])

### Create 1G Matrix
Onecolnames=c(grep("_1G", colnames(M)))
G1_matrix=M[, Onecolnames]
FLT_1G_average=rowMeans(G1_matrix[, colnames(G1_matrix)])

### Create HGC Matrix
HGCcolnames=c(grep("HGC", colnames(M)))
HGC_matrix=M[, HGCcolnames]
HGC_average=rowMeans(HGC_matrix[, colnames(HGC_matrix)])



### Create Combined Average Matrix
Average_M=cbind(FLT_0G_average, FLT_0.33G_average, FLT_0.67G_average, FLT_1G_average, HGC_average)

### Order the averaged matrix by hierachial clustering
hclust_avg=hclust(dist(Average_M))
A_M=Average_M[hclust_avg$order,]



### Heatmap Creation
### ON Breakpoints (commemt out as needed based on the celltype you grep for in the associated bash script)
breakpoints=seq(0, 8000, by = 500)
colorpoints=colorRamp2(c(0, 15, 150, 1000, 8000), c("white", "green", "purple", "orange", "black"))

### RTN Breakpoints (commemt out as needed based on the celltype you grep for in the associated bash script)
breakpoints=seq(0, 4000, by = 400)
colorpoints=colorRamp2(c(0, 10, 60, 200, 4000), c("white", "green", "purple", "orange", "black"))


png(paste("Heatmap3_", heatmap_name, "_AvgSig_0.05", ".png", sep=""), height = 2000, width = 2000, res = 300)
pdf(file=paste("Heatmap_", heatmap_name, "_0GvsHGC_Avg.pdf", sep=""))
Average_heatmap=Heatmap(A_M, name=heatmap_name, col = colorpoints, heatmap_legend_param = list(at = breakpoints), show_row_names = FALSE, cluster_rows = TRUE, cluster_columns = FALSE)
draw(Average_heatmap)
dev.off()