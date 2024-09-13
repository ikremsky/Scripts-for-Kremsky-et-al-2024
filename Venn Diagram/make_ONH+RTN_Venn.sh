#Stephen Justinen

#/home/rpergerson/FlightMice/DifferentialExpression/RTN_GS_0GvsHGC_SigNormwLog_tab.txt
#/home/rpergerson/FlightMice/DifferentialExpression/ON_GS_0GvsHGC_SigNormwLog_tab.txt

echo start

awk -v OFS="\t" '{print $1}' /home/rpergerson/FlightMice/DifferentialExpression/ON_GS_0GvsHGC_SigNormwLog_tab.txt | tail -n +2 | awk -v OFS="\t" '{print $1}' > Names_list_ONH.txt

awk -v OFS="\t" '{print $1}' /home/rpergerson/FlightMice/DifferentialExpression/RTN_GS_0GvsHGC_SigNormwLog_tab.txt | tail -n +2 | awk -v OFS="\t" '{print $1}' > Names_list_RTN.txt

#Write Names_list_overlaps.txt here, use that matching checker or a search script

grep -f Names_list_ONH.txt Names_list_RTN.txt > Names_list_overlaps.txt

#$(wc -l Names_list_ONH.txt)
#$(wc -l Names_list_RTN.txt)

Rscript make_ONH+RTN_Venn.R $(wc -l Names_list_ONH.txt | awk -v OFS="\t" '{print $1}') $(wc -l Names_list_RTN.txt | awk -v OFS="\t" '{print $1}') $(wc -l Names_list_overlaps.txt | awk -v OFS="\t" '{print $1}')

echo done
