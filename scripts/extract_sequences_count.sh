#!/bin/bash

occ=0
dir="../Validation/"
out_dir="../sequences_count/"
total_sequences=0

for file in $(ls $dir)
do
	rm -rf $out_dir/$file
	echo $file > $out_dir/$file 
	#cut -d '/' -f 3 <<< $i && cat $i | grep '>' | wc -l
	cat $dir/$file | grep '>' | wc -l > $out_dir/$file
done 
