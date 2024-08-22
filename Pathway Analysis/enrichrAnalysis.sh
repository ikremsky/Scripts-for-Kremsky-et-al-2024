echo start
### This script is to obtain the enricher pathways for ON and RTN data 0G vs HGC and to obtain the genes associated with significant pathways of interest
# for file in $(ls /home/rpergerson/FlightMice/DifferentialExpression/*_0GvHGC_SigDEdata.txt); do
# for file in $(ls /home/rpergerson/FlightMice/DifferentialExpression/ON_0GvHGC_SigDEdata.txt); do
    name=$(echo $(basename $file) | cut -f1 -d"_")
    echo $name
    Rscript /home/rpergerson/FlightMice/Scripts/enrichrAnalysis.R $file $name
done
echo done