echo start
### Step 1 for every column create a file that has the new name that corresponds with the old name
for celltype in ON RTN; do
   head -n1 /home/rpergerson/FlightMice/NormalizedData/DESeq2_${celltype}_Normalized_Counts.txt > ${celltype}_temp.txt
   for sample in $(awk '{print $1}' /home/rpergerson/FlightMice/Naming/MHU8_${celltype}_Mao_Tissues_Sample_Info_Copy.newName.txt); do
      new=$(grep $sample /home/rpergerson/FlightMice/Naming/MHU8_${celltype}_Mao_Tissues_Sample_Info_Copy.newName.txt | awk '{print $2}' | awk '{gsub("_FLT_", "_"); print}')
      # echo $sample $new
      awk -v OFS="\t" -v sample=$sample -v new=$new '{gsub(sample, new); print}' ${celltype}_temp.txt > ${celltype}_newname.txt
      mv ${celltype}_newname.txt ${celltype}_temp.txt
   done
   mv ${celltype}_temp.txt ${celltype}_names.txt
done


### Step 2 append the normalized data to the new column names
for celltype in ON RTN; do
   awk -v FS="\t" -v OFS="\t" 'FNR == 1 {print "ID"$0; exit}' /home/rpergerson/FlightMice/Naming/${celltype}_names.txt >> temp1
   awk -v FS="\t" -v OFS="\t" 'NR > 1 {print $0}' /home/rpergerson/FlightMice/NormalizedData/DESeq2_${celltype}_Normalized_Counts.txt >> temp1
	  mv temp1 /home/rpergerson/FlightMice/NormalizedData/DESeq2_${celltype}_Normalized_Counts_newNames.txt
done


### We ended up wanting a similar but slightly different naming structure so that is what this part of the script is for
### The files used at the end of this for loop were the majority of the files used in downstream image creation

### Step 1 for every column create a file that has the new name that corresponds with the old name
for celltype in ON RTN; do
   head -n1 /home/rpergerson/FlightMice/NormalizedData/DESeq2_${celltype}_Normalized_Counts.txt > ${celltype}_temp.txt
   for sample in $(awk '{print $1}' /home/rpergerson/FlightMice/Naming/MHU8_${celltype}_Mao_Tissues_Sample_Info_Copy.newName1.txt); do
      new=$(grep $sample MHU8_${celltype}_Mao_Tissues_Sample_Info_Copy.newName1.txt | awk '{print $2}')
      # echo $sample $new
      awk -v OFS="\t" -v sample=$sample -v new=$new '{gsub(sample, new); print}' ${celltype}_temp.txt > ${celltype}_newname1.txt
      mv ${celltype}_newname1.txt ${celltype}_temp.txt
   done
   mv ${celltype}_temp.txt ${celltype}_names1.txt
done


### Step 2 append the normalized data to the new column names
for celltype in ON RTN; do
   awk -v FS="\t" -v OFS="\t" 'FNR == 1 {print "ID"$0; exit}' /home/rpergerson/FlightMice/Naming/${celltype}_names1.txt >> temp1
	awk -v FS="\t" -v OFS="\t" 'NR > 1 {print $0}' /home/rpergerson/FlightMice/NormalizedData/DESeq2_${celltype}_Normalized_Counts.txt >> temp1
	mv temp1 /home/rpergerson/FlightMice/NormalizedData/DESeq2_${celltype}_Normalized_Counts_newNames1.txt
done

### These commands were to change the column names from "FLT_${sample}_${FLT#}" to ${celltype}_FLT_${sample}_${FLT#}
### These relabeled DESeq2 normalized expression tables were used for several subsequent analyses
awk -v FS="\t" -v OFS="\t" '{gsub("FLT_0", "ON_FLT_0"); gsub("FLT_1", "ON_FLT_1"); gsub("HGC", "ON_HGC"); print}' /home/rpergerson/FlightMice/NormalizedData/DESeq2_ON_Normalized_Counts_newNames1.txt > /home/rpergerson/FlightMice/NormalizedData/DESeq_ON_Normalized_Counts_newNames1.txt
awk -v FS="\t" -v OFS="\t" '{gsub("FLT_0", "RTN_FLT_0"); gsub("FLT_1", "RTN_FLT_1"); gsub("HGC", "RTN_HGC"); print}' /home/rpergerson/FlightMice/NormalizedData/DESeq2_RTN_Normalized_Counts_newNames1.txt > /home/rpergerson/FlightMice/NormalizedData/DESeq_RTN_Normalized_Counts_newNames1.txt

wc -l /home/rpergerson/FlightMice/NormalizedData/DESeq_ON_Normalized_Counts_newNames1.txt
wc -l /home/rpergerson/FlightMice/NormalizedData/DESeq_RTN_Normalized_Counts_newNames1.txt
echo done