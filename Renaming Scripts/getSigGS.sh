#### Note: This script was used for getting the normalized expression data for the significant genes of the ON and RTN data to be used in downstream analysis. 
#          It also is used to get the normalized expression data for the genes involved in select pathways obtained from enrichr to be used in downstream heatmap creation.
#          Each section that corresponds to the specific process is clearly labled and each for loop that creates input files for specific images is numbered.


echo "start getGS.sh"
cd /home/rpergerson/FlightMice/DifferentialExpression/

### For loop one
### This part of the script is to convert the orginial DESeq2 normalized expression csv file to text
for file in $(ls *Normalized*.csv); do
	awk '{gsub(",", "\t"); print}' $file | awk '{ gsub(/"/, ""); print}' > $(basename $file .csv).txt
done



############################# Get ensemble pathway Log2fc values 
### For loop two
for celltype in ON RTN; do
	for file in $(ls /home/rpergerson/FlightMice/*Pathway*.txt | grep -v wLog2fc); do
		# ${celltype} Significant Genes of Normalized Mice
		awk '{print $4, $3}' $file | sort -k1b,1 > $(basename $file .txt).sorted.txt
		awk '{print $1, $3}' ~/FlightMice/DifferentialExpression/${celltype}_all_data_ensemblandLog2fc.txt | sort -k1b,1  > ~/FlightMice/DifferentialExpression/${celltype}_all_data_ensemblandLog2fc.sorted.txt
		join $(basename $file .txt).sorted.txt ~/FlightMice/DifferentialExpression/${celltype}_all_data_ensemblandLog2fc.sorted.txt | awk -v OFS="\t" '{gsub(" ", "\t"); print}' > $(basename $file .txt)_${celltype}_joined.txt

		awk -v OFS="\t" 'FNR == 1 {print $1, $2, $3; exit}' ~/FlightMice/DifferentialExpression/${celltype}_all_data_ensemblandLog2fc.txt  > temp1
		cat $(basename $file .txt)_${celltype}_joined.txt >> temp1
		mv temp1 ~/FlightMice/$(basename $file .txt)_${celltype}_wLog2fc.txt
	done
done

echo wait
wait

### This for loop is to remove intermediate files that were created from the above for loop
for celltype in ON RTN; do
	for file in $(ls /home/rpergerson/FlightMice/*Pathway*.txt | grep -v wLog2fc); do
		rm $(basename $file .txt).sorted.txt
		rm ~/FlightMice/DifferentialExpression/${celltype}_all_data_ensemblandLog2fc.sorted.txt
		rm $(basename $file .txt)_${celltype}_joined.txt
	done
done




####################################### Get Normalized Data for significant DEGs for ON and RTN
### For loop three
### Get Sig normalized data for flight samples without including Log2fc column
for celltype in ON RTN; do
	for sample in 0G 0.33G 0.67G 1G; do
		# ${celltype} Significant Genes of Normalized Mice
		awk '{print $1, $2}' ${celltype}_${sample}vHGC_SigDEdata.txt | sort -k1b,1 > ${celltype}_${sample}vsHGC_SigDEdata.sorted.txt
		sort -k1b,1 ~/FlightMice/NormalizedData/DESeq2_${celltype}_Normalized_Counts_newNames.txt > /home/rpergerson/FlightMice/DifferentialExpression/DESeq2_${celltype}_Normalized_Counts_newNames.sorted.txt
		join ${celltype}_${sample}vsHGC_SigDEdata.sorted.txt DESeq2_${celltype}_Normalized_Counts_newNames.sorted.txt | awk -v OFS="\t" '{gsub(" ", "\t"); print}' > ${celltype}_${sample}vsHGC_joined.txt

		awk -v OFS="\t" 'FNR == 1 {print "ESMBL", $0; exit}' ~/FlightMice/NormalizedData/DESeq2_${celltype}_Normalized_Counts_newNames.txt >> temp1
		cat ${celltype}_${sample}vsHGC_joined.txt >> temp1
		mv temp1 ${celltype}_GS_${sample}vsHGC_NormData.txt
	done
done

echo wait
wait

### This for loop is to remove intermediate files that were created from the above for loop
for celltype in ON RTN; do
	for sample in 0G 0.33G 0.67G 1G; do
		rm ${celltype}_${sample}vsHGC_SigDEdata.sorted.txt
		rm DESeq2_${celltype}_Normalized_Counts_newNames.sorted.txt
		rm ${celltype}_${sample}vsHGC_joined.txt
	done
done



### For loop four
### Create same data as above for significant DEG's but with Log2fc column included
### Note: The ${celltype}_GS_${sample}_SigNormwLog2fc.txt files used in the createComparisonBarplot.sh script came from this for loop, however this for loop was later edited for a different data file names
for celltype in ON RTN; do
	for sample in 0G 0.33G 0.67G 1G; do
	# Get sig genes for replicates
		awk '{print $1}' ${celltype}_${sample}vHGC_SigDEdata.txt | sort -k1b,1 > ${celltype}_${sample}vsHGC_SigDEdata.sorted.txt
		sort -k1b,1 ~/FlightMice/NormalizedData/DESeq2_${celltype}_Normalized_Counts_newNames.txt > /home/rpergerson/FlightMice/DifferentialExpression/DESeq2_${celltype}_Normalized_Counts_newNames.sorted.txt
		join ${celltype}_${sample}vsHGC_SigDEdata.sorted.txt DESeq2_${celltype}_Normalized_Counts_newNames.sorted.txt | awk -v OFS="\t" '{gsub(" ", "\t"); print}' > ${celltype}_${sample}vsHGC_joined.txt

	# Get sig genes for Log2fc
		awk '{print $1, $3}' ${celltype}_${sample}vsHGC_SigLogTable.txt| sort -k1b,1 > ${celltype}_${sample}_Log2.sorted
		awk '{print $1}' ~/FlightMice/NormalizedData/DESeq2_${celltype}_Normalized_Counts_newNames.txt | sort -k1b,1  > /home/rpergerson/FlightMice/DifferentialExpression/DESeq2_${celltype}_Normalized_Counts_newNames.sortedLog.txt
		join DESeq2_${celltype}_Normalized_Counts_newNames.sortedLog.txt ${celltype}_${sample}_Log2.sorted | awk -v OFS="\t" '{gsub(" ", "\t"); print}' > ${celltype}_${sample}_Log.txt

	# Join Sig replicates with sig Log2fc to create the replicated data with Log2fc included
		join ${celltype}_${sample}_Log.txt ${celltype}_${sample}vsHGC_joined.txt > ${celltype}_${sample}_joinedwLog.txt

	# Append the new data to temp to create the new file
		awk -v OFS="\t" 'FNR == 1 {print "Log2fc", $0; exit}' ~/FlightMice/NormalizedData/DESeq2_${celltype}_Normalized_Counts_newNames.txt > temp1
		cat ${celltype}_${sample}_joinedwLog.txt >> temp1
		awk 'FNR == 1 {temp = $1; $1 = $2; $2 = temp; print $0}' temp1 > temp11
		cat ${celltype}_${sample}_joinedwLog.txt >> temp11
		awk -v OFS="\t" '{gsub(" ", "\t"); print}' temp11 > ${celltype}_GS_${sample}_SigNormwLog2fc.txt
		# mv temp11 

	# Check the files to make sure no data lines are lost
		head -n3 ${celltype}_${sample}vsHGC_SigDEdata.txt2.sorted
		wc -l ${celltype}_Seq_joined_0.csv.SigAdj3.txt
		wc -l ${celltype}_GS_0_wLog2fc.txt
		head -n2 ${celltype}_GS_0_wLog2fc.txt
	done
done

echo wait
wait

### This for loop is for removing unnecessary intermediate files from the above for loop
for celltype in ON RTN; do
	for sample in 0G 0.33G 0.67G 1G; do
		rm /home/rpergerson/FlightMice/DifferentialExpression/${celltype}_${sample}vsHGC_SigDEdata.sorted.txt
		rm /home/rpergerson/FlightMice/NormalizedData/DESeq2_${celltype}_Normalized_Counts_newNames.sorted.txt
		rm /home/rpergerson/FlightMice/NormalizedData/DESeq2_${celltype}_Normalized_Counts_newNames.sortedLog.txt
		rm /home/rpergerson/FlightMice/DifferentialExpression/${celltype}_${sample}vsHGC_joined.txt
		rm /home/rpergerson/FlightMice/DifferentialExpression/${celltype}_${sample}_Log.txt
		rm /home/rpergerson/FlightMice/DifferentialExpression/${celltype}_${sample}_joinedwLog.txt
		rm /home/rpergerson/FlightMice/NormalizedData/${celltype}_${sample}_Log2.sorted
	done
done


### For loop five
########### Do the same thing as above but for the enrichr pathway genes
for celltype in ON RTN; do
	for file in $(ls /home/rpergerson/FlightMice/*Pathway*wLog2fc*.txt | grep -v tab | grep $celltype); do
		# Get sig genes for replicates
			awk '{print $1, $2}' $file | sort -k1b,1 > $(basename $file .txt).sorted.txt
			sort -k1b,1 ~/FlightMice/NormalizedData/DESeq2_${celltype}_Normalized_Counts_newNames.txt > /home/rpergerson/FlightMice/DifferentialExpression/DESeq2_${celltype}_Normalized_Counts_newNames.sorted.txt
			join $(basename $file .txt).sorted.txt DESeq2_${celltype}_Normalized_Counts_newNames.sorted.txt | awk -v OFS="\t" '{gsub(" ", "\t"); print}' > $(basename $file .txt)_${celltype}_joined.txt

		# Get sig genes for Log2fc
			awk '{print $1, $3}' $file | sort -k1b,1 > $(basename $file .txt).sorted
			awk '{print $1}' ~/FlightMice/DifferentialExpression/${celltype}_all_data_ensemblandLog2fc.txt | sort -k1b,1  > $(basename ~/FlightMice/DifferentialExpression/${celltype}_all_data_ensemblandLog2fc.txt .txt).sortedLog.txt
			join $(basename  ~/FlightMice/DifferentialExpression/${celltype}_all_data_ensemblandLog2fc.txt .txt).sortedLog.txt $(basename $file .txt).sorted | awk -v OFS="\t" '{gsub(" ", "\t"); print}' > $(basename $file .txt)_${celltype}_Log.txt

		# Join Sig replicates with sig Log2fc to create the replicated data with Log2fc included
			join $(basename $file .txt)_${celltype}_Log.txt $(basename $file .txt)_${celltype}_joined.txt > $(basename $file .txt)_${celltype}_joinedwLog.txt

		# Append the new data to temp to create the new file
			awk -v OFS="\t" 'FNR == 1 {print "ensemble", "Log2fc", $0; exit}' ~/FlightMice/NormalizedData/DESeq2_${celltype}_Normalized_Counts_newNames.txt > temp1_$(basename $file)_${celltype}
			cat $(basename $file .txt)_${celltype}_joinedwLog.txt >> temp1_$(basename $file)_${celltype}
			awk '{temp = $2; $2 = $3; $3 = temp; print $0}' temp1_$(basename $file)_${celltype} > temp11_$(basename $file)_${celltype}
			awk -v OFS="\t" '{gsub(" ", "\t"); print}' temp11_$(basename $file)_${celltype} > ~/FlightMice/$(basename $file .txt)_${celltype}_tab.txt

		# Check the files to make sure no data lines are lost
			head -n3 ${celltype}_${sample}vsHGC_SigDEdata.txt2.sorted
			wc -l ${celltype}_Seq_joined_0.csv.SigAdj3.txt
			wc -l ${celltype}_GS_0_wLog2fc.txt
			head -n2 ${celltype}_GS_0_wLog2fc.txt
	done
done

echo wait
wait

### This for loop is for removing unnecessary intermediate files from the above for loop
for celltype in ON RTN; do
	for sample in 0G 0.33G 0.67G 1G; do
		rm /home/rpergerson/FlightMice/DifferentialExpression/${celltype}_${sample}vsHGC_SigDEdata.sorted.txt
		rm /home/rpergerson/FlightMice/NormalizedData/DESeq2_${celltype}_Normalized_Counts_newNames.sorted.txt
		rm /home/rpergerson/FlightMice/NormalizedData/DESeq2_${celltype}_Normalized_Counts_newNames.sortedLog.txt
		rm /home/rpergerson/FlightMice/DifferentialExpression/${celltype}_${sample}vsHGC_joined.txt
		rm /home/rpergerson/FlightMice/DifferentialExpression/${celltype}_${sample}_Log.txt
		rm /home/rpergerson/FlightMice/DifferentialExpression/${celltype}_${sample}_joinedwLog.txt
		rm /home/rpergerson/FlightMice/NormalizedData/${celltype}_${sample}_Log2.sorted
	done
done
echo "completed getGS.sh"