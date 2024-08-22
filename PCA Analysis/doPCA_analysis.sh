echo doPCA_analysis.sh
# x=""
for celltype in ON RTN;
do
	x=$(echo $x" "${celltype}_FLT_0G ${celltype}_FLT_0.33G ${celltype}_FLT_0.67G ${celltype}_FLT_1G ${celltype}_HGC)
	Rscript /home/rpergerson/FlightMice/PCA_analysis.R $celltype $x
done
wait
echo done
