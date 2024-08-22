echo start
### Convert naming csv file to text and remove extra empty lines
for file in $(ls *MHU8*.csv); do
   awk '{gsub(",", "\t"); print}' $file | awk '{ gsub(/[()]/, ""); print}' | grep -vP '^\s*$' > $(basename $file .csv).txt
done

echo wait
wait

### Remove parenthesis and make sure naming file is tab delimited
for file in $(ls *MHU8*Copy.txt); do
   awk -v FS="\t" -v OFS="\t" '{if (NF > 1) print}' $file | awk -v FS="\t" -v OFS="\t" '{gsub(/[()]/, ""); print}' > $(basename $file .txt).temp3.txt
done

echo wait
wait

### Get new names and flight gravity levels associated with with MMU IDs 
for file in $(ls *MHU8*Copy.txt | grep -v rRNArmvd); do
   awk -v FS="\t" -v OFS="\t" '{if ($3 ~ "FLT") print $3, $2"_"$5; else print $3, $2}' $file | awk -v FS="\t" -v OFS="\t" '{gsub(/[()]/, ""); print}' > $(basename $file .Copy.txt).newName2.txt
   awk -v FS="\t" -v OFS="\t" '{if ($3 ~ "FLT") print $3, $4"_"$5"_"$2; else print $3, $2}' $file | awk -v FS="\t" -v OFS="\t" '{gsub(/[()]/, ""); print}' > $(basename $file .Copy.txt).newName3.txt
done


### Condense down the new names to eliminate the words we don't want in the new names
for file in $(ls MHU8_*_Mao_Tissues_Sample_Info_Copy.newName2.txt); do  ### This file for loop was used to create 
    awk -v FS="\t" -v OFS="\t" '{gsub("Flight ", ""); gsub("+ ", ""); gsub("artifical ", ""); gsub("gravity ", ""); gsub(" FLT_0.33G", ""); gsub(" FLT_0.67G", ""); gsub(" FLT_0G", ""); gsub(" FLT_1G", ""); print}' $file > $(basename $file .txt.newName3.txt).newName.txt
done

### We adjusted the column naming structure using similar code as above, but resulting in a different arrangement
for file in $(ls *MHU8*newName3*.txt); do
    awk -v FS="\t" -v OFS="\t" '{gsub("Flight ", ""); gsub("+ ", ""); gsub("artifical ", ""); gsub("gravity ", ""); gsub(" FLT_0.33G_FLT", "_FLT"); gsub(" FLT_0.67G_FLT", "_FLT"); gsub(" FLT_0G_FLT", "_FLT"); gsub(" FLT_1G_FLT", "_FLT"); print}' $file > $(basename $file .txt.newName3.txt).newName1.txt
done
echo done