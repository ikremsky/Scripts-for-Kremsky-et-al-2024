echo "start getSigQandLog2fc.sh"
for file in $(ls /home/rpergerson/FlightMice/DifferentialExpression/*differential*csv | grep -v rRNArmvd); do
	name=$(echo $file | awk '{gsub("DGE_", ""); gsub("_differential_expression.csv", ""); print}')
	Rscript /home/rpergerson/FlightMice/Scripts/getSig0GvsHGC.R $file $name
	wait
	echo "done ${name}_0GvsHGC"
	Rscript /home/rpergerson/FlightMice/Scripts/getSig0.33GvsHGC.R $file $name
	wait
	echo "done ${name}_0.33GvsHGC"
	Rscript /home/rpergerson/FlightMice/Scripts/getSig0.67GvsHGC.R $file $name
	wait
	echo "done ${name}_0.67GvsHGC"
	Rscript /home/rpergerson/FlightMice/Scripts/getSig1GvsHGC.R $file $name
	wait
	echo "done ${name}_1GvsHGC"
	mv $(basename $file .csv).csv.SigAdj2.tx2t $(basename $file .csv).SigQandLog2fc.txt
done
echo "completed getSigQandLog2fc.sh"