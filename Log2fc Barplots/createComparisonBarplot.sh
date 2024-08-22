echo start
### Note! The input *SigNormwLog2fc.txt files were created from the for loop labeled "For loop four: Create same data as above for significant DEG's but with Log2fc column included" in the script getGS.sh. 
#         The file names were edited based off of the file being created but the input files into the getGS.sh script for this barplot script came from the getSig*GvsHGC.R scripts and had the "SigLogandQ.txt" ending. 
for sample in ON RTN; do
    name=$(echo ${sample}_GS_0.67G.txt | awk '{gsub("_GS_0.67G.txt", ""); print}')
    Rscript ~/FlightMice/Scripts/createComparisonBarplot.R ~/FlightMice/DifferentialExpression/${sample}_GS_0G_SigNormwLog2fc.txt ~/FlightMice/DifferentialExpression/${sample}_GS_0.33G_SigNormwLog2fc.txt ~/FlightMice/DifferentialExpression/${sample}_GS_0.67G_SigNormwLog2fc.txt ~/FlightMice/DifferentialExpression/${sample}_GS_1G_SigNormwLog2fc.txt $name
done
echo done
