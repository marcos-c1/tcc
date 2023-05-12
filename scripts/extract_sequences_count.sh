#!/bin/bash

occ=0
file="../negatives/neg.fasta"
output_file="../sequences_count/sequences_count_neg.txt"
total_sequences=0

for i in $file 
do
	echo $i >> $output_file 
	cut -d '/' -f 3 <<< $i && cat $i | grep '>' | wc -l
done > $output_file 
