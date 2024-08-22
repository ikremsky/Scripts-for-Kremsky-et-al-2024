.libPaths(c("/home/samir/R/x86_64-pc-linux-gnu-library/4.0/", .libPaths()))
library(FactoMineR)
library("fastcluster")
library("gplots")
library("pheatmap")
library("qvalue")

args=commandArgs(trailingOnly = TRUE)
celltype=args[1]
print(celltype)
file_path <- sprintf("/home/rpergerson/FlightMice/NormalizedData/DESeq_%s_Normalized_Counts_newNames1.txt", celltype)
x <- read.delim(file_path, header = TRUE, sep = "\t")
nrow(x)
sums=apply(x[,-1], 1, max)
y=x[,-1]
genes=x[,1]
names=colnames(y)


assign(paste(celltype, "_FLT_0.33G", sep = ""), y[, grep(paste(celltype, "_FLT_0.33G", sep = ""), names)])
assign(paste(celltype, "_FLT_0.67G", sep = ""), y[, grep(paste(celltype, "_FLT_0.67G", sep = ""), names)])
assign(paste(celltype, "_FLT_1G", sep = ""), y[, grep(paste(celltype, "_FLT_1", sep = ""), names)])
assign(paste(celltype, "_FLT_0G", sep = ""), y[, grep(paste(celltype, "_FLT_0G", sep = ""), names)])
assign(paste(celltype, "_HGC", sep = ""), y[, grep(paste(celltype, "_HGC", sep = ""), names)])


y=t(y)
M=as.matrix(cbind(get(paste(celltype, "_FLT_0G", sep = "")), get(paste(celltype, "_FLT_0.33G", sep = "")), get(paste(celltype, "_FLT_0.67G", sep = "")), get(paste(celltype, "_FLT_1G", sep = "")), get(paste(celltype, "_HGC", sep = ""))))

P=NULL

ses=factor(c(rep(1,5), rep(2,6),rep(3,6), rep(4,6), rep(5,12)))

levels(ses)=c(paste(celltype, "_FLT_0G", sep = ""), paste(celltype, "_FLT_0.33G", sep = ""), paste(celltype, "_FLT_0.67G", sep = ""), paste(celltype, "_FLT_1G", sep = ""), paste(celltype, "_HGC", sep = ""))
print(levels(ses))



for(i in 1:length(x[,1]))
{
        a=aov(M[i,] ~ ses)
        P=c(P, unlist(summary(a))["Pr(>F)1"])
}
q=qvalue(P)$qvalues

signif=which(P<.05)


assign(paste(celltype, "_FLT_0G", sep = ""), get(paste(celltype, "_FLT_0G", sep = ""))[signif,])
assign(paste(celltype, "_FLT_0.33G", sep = ""), get(paste(celltype, "_FLT_0.33G", sep = ""))[signif,])
assign(paste(celltype, "_FLT_0.67G", sep = ""), get(paste(celltype, "_FLT_0.67G", sep = ""))[signif,])
assign(paste(celltype, "_FLT_1G", sep = ""), get(paste(celltype, "_FLT_1G", sep = ""))[signif,])
assign(paste(celltype, "_HGC", sep = ""), get(paste(celltype, "_HGC", sep = ""))[signif,])


x=cbind(get(paste(celltype, "_FLT_0G", sep = "")), get(paste(celltype, "_FLT_0.33G", sep = "")), get(paste(celltype, "_FLT_0.67G", sep = "")), get(paste(celltype, "_FLT_1G", sep = "")), get(paste(celltype, "_HGC", sep = "")))

y=t(x)

### Plot PCA of individual replicates
png(paste("RTN_ind_q_PCA", ".png", sep=""), height = 2000, width = 2000, res = 300)
pdf(file=paste("PCA_rep_ON.pdf"))
P=PCA(y, graph = F, scale.unit = T)

p=plot(P,choix="ind",habillage ="none", col.ind=rep("white",20), graph.type="classic",label="none")
points(P$ind$coord[,1],P$ind$coord[,2],col=c(rep("black", 5), rep("green", 6), rep("orange", 6), rep("red", 6), rep("black", 12)), pch=c(rep(1,5), rep(16,30)), cex=2)
legend("top", ncol=2, pch=c(rep(16,3),1,16), legend= c("0.33G", "0.67G", "1G", "0G", "HGC"), col= c("green", "orange", "red", rep("black",2)), bty="o", pt.cex=2)
dev.off()


assign(paste(celltype, "_FLT_0G", sep = ""), rowMeans(get(paste(celltype, "_FLT_0G", sep = ""))))
assign(paste(celltype, "_FLT_0.33G", sep = ""), rowMeans(get(paste(celltype, "_FLT_0.33G", sep = ""))))
assign(paste(celltype, "_FLT_0.67G", sep = ""), rowMeans(get(paste(celltype, "_FLT_0.67G", sep = ""))))
assign(paste(celltype, "_FLT_1G", sep = ""), rowMeans(get(paste(celltype, "_FLT_1G", sep = ""))))
assign(paste(celltype, "_HGC", sep = ""), rowMeans(get(paste(celltype, "_HGC", sep = ""))))


x=cbind(get(paste(celltype, "_FLT_0G", sep = "")), get(paste(celltype, "_FLT_0.33G", sep = "")), get(paste(celltype, "_FLT_0.67G", sep = "")), get(paste(celltype, "_FLT_1G", sep = "")), get(paste(celltype, "_HGC", sep = "")))

colnames(x)=c(paste(celltype, "_FLT_0G", sep = ""), paste(celltype, "_FLT_0.33G", sep = ""), paste(celltype, "_FLT_0.67G", sep = ""), paste(celltype, "_FLT_1G", sep = ""), paste(celltype, "_HGC", sep = ""))


y=t(x)


## Plot pca of average over replicates of the same treatment type
png(paste("RTN_Avg_q_PCA.png", sep=""), height = 2000, width = 2000, res = 300)
pdf(file=paste("PCA_avg_ON.pdf"))
P=PCA(y, graph = F, scale.unit = T)
p=plot(P,choix="ind",habillage ="none", col.ind=rep("white",20), graph.type="classic",label="none")
points(P$ind$coord[,1],P$ind$coord[,2],col=c("black", "green", "orange", "red", "black"), pch=c(1, rep(16,4)), cex=2)
legend("top", ncol=2, pch=c(rep(16,3),1,16), legend= c("0.33G", "0.67G", "1G", "0G", "HGC"), col=c("green", "orange", "red", rep("black",2)), bty="o", pt.cex=2)
dev.off()
