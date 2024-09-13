#Stephen Justinen
library(VennDiagram)

args=as.numeric(commandArgs(trailingOnly=T))

ONH <- (args[1])
ONH
RTN <- (args[2])
RTN
#NONOVERLAP <- (args[3])
#NONOVERLAP
OVERLAP <- (args[3])
OVERLAP

ONH_U = ONH-OVERLAP
ONH_U
RTN_U = RTN-OVERLAP
RTN_U

#png( "VENN_DIA_Overlap_ONH_RTN.png", height = 2000, width = 2000, res=300)
pdf( "VENN_DIA_Overlap_ONH_RTN.pdf", height = 5, width = 5)
#venn.plot <- draw.pairwise.venn(ONH, RTN, OVERLAP);
venn.plot <- draw.pairwise.venn(ONH, RTN, OVERLAP, category = rep("", 2), col = rep("black", 2))
grid.draw(venn.plot);
grid.newpage();
dev.off()
