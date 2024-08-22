echo start
#The command used to find what genes are there so we know what genes to exlude for the analasys in line 9 was cat <file> | cut -f1 | sort | uniq
getBG ()
{
	echo "Started processing for file: $file"
	outFile=$(echo $file | awk '{sub(".split", ""); print}')
	M=$(awk -v x=$outFile 'BEGIN{count=0}{if($2 == x) count+=$1/1000000}END{print 1/count}' /data3/rpergerson/FlightMice/bedfiles/${celltype}/${celltype}_HGC_pooled_readCounts)
	echo $M $file | awk '{print 1/$1,$2}'
	cut -f1-3 $file | grep -v -E 'MT|JH|GL|MU|ERCC' | awk -v OFS="\t" '{print "chr"$0} ' | bedtools genomecov -scale $M -i - -g /data2/rpergerson/FlightMice/annotationFiles/mm39.chrom.sizes.txt -bg > $(basename $outFile .bed).bedGraph
	bedGraphToBigWig $(basename $outFile .bed).bedGraph /data2/rpergerson/FlightMice/annotationFiles/mm39.chrom.sizes.txt $(basename $outFile .bed).bw
	echo "Finished processing for file: $file"
}
for celltype in ON RTN; do
	mkdir /data3/rpergerson/FlightMice/bedGraphfiles/${celltype}
	cd /data3/rpergerson/FlightMice/bedGraphfiles/${celltype}

	i=1
	for file in $(ls /data3/rpergerson/FlightMice/bedfiles/${celltype}/*split.bed)
	do
		getBG &
			if [ $(echo $i | awk '{print $1%6}') -eq 0 ]; then
					wait
			fi
			i=$(expr $i + 1)
	done
	wait
done
echo done
