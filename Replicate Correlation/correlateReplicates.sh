echo start
### Create input files that contain only the columns of the same treatment type 
for file in $(ls /home/rpergerson/FlightMice/NormalizedData/DESeq2_*_Normalized_Counts_newNames.txt); do
    celltype=$(echo $(basename $file) | cut -f2 -d"_")
    awk -v FS="\t" -v OFS="\t" '{print $2, $6, $10, $14, $18, $22}' $file | awk -v OFS="\t" '{gsub(" ", "\t"); print}' > ${celltype}_0.33G.txt
    awk -v FS="\t" -v OFS="\t" '{print $3, $7, $11, $15, $19, $23}' $file | awk -v OFS="\t" '{gsub(" ", "\t"); print}' > ${celltype}_0.67G.txt
    awk -v FS="\t" -v OFS="\t" '{print $4, $8, $12, $16, $20, $24}' $file | awk -v OFS="\t" '{gsub(" ", "\t"); print}' > ${celltype}_1G.txt
    awk -v FS="\t" -v OFS="\t" '{print $5, $9, $13, $17, $21}' $file | awk -v OFS="\t" '{gsub(" ", "\t"); print}' > ${celltype}_0G.txt
    cut -f25-37 $file | awk -v OFS="\t" '{gsub(" ", "\t"); print}' > ${celltype}_HGC.txt

    ### Check to make sure you have the right columns in each file    
    head -n1 ${celltype}_0.33G.txt
    head -n1 ${celltype}_0.67G.txt
    head -n1 ${celltype}_1G.txt
    head -n1 ${celltype}_0G.txt
    head -n1 ${celltype}_HGC.txt
done
wait

### Run the Rscript and create the correlation plots
for sample in ON RTN; do
        Rscript correlateReplicates.R ${sample}_0.33G.txt $sample 0.33G
        Rscript correlateReplicates.R ${sample}_0.67G.txt $sample 0.67G
        Rscript correlateReplicates.R ${sample}_1G.txt $sample 1G
        Rscript correlateReplicates.R ${sample}_0G.txt $sample 0G
        Rscript correlateReplicates.R ${sample}_HGC.txt $sample HGC
done
echo done
