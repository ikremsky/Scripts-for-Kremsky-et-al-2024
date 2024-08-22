echo start
for celltype in ON RTN; do
# cd ~/../../data2/rpergerson/bamfiles/${celltype}
    for file in $(ls /data2/rpergerson/bamfiles/${celltype}/*bam | grep FLT); do
        old=$(echo $(basename $file _Aligned.sortedByCoord.out.bam))
        new=$(grep $old /home/rpergerson/FlightMice/MHU8_${celltype}_Mao_Tissues_Sample_Info_Copy.txt.BamNames.txt | awk '{print $1"_"$2}')
        echo ${new}_Aligned.sortedByCoord.out.bam
        mv $file ${new}_Aligned.sortedByCoord.out.bam
    done
done
echo done