#Stephen Justinen
echo start

cd ..

#Get spaceflight ON DEGs
awk -vFPAT='([^,]*)|("[^"]+")' -vOFS=,  'function abs(x){return ((x < 0.0) ? -x : x)}{{if($78<0.05 && abs($75)>1){print $1}}}' \
../DGE_ON_differential_expression.csv | awk '{gsub(/"/,""); print}' | sort -b > Names_list_ON.txt

#Get spaceflight RTN DEGs
awk -vFPAT='([^,]*)|("[^"]+")' -vOFS=,  'function abs(x){return ((x < 0.0) ? -x : x)}{{if($78<0.05 && abs($75)>1){print $1}}}' \
../DGE_RTN_differential_expression.csv | awk '{gsub(/"/,""); print}' | sort -b > Names_list_RTN.txt




###Get ON Crush and Glaucoma DEGs

for file in $(ls Spreadsheet-*.txt)
do
        OutFileName=$(basename $(echo $file | sed -e 's/\<Spreadsheet-S1-//g' | sed -e 's/\<Spreadsheet-S2-//g') .txt)
        Rscript Scripts_2/DEListFilePrep.R $file $OutFileName
done

rm Scripts_2/DEGene_list_RTN.txt
rm Scripts_2/DEGene_list_ON.txt
echo " " > Scripts_2/DEGene_list_RTN.txt
echo " " > Scripts_2/DEGene_list_ON.txt

for file in $(ls UON_*.txt) $(ls MON_*.txt)
do
        name=$(basename $file .txt)
        awk -v FS="\t" -v OFS="\t" -v name="$name" 'function abs(x){return ((x < 0.0) ? -x : x)}{{if($3<0.05 && abs($4)>1){print $1, $2, name}}}' $file \
        | awk '{ sub(/\t/, "_"); print }' | sort -b > Scripts_2/Gene_list_Temp
        join -a 1 -a 2 -j 1 Scripts_2/DEGene_list_ON.txt Scripts_2/Gene_list_Temp > Scripts_2/tempList.txt
        sort -b Scripts_2/tempList.txt | uniq | sort -b > Scripts_2/DEGene_list_ON.txt
done

for file in $(ls Retina_*.txt)
do
	name=$(basename $file .txt)
	awk -v FS="\t" -v OFS="\t" -v name="$name" 'function abs(x){return ((x < 0.0) ? -x : x)}{{if($3<0.05 && abs($4)>1){print $1, $2, name}}}' $file \
	| awk '{ sub(/\t/, "_"); print }' | sort -b > Scripts_2/Gene_list_Temp
	join -a 1 -a 2 -j 1 Scripts_2/DEGene_list_RTN.txt Scripts_2/Gene_list_Temp > Scripts_2/tempList.txt
	sort -b Scripts_2/tempList.txt | uniq | sort -b > Scripts_2/DEGene_list_RTN.txt
done
cd Scripts_2

wc -l DEGene_list_RTN.txt
wc -l DEGene_list_ON.txt

awk '{ gsub(/ /, ","); print }' DEGene_list_RTN.txt | awk '{ sub(/_/, "\t"); print }' | awk '{ sub(/,/, "\t"); print }' | awk '{ gsub(/Glocoma/, "Glaucoma"); print }' > tempRTN.txt
awk '{ gsub(/ /, ","); print }' DEGene_list_ON.txt | awk '{ sub(/_/, "\t"); print }' | awk '{ sub(/,/, "\t"); print }' | awk '{ gsub(/Glocoma/, "Glaucoma"); print }' > tempON.txt


###Get DEGs both in spaceflight and ON Crush/Glaucoma
sort -b tempON.txt | join - Names_list_ON.txt | awk -v FS="\t" -v OFS="\t" 'BEGIN{print "ENSEMBL", "Symbol", "Dataset"}{print}'  > DEGene_list_overlaps_ON.txt
sort -b tempRTN.txt | join - Names_list_RTN.txt | awk -v FS="\t" -v OFS="\t" 'BEGIN{print "ENSEMBL", "Symbol", "Dataset"}{print}' > DEGene_list_overlaps_RTN.txt

wc -l DEGene_list_overlaps_RTN.txt
wc -l DEGene_list_overlaps_ON.txt
echo done
