occ=0
file="./HACA-BOX-average/*.fasta"

for i in $file 
do
	cut -d '/' -f 3 <<< $i && cat $i | grep '>' | wc -l
done > sequences_count_haca_average.txt
