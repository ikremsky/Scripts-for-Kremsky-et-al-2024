echo start
## Note: All replicate bam files were stored in the same folder in data2, its just that the flight pooled bam files were stored in data2 and the pooled HGC files were stored in data3 due to space issues
## Pool replicates of the same treatment type

for celltype in ON RTN; do
	mkdir /data2/rpergerson/bamfiles/${celltype}/pooledBam      #The pooled 0-1G files are stored here
	cd /data2/rpergerson/bamfiles/${celltype}/pooledBam

	for type in 0.33G 0.67G 0G 1G
	do
		files=$(ls /data2/rpergerson/bamfiles/${celltype}/*${type}*.bam) 
		# echo $files
		samtools merge ${celltype}_${type}.pooled.aligned.sortedByCoord.bam $files &
	done
	wait
done

for celltype in ON RTN; do
	mkdir /data3/rpergerson/FlightMice/pooledBam
	mkdir /data3/rpergerson/FlightMice/pooledBam/${celltype}      #The pooled HGC files are stored here
	cd /data3/rpergerson/FlightMice/pooledBam/${celltype}

	for type in HGC
	do
		files=$(ls /data2/rpergerson/bamfiles/${celltype}/*${type}*.bam) 
		# echo $files
		samtools merge ${celltype}_${type}.pooled.aligned.sortedByCoord.bam $files &
	done
	wait
done
echo done