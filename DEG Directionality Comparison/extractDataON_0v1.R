#Stephen Justinen

.libPaths(c("/home/sjustinen/R/x86_64-pc-linux-gnu-library/4.0/", .libPaths()))

data <- read.csv("DEGs_ON_sigBoth.txt")

result <- data$Log2fc_.FLT_0G.v.FLT_1G * data$Log2fc_.FLT_0G.v.HGC.

length(result)
same <- sum(result > 0)
opposite <- sum(result < 0)


#length(result2)
#same2 <- sum(result2 > 0)
#opposite2 <- sum(result2 < 0)

plotPvals2 = function(p, maxH, asteriskDist, x1, x2)
{
        magnify=2
        if(p < .01 & p >= .001)
        {
                text(mean(c(x1,x2)), maxH+asteriskDist, labels="*", cex=magnify)
                arrows(x1,maxH,x2,maxH,code=3,lwd=magnify,angle=90,length=0.05,col="purple")
        }
        if(p < .001 & p >= .00001)
        {
                text(mean(c(x1,x2)), maxH+asteriskDist, labels="**", cex=magnify)
                arrows(x1,maxH,x2,maxH,code=3,lwd=magnify,angle=90,length=0.05,col="purple")
        }
        if(p < .00001 & p >= .0000000001)
        {
                text(mean(c(x1,x2)), maxH+asteriskDist, labels="***", cex=magnify)
                arrows(x1,maxH,x2,maxH,code=3,lwd=magnify,angle=90,length=0.05,col="purple")
        }
        if(p < .0000000001)
        {
                text(mean(c(x1,x2)), maxH+asteriskDist, labels="****", cex=magnify)
                arrows(x1,maxH,x2,maxH,code=3,lwd=magnify,angle=90,length=0.05,col="purple")
        }
}

maxH <- max(same, opposite)+1
head(maxH)


P <- binom.test(same, same + opposite)
print(P)

#png( "barplot_Mice_ON.png", height = 2000, width = 2000, res=300)
pdf( "barplot_Mice_ON.pdf", height = 10, width = 10)
mp=barplot(c(same, opposite), names.arg=c("same Dir", "opposite Dir"), cex.main=2, cex.axis=1.4, cex.lab=2, cex.names=1.7, main="ON Directional Change Totals", ylab="", ylim=c(0,maxH+maxH/10))
plotPvals2(P$p.value,maxH+maxH/20, maxH/30,mp[1],mp[2])
title(ylab="Total DEGs", line=2.5, cex.lab=1.8)
dev.off()

#Data Points for this project: Bar graph of genes upregulated in the same direction in both 0G and HGC vs 1G in one column, and in the other total of genes regulated in opposite directions. 




print(same)
print(opposite)
