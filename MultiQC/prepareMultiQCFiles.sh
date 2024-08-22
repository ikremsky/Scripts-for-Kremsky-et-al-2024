echo start
## All .html files were retrieved via the 'wget' command line utility
## All .zip files were obtained from the NASA OSDR workspace and transferred to the server using scp

## Rename the files to only inlude the core name without all the access token data from the html input (I used wget to source these files from the NASA website)
for file in $(ls /home/rpergerson/FlightMice/Fastq/FastQC/*.html*); do
    new=$(echo $file | cut -f1 -d'?')
    mv $file $new
done

## Rename ".zip" and ".html" files to include gravity treatment
for celltype in ON RTN; do
    for file in $(ls /home/rpergerson/FlightMice/Fastq/FastQC/*.zip | grep FLT | grep $celltype); do
        old=$(echo $(basename $file _trimmed_fastqc.zip))
        fltn=$(echo $(basename $file _trimmed_fastqc.zip) | cut -f4 -d'_')
        treatment=$(grep $fltn MHU8_${celltype}_Mao_Tissues_Sample_Info_Copy.txt.BamNames.txt | awk '{print $2}')
        newName=$(echo $file | awk -v old=$old -v trt=$treatment '{gsub("_FLT_", "_FLT_"trt"_"); print}')
        mv $file $newName
    done
done

for celltype in ON RTN; do
    for file in $(ls /home/rpergerson/FlightMice/Fastq/FastQC/*.html | grep FLT | grep $celltype); do
        old=$(echo $(basename $file _trimmed_fastqc.html))
        fltn=$(echo $(basename $file _trimmed_fastqc.html) | cut -f4 -d'_')
        treatment=$(grep $fltn MHU8_${celltype}_Mao_Tissues_Sample_Info_Copy.txt.BamNames.txt | awk '{print $2}')
        newName=$(echo $file | awk -v old=$old -v trt=$treatment '{gsub("_FLT_", "_FLT_"trt"_"); print}')
        mv $file $newName
    done
done


## Create respective directories to prepare for the MultiQC analysis (MultiQC runs on input/output directories)
for celltype in ON RTN; do
    for sample in 0.33G 0.67G 0G 1G; do
        mkdir /home/rpergerson/FlightMice/Fastq/FastQC/${celltype}_FLT_${sample}
    done
    wait
    mkdir /home/rpergerson/FlightMice/Fastq/FastQC/${celltype}_HGC
done

## Move ".zip" and ".html" files to their respective directiories based off of celltype and treatment group
## Flight ".zip" and ".html" files
for celltype in ON RTN; do
    for sample in 0.33G 0.67G 1G 0G; do
        files=$(ls /home/rpergerson/FlightMice/Fastq/FastQC/MHU-8_${celltype}_FLT_${sample}*.zip)
        mv $files /home/rpergerson/FlightMice/Fastq/FastQC/${celltype}_FLT_${sample}
    done
done

for celltype in ON RTN; do
    for sample in 0.33G 0.67G 1G 0G; do
        files=$(ls /home/rpergerson/FlightMice/Fastq/FastQC/MHU-8_${celltype}_FLT_${sample}*.html)
        mv $files /home/rpergerson/FlightMice/Fastq/FastQC/${celltype}_FLT_${sample}
    done
done

## HGC ".zip" and ".html" files
for celltype in ON RTN; do
    for sample in HGC; do
        files=$(ls /home/rpergerson/FlightMice/Fastq/FastQC/MHU-8_${celltype}_${sample}_*.zip)
        mv $files /home/rpergerson/FlightMice/Fastq/FastQC/${celltype}_HGC
    done
done

for celltype in ON RTN; do
    for sample in HGC; do
        files=$(ls /home/rpergerson/FlightMice/Fastq/FastQC/MHU-8_${celltype}_${sample}_*.html)
        mv $files /home/rpergerson/FlightMice/Fastq/FastQC/${celltype}_HGC
    done
done
echo done