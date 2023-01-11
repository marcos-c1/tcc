OUTPUT_FOURIER_REAL_DIR='./Fourier_Real'
OUTPUT_FOURIER_ZCURVE_DIR='./Fourier_ZCurve'
OUTPUT_ENTROPY_SHANNON_DIR='./Entropy/Shannon'
OUTPUT_ENTROPY_TSALLIS_DIR='./Entropy/Tsallis'
OUTPUT_COMPLEX_DIR='./Complex'


clean() {
	rm -rf $OUTPUT_COMPLEX_DIR/*.txt
	rm -rf $OUTPUT_FOURIER_REAL_DIR/*.txt
	rm -rf $OUTPUT_FOURIER_ZCURVE_DIR/*.txt
	rm -rf $OUTPUT_ENTROPY_TSALLIS_DIR/*.txt
	rm -rf $OUTPUT_ENTROPY_SHANNON_DIR/*.txt
}

count() {
	file=$OUTPUT_FOURIER_REAL_DIR/cd_box_fourier_real_data.csv
	cat $file | cut -d ',' -f21 | grep cdbox -c >> $OUTPUT_FOURIER_REAL_DIR/cd_box_fourier_real_label_count.txt
	cat $file | cut -d ',' -f21 | grep negative -c >> $OUTPUT_FOURIER_REAL_DIR/cd_box_fourier_real_label_count.txt

	file=$OUTPUT_FOURIER_REAL_DIR/haca_box_fourier_real_data.csv
	cat $file | cut -d ',' -f21 | grep hacabox -c >> $OUTPUT_FOURIER_REAL_DIR/haca_box_fourier_real_label_count.txt
	cat $file | cut -d ',' -f21 | grep negative -c >> $OUTPUT_FOURIER_REAL_DIR/haca_box_fourier_real_label_count.txt

	file=$OUTPUT_COMPLEX_DIR/cd_box_complex_data.csv
	cat $file | cut -d ',' -f122 | grep cdbox -c >> $OUTPUT_COMPLEX_DIR/cd_box_complex_label_count.txt
	cat $file | cut -d ',' -f122 | grep negative -c >> $OUTPUT_COMPLEX_DIR/cd_box_complex_label_count.txt

	file=$OUTPUT_COMPLEX_DIR/haca_box_complex_data.csv
	cat $file | cut -d ',' -f122 | grep hacabox -c >> $OUTPUT_COMPLEX_DIR/haca_box_complex_label_count.txt
	cat $file | cut -d ',' -f122 | grep negative -c >> $OUTPUT_COMPLEX_DIR/haca_box_complex_label_count.txt

	file=$OUTPUT_FOURIER_ZCURVE_DIR/cd_box_fourier_zcurve_data.csv
	cat $file | cut -d ',' -f21 | grep cdbox -c >> $OUTPUT_FOURIER_ZCURVE_DIR/cd_box_fourier_zcurve_label_count.txt
	cat $file | cut -d ',' -f21 | grep negative -c >> $OUTPUT_FOURIER_ZCURVE_DIR/cd_box_fourier_zcurve_label_count.txt

	file=$OUTPUT_FOURIER_ZCURVE_DIR/haca_box_fourier_zcurve_data.csv
	cat $file | cut -d ',' -f21 | grep hacabox -c >> $OUTPUT_FOURIER_ZCURVE_DIR/haca_box_fourier_zcurve_label_count.txt
	cat $file | cut -d ',' -f21 | grep negative -c >> $OUTPUT_FOURIER_ZCURVE_DIR/haca_box_fourier_zcurve_label_count.txt

	file=$OUTPUT_ENTROPY_TSALLIS_DIR/cd_box_entropy_tsallis_data.csv
	cat $file | cut -d ',' -f4 | grep cdbox -c >> $OUTPUT_ENTROPY_TSALLIS_DIR/cd_box_entropy_tsallis_label_count.txt
	cat $file | cut -d ',' -f4 | grep negative -c >> $OUTPUT_ENTROPY_TSALLIS_DIR/cd_box_entropy_tsallis_label_count.txt

	file=$OUTPUT_ENTROPY_TSALLIS_DIR/haca_box_entropy_tsallis_data.csv
	cat $file | cut -d ',' -f4 | grep hacabox -c >> $OUTPUT_ENTROPY_TSALLIS_DIR/haca_box_entropy_tsallis_label_count.txt
	cat $file | cut -d ',' -f4 | grep negative -c >> $OUTPUT_ENTROPY_TSALLIS_DIR/haca_box_entropy_tsallis_label_count.txt

	file=$OUTPUT_ENTROPY_SHANNON_DIR/cd_box_entropy_shannon_data.csv
	cat $file | cut -d ',' -f4 | grep cdbox -c >> $OUTPUT_ENTROPY_SHANNON_DIR/cd_box_entropy_shannon_label_count.txt
	cat $file | cut -d ',' -f4 | grep negative -c >> $OUTPUT_ENTROPY_SHANNON_DIR/cd_box_entropy_shannon_label_count.txt

	file=$OUTPUT_ENTROPY_SHANNON_DIR/haca_box_entropy_shannon_data.csv
	cat $file | cut -d ',' -f4 | grep hacabox -c >> $OUTPUT_ENTROPY_SHANNON_DIR/haca_box_entropy_shannon_label_count.txt
	cat $file | cut -d ',' -f4 | grep negative -c >> $OUTPUT_ENTROPY_SHANNON_DIR/haca_box_entropy_shannon_label_count.txt
}

if [[ $1 == "clean" ]]; then
	clean
elif [ $# -eq 0 ]; then
	count
else
	printf '%s\n' "Usage [clean] to clean all files *.txt in every directory or ./count_labels.sh to count every label in .csv files"
fi
