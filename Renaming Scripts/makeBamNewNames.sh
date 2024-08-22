echo start
for file in $(ls Naming/*MHU8*Copy.txt | grep -v rRNArmvd); do
    name=$(echo $file | awk '{gsub("MHU8_", ""); gsub("_Mao_Tissues_Sample_Info_Copy.txt", ""); print}')
    awk -v FS="\t" -v OFS="\t" '{if ($3 ~ "FLT") print $3, $5; else print $3, $2}' $file > ${name}_tempNames.txt
    awk -v FS="\t" -v OFS="\t" '{gsub("Flight ", ""); gsub("+ ", ""); gsub("artifical ", ""); gsub("gravity ", ""); print}' ${name}_tempNames.txt > ${name}_tempNames1.txt
    awk -v FS="\t" -v OFS="\t" '{gsub(" \\([^)]+\\)", ""); print}' ${name}_tempNames1.txt > ${name}_tempNames2.txt
    mv ${name}_tempNames2.txt $(basename $file .newName.txt).BamNames.txt
done
echo done