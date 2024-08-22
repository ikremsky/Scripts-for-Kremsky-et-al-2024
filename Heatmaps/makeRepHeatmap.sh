echo start
## Note: specific cell types are grepped into this for loop since the color break parameters for ON and RTN are different, you will need to edit to the celltype you are grepping for accordingly
# cd /home/rpergerson/FlightMice/DifferentialExpression

for file in $(ls /home/rpergerson/FlightMice/DifferentialExpression/*_GS_0GvsHGC_SigNormwLog_tab.txt | grep RTN); do
	name=$(echo $(basename $file) | cut -f1 -d"_")
	Log2fc=$(ls /home/rpergerson/FlightMice/DifferentialExpression/*_0GvsHGC_SigLogTable_tab2.txt | grep $name)
	Rscript /home/rpergerson/FlightMice/Scripts/makeRepHeatmap.R $file $name $Log2fc
done
echo done
