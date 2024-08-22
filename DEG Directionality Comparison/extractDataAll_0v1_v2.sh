#Stephen Justinen
echo start

rm DEGs_ON.txt
rm DEGs_ON.2.txt
rm DEGs_RTN.txt
rm DEGs_RTN.2.txt
rm DoubleCheck.txt
rm DoubleCheckList.txt

awk -vFPAT='([^,]*)|("[^"]+")' -vOFS=,  'function abs(x){return ((x < 0.0) ? -x : x)}{{if($74<0.05 && abs($71)>1 && !seen[NR] && $71!="NA"){print NR, $71; seen[NR] = 1}}}' DGE_ON_differential_expression.csv > DEGs_ON_0Gv1G.txt
awk -vFPAT='([^,]*)|("[^"]+")' -vOFS=,  'function abs(x){return ((x < 0.0) ? -x : x)}{{if($78<0.05 && abs($75)>1 && !seen[NR] && $71!="NA"){print NR, $75; seen[NR] = 1}}}' DGE_ON_differential_expression.csv > DEGs_ON_0GvHGC.txt
wc -l DEGs_ON_0Gv1G.txt
wc -l DEGs_ON_0GvHGC.txt

awk -vFPAT='([^,]*)|("[^"]+")' -vOFS=,  'function abs(x){return ((x < 0.0) ? -x : x)}{{if($74<0.05 && abs($71)>1 && !seen[NR] && $71!="NA"){print NR, $71; seen[NR] = 1}}}' DGE_RTN_differential_expression.csv > DEGs_RTN_0Gv1G.txt
awk -vFPAT='([^,]*)|("[^"]+")' -vOFS=,  'function abs(x){return ((x < 0.0) ? -x : x)}{{if($78<0.05 && abs($75)>1 && !seen[NR] && $75!="NA"){print NR, $75; seen[NR] = 1}}}' DGE_RTN_differential_expression.csv > DEGs_RTN_0GvHGC.txt
wc -l DEGs_RTN_0Gv1G.txt
wc -l DEGs_RTN_0GvHGC.txt

awk -v FS="," '{print $1}' DEGs_ON_0Gv1G.txt > temp1.ON.txt

awk -v FS="," '{print $1}' DEGs_RTN_0Gv1G.txt > temp1.RTN.txt

#Cross comparisons

for file in $(cat temp1.ON.txt)
do
	awk -v FS="," -v x="$file"  '{if($1==x){print $1}}' DEGs_ON_0GvHGC.txt >> DEGs_ON.txt
done


for file in $(cat temp1.RTN.txt)
do
        awk -v FS="," -v x="$file"  '{if($1==x){print $1}}' DEGs_RTN_0GvHGC.txt >> DEGs_RTN.txt
done

#Row extracton

for file in $(awk '{print $1}' DEGs_ON.txt)
do
        awk -v x="$file"  '{if(NR==x){print}}' DGE_ON_differential_expression.csv >> DEGs_ON.2.txt
done


for file in $(awk '{print $1}' DEGs_RTN.txt)
do
        awk -v x="$file"  '{if(NR==x){print}}' DGE_RTN_differential_expression.csv >> DEGs_RTN.2.txt
done





head -n 1 DGE_ON_differential_expression.csv > DEGs_ON_sigBoth.txt
cat DEGs_ON.2.txt >> DEGs_ON_sigBoth.txt

head -n 1 DGE_RTN_differential_expression.csv > DEGs_RTN_sigBoth.txt
cat DEGs_RTN.2.txt >> DEGs_RTN_sigBoth.txt

#Check to determine if previous statements correctly selected for only significant sequences
#for file in $(cat temp1.ON.txt)
#do
#        awk -v x="$file"  '{if($1==x){print $1}}' DEGs_ON_0GvHGC.txt >> DoubleCheckList.txt
#done
#
#for file in $(cat DoubleCheckList.txt)
#do
#        awk -v FS="," -v x="$file"  '{if(NR==x){print NR, $1, $2, $71, $75, $74, $78}}' DGE_ON_differential_expression.csv >> DoubleCheck.txt
#done


Rscript extractDataON_0v1.R
Rscript extractDataRTN_0v1.R

echo done
