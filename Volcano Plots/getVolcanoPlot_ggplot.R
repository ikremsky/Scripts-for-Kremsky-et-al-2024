.libPaths(c("/home/samir/R/x86_64-pc-linux-gnu-library/4.0/", .libPaths()))
library(ggrepel)
library(dplyr)
library(ggplot2)
args=commandArgs(trailingOnly=T)
i=1
tmp=read.delim(as.character(args[i]), sep="\t", header=T); i=i+1
type=as.character(args[i]); i=i+1
name=as.character(args[i]); i=i+1

nrow(tmp)
de <- tmp[complete.cases(tmp), ]

lFC=de[,2]
NegLogPadj=-log(de[,3],10)
B=cbind(de, NegLogPadj)
sort_all=B[order(abs(B[,2]), decreasing=T), ]

x1=which(abs(B[,2]) > 1 & B[,3] < 0.05)
M=B[x1,]

sorted_data = M[order(abs(M[,2]), decreasing=T), ]
knowngenes=sorted_data[!grepl("\\|", sorted_data$SYMBOL), ]
N=head(knowngenes, n=5)


png(paste(type, "_", name, "_ggplot_volcanoplot", ".png", sep=""), height = 2000, width = 2000, res=300)
pdf(file=paste("VolcanoPlot_", type, "_0GvsHGC.pdf", sep=""))


B$diffexpressed <- "NO"
signif=B$Adj.p.value_.FLT_0G.v.HGC. < .05 & abs(B$Log2fc_.FLT_0G.v.HGC.) > 1

B$diffexpressed[signif] <- "Significant"
B$diffexpressed[!signif] <- "NS"

length(which(signif))

top5degs <- print(N[,1])
top5=gsub('"', '', top5degs)

B$delabel <- ifelse(B$SYMBOL %in% top5, B$SYMBOL, NA)


### These are the ggplot parameters for ON (comment them out as needed depending on what celltype you grep for in the associated bash script)
nudgeY <- ifelse(B$NegLogPadj < 5, 1, 0.3)
nudgeX <- ifelse(B$Log2fc_.FLT_0G.v.HGC. < 0, -8, 10)
ggplot(data=B, aes(x=Log2fc_.FLT_0G.v.HGC., y=NegLogPadj, col=diffexpressed, label=delabel)) + geom_point(size = 3) + geom_text_repel(data=filter(B), aes(label = delabel), size = 5, nudge_y = nudgeY, nudge_x = nudgeX, max.overlaps = Inf, show.legend = F) + scale_color_manual(values=c("black", "red")) + labs(color = 'DiffExpressed', x = "Log2 Fold Change", y = "-Log10 padj-value") + ggtitle(paste(type, " ", name, "_vs_HGC", sep=" ")) + theme_classic() + coord_cartesian(ylim = c(0, 13), xlim = c(-20, 20), clip = "off")

### These are the ggplot praramaters for RTN (comment them out as needed depending on what celltype you grep for in the associated bash script)
nudgeY <- ifelse(B$NegLogPadj < 0, 1.5, 0.3)
nudgeX <- ifelse(B$Log2fc_.FLT_0G.v.HGC. < 0, -7, 7)
ggplot(data=B, aes(x=Log2fc_.FLT_0G.v.HGC., y=NegLogPadj, col=diffexpressed, label=delabel)) + geom_point(size = 3) + geom_text_repel(data=filter(B), aes(label = delabel), size = 5, nudge_y = 0.3, nudge_x = nudgeX, max.overlaps = Inf, show.legend = F) + scale_color_manual(values=c("black", "red")) + labs(color = 'DiffExpressed', x = "Log2 Fold Change", y = "-Log10 padj-value") + ggtitle(paste(type, " ", name, "_vs_HGC", sep=" ")) + theme_classic() + coord_cartesian(ylim = c(0, 11), xlim = c(-7, 10), clip = "off")
dev.off()
