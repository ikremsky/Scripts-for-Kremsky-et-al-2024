echo start
### We ran into space issues when processing the Bam files. Because of this, the pooled bam files for the treatment types were on one drive and the pooled bam for the HGC files were on another
getFPKM ()
{
	echo "Started processing for file: $file"
	bamToBed -split -i $file | grep -v random > /data3/rpergerson/FlightMice/bedfiles/${celltype}/$(basename $file .bam).split.bed &          
	bamToBed -i $file | grep -v random >  /data3/rpergerson/FlightMice/bedfiles/${celltype}/$(basename $file .bam).bed &
	wait
	wc -l /data3/rpergerson/FlightMice/bedfiles/${celltype}/$(basename $file .bam).bed | awk '{sub("/data3/rpergerson/FlightMice/bedfiles/${celltype}/", ""); print}' >> /data3/rpergerson/FlightMice/bedfiles/${celltype}/${celltype}_pooled_readCounts
	wc -l /data3/rpergerson/FlightMice/bedfiles/${celltype}/$(basename $file .bam).bed | awk '{sub("/data3/rpergerson/FlightMice/bedfiles/${celltype}/", ""); print}' >> /data3/rpergerson/FlightMice/bedfiles/${celltype}/${celltype}_HGC_pooled_readCounts
	echo "Finished processing for file: $file"
}

### Process the flight pooled bam files
for celltype in ON RTN; do
	# mkdir /data2/rpergerson/FlightMice/bedfiles
	# mkdir /data2/rpergerson/FlightMice/bedfiles/${celltype}
	cd /data2/rpergerson/FlightMice/bedfiles/${celltype}

	for file in $(ls /data2/rpergerson/bamfiles/${celltype}/pooledBam/*.bam); do
		getFPKM &
	done
	wait
done

### Process the HGC pooled bam files
for celltype in ON RTN; do
	# mkdir /data3/rpergerson/FlightMice/bedfiles
	# mkdir /data3/rpergerson/FlightMice/bedfiles/${celltype}
	cd /data3/rpergerson/FlightMice/bedfiles/${celltype}

	for file in $(ls /data3/rpergerson/FlightMice/pooledBam/${celltype}/*.bam); do
		getFPKM &
	done
	wait
done
echo done