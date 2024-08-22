echo start
### Change each celltype and pathway depending on what heatmap you want to make (Note each pathway heatmap has different coloring and break parameters so you have to run them one at a time)
for celltype in RTN; do
    for pathway in PPAR; do
        name=${pathway}
        sample=${celltype}
        echo $name
        echo $sample
        Rscript /home/rpergerson/FlightMice/Scripts/createPathwayHeatmap.R /home/rpergerson/FlightMice/${pathway}_Pathway_Genes_KEGG_2019_Mm_${celltype}_wLog2fc_${celltype}_tab.txt $name $sample
    done
done
echo done