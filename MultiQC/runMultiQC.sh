# Reyna Pergerson
## Input files are the .zip and .html files from fastqc
## The naming for HGC is a little different for the treatment files, so separate for loops are for HGC comapared to treatment groups
echo start
for celltype in ON RTN; do
    for sample in 0.33G 0.67G 0G 1G; do
        for mate in R1 R2; do
            mkdir /home/rpergerson/FlightMice/Fastq/FastQC/${celltype}_FLT_${sample}/$mate
            output=/home/rpergerson/FlightMice/Fastq/FastQC/${celltype}_FLT_${sample}/$mate
            report_name=${celltype}_${sample}_${mate}_multiqc_report
            multiqc -v /home/rpergerson/FlightMice/Fastq/FastQC/${celltype}_FLT_${sample}/*${mate}*.* -o $output -n $report_name
        done
    done
done

wait

for celltype in ON RTN; do
    for sample in HGC: do
        for mate in R1 R2: do
            mkdir /home/rpergerson/FlightMice/Fastq/FastQC/${celltype}_${sample}/$mate
            output=/home/rpergerson/FlightMice/Fastq/FastQC/${celltype}_${sample}/$mate
            report_name=${celltype}_${sample}_${mate}_multiqc_report
            multiqc -v /home/rpergerson/FlightMice/Fastq/FastQC/${celltype}_${sample}/*${mate}*.* -o $output -n $report_name
        done
    done
done
echo done