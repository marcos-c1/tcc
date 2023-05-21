#!/bin/bash

occ=0
file="../negatives/diff_RNAs/TOTAL.fasta"
output_file="../sequences_count/total_diff_RNAs.txt"
total_sequences=0

for i in $file 
do
	echo $i >> $output_file 
	cut -d '/' -f 3 <<< $i && cat $i | grep '>' | wc -l
done > $output_file 
