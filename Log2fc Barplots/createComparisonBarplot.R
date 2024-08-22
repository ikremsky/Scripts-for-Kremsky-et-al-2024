args=commandArgs(trailingOnly = T)

a=read.delim(args[1], header=T, sep=" ")  #0G data
b=read.delim(args[2], header=T, sep=" ")  #0.33G data
c=read.delim(args[3], header=T, sep=" ")  #0.67G data
d=read.delim(args[4], header=T, sep=" ")  #1G data

length(a[,1])
length(b[,1])
length(c[,1])
length(d[,1])

A=a[,2]
B=b[,2]
C=c[,2]
D=d[,2]


### Splitting positive and negative values for each variable
A_pos=length(which(A > 0))
A_neg=-1 * length(which(A < 0))

B_pos=length(which(B > 0))
B_neg=-1 * length(which(B < 0))

C_pos=length(which(C > 0))
C_neg=-1 * length(which(C < 0))

D_pos=length(which(D > 0))
D_neg=-1 * length(which(D < 0))


### Create Barplot with positive and negative Log2fc Values
png(filename=paste("Barplot_", args[5], "_Log2fc", "_3", ".png", sep=""), width=2000, height=2000, res=300)
barplot(c(A_pos, A_neg, B_pos, B_neg, C_pos, C_neg, D_pos, D_neg), space=c(rep(c(1,0),4)), names=c("0G", " ", "0.33G", " ", "0.67G", " ", "1G", " "), main=c(paste(args[5], "DGE's vs HGC", sep=" ")))

dev.off()