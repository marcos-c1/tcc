#!/bin/bash

occ=0
file="../negatives/negative_group.fasta"
output_file="../sequences_count/sequences_count_negative_group.txt"
total_sequences=0

for i in $file 
do
	echo $i >> $output_file 
	cut -d '/' -f 3 <<< $i && cat $i | grep '>' | wc -l
done > $output_file 
