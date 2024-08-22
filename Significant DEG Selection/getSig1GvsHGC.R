# Load in data
args=commandArgs(trailingOnly=TRUE)
data=read.table(args[1], header=TRUE, sep=",")

# Select rows in 1G with Adj.P < 0.05 and Log2fc > 1
G0_cols=c(1, 2, grep("FLT_1G.v.HGC.", colnames(data)))
G0_data=data[, G0_cols]

names=colnames(G0_data)

selected_cols=c(1, 2, grep("Log2fc", names), grep("Adj", names))
selected_data=G0_data[, selected_cols]

sigrows=which(abs(selected_data[,3]) > 1 & selected_data[,4] < 0.05)
M=selected_data[sigrows, ]


# Write output file
output_file=paste(args[2], "_1GvHGC_SigDEdata.txt", sep="")
output_file=paste(args[2], "_1G_SigLogandQ.txt", sep="")
write.table(M, file=output_file, quote=FALSE, sep="\t", row.names=FALSE, col.names=TRUE)

output_file=paste(args[2], "_1G_All.txt", sep="")
write.table(selected_data, file=output_file, quote=FALSE, sep="\t", row.names=FALSE, col.names=TRUE)

# Write associated Log2fc table
legend_log2fc_cols=c(1, 2, grep("Log2fc", colnames(M)))
N=M[, legend_log2fc_cols]

output_file=paste(args[2], "_1GvsHGC_SigLogTable.txt", sep="")
write.table(N, file=output_file, quote=FALSE, sep="\t", row.names=FALSE, col.names=TRUE)
