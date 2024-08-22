.libPaths(c("/home/samir/R/x86_64-pc-linux-gnu-library/4.0/", .libPaths()))
.libPaths(c("/tmp/RtmpRGV9xP/downloaded_packages", .libPaths()))
.libPaths(c("/tmp/RtmpDSw7xT/downloaded_packages", .libPaths()))
.libPaths(c("/tmp/RtmpgVohQM/downloaded_packages", .libPaths()))
args=commandArgs(trailingOnly = TRUE)

# #############################################################
# ### The first half of this script is to obtain and plot the Enrichr analysis of the significant ON and RTN DEGs

# library(enrichR)
# library(magrittr)

# ### Set Enrichr site
# websiteLive <- getOption("enrichR.live")
# if (websiteLive) {
#     setEnrichrSite("Enrichr") # General Enrichr   
# }

# ### Get Enrichr libraries
# if (websiteLive) dbs <- listEnrichrDbs()$libraryName

# ### Filter to only libraries starting with "KEGG"
# if (websiteLive) dbs <- dbs[grep("^KEGG_2019_Mouse", dbs)]

# ### Parse in data
# data=read.delim(args[1], header=T, sep="\t")
# merged_df=data[complete.cases(data$SYMBOL), ]


# de_genes <- merged_df$SYMBOL %>%
#   na.omit() %>%
#   as.character() %>%
#   unique()


# ### Run Enrichr analysis
# if (websiteLive) {
#   enrichr_results <- enrichr(de_genes, dbs[grep("KEGG_2019_Mouse", dbs)])
# }


# ### Get the KEGG_2021 results and sort them
# sorted_results <- enrichr_results[[1]][order(enrichr_results[[1]]$P.value), ]

# kegg_2021_human_plot <- if (websiteLive) { plotEnrich(enrichr_results[[1]], showTerms = 20, numChar = 40, y = "Count", orderBy = "P.value", title = "Enrichr KEGG_2019_Mouse") }

# name=as.character(args[2])


# ### Plot enrichr results
# png(filename = paste(name, "_0GvsHGC_Enricher.png", sep=""), width = 2500, height = 2500, units = "px", pointsize = 12, bg = "white", res = 300)
# pdf(file=paste("enrichr_", name, "_0GvsHGC.pdf", sep=""))
# kegg_2021_human_plot
# invisible(dev.off())



##############################################################
### This second half of the script is to get the gene symbols for specified pathways from KEGG (I choose what pathways I want to analyze based off of the Enrichr output)
library(KEGGREST)
library(org.Mm.eg.db)
library(tidyverse)
library(limma)

### Get pathways and their entrez gene ids
mmu_path_entrez  <- keggLink("pathway", "mmu") %>% 
  tibble(pathway = ., eg = sub("mmu:", "", names(.)))

### Get gene symbols and ensembl ids using entrez gene ids
mmu_kegg_anno <- mmu_path_entrez %>%
  mutate(
    pathway = sub("path:", "", pathway),  # Remove the "path:" prefix
    symbol = mapIds(org.Mm.eg.db, eg, "SYMBOL", "ENTREZID"),
    ensembl = mapIds(org.Mm.eg.db, eg, "ENSEMBL", "ENTREZID")
  )

### Pathway names
mmu_pathways <- getKEGGPathwayNames("mmu")

# keywords=c("PPAR", "PI3K", "ECM", "p53")
keywords=c("FoxO")

filtered_pathways <- list()

### Loop over each pathway and check if any of the keywords are present in the description
for (i in seq_len(nrow(mmu_pathways))) {
  if (any(grepl(paste(keywords, collapse = "|"), mmu_pathways$Description[i]))) {
    filtered_pathways[[length(filtered_pathways) + 1]] <- mmu_pathways[i, ]
  }
}

### Combine the filtered pathways into a single data frame
filtered_pathways_df <- do.call(rbind, filtered_pathways)

### Extract the values from the first column of filtered_pathways_df
pathway_ids <- filtered_pathways_df$PathwayID

### Initialize an empty list to store the results
matched_genes <- list()

### Loop over each pathway ID to match genes and write out the file for each one
for (pathway_id in pathway_ids) {
  # Filter rows from mmu_kegg_anno where the first column matches the pathway ID
  matched_genes <- mmu_kegg_anno[mmu_kegg_anno$pathway == pathway_id, ]

  # Write matched genes for the current pathway to a separate file
  pathway_name <- mmu_pathways$Description[mmu_pathways$PathwayID == pathway_id]
  parts <- strsplit(pathway_name, " ")[[1]]
  pathway_name <- parts[1]
  filename <- paste0(pathway_name, "_Pathway_Genes_KEGG_2019_Mm2.txt")
  write.table(matched_genes, file = filename, quote = FALSE, sep = "\t", row.names = FALSE)
}
