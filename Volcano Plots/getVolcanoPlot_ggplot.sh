echo start
### Different text parameters are used for ON vs RTN so each one needs to be grepped seperately in this script
### The input data for this script is all of the DEG's and their associated Log2fc and adjusted p values

for file in $(ls /home/rpergerson/FlightMice/*0G_All.txt | grep RTN);
do
	type=$(echo $(basename $file) | cut -f1 -d"_")
	echo $type
	sample=$(echo $(basename $file) | awk '{gsub("_All.txt", ""); gsub("ON_", ""); gsub("RTN_", ""); print}')
	echo $sample
	Rscript /home/rpergerson/FlightMice/Scripts/getVolcanoPlot_ggplot.R /home/rpergerson/FlightMice/${type}_${sample}_All.txt $type $sample #/home/rpergerson/FlightMice/${type}_${sample}_All_top10.txt
done
echo done
