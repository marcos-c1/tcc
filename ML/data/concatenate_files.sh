# FOURIER_REAL_DIR
CD_BOX_FOURIER_REAL_DIR='../../Feature_Extraction_CDBOX/Fourier_Real'
HACA_BOX_FOURIER_REAL_DIR='../../Feature_Extraction_HACABOX/Fourier_Real'

# FOURIER_ZCURVE_DIR
CD_BOX_FOURIER_ZCURVE_DIR='../../Feature_Extraction_CDBOX/Fourier_ZCurve'
HACA_BOX_FOURIER_ZCURVE_DIR='../../Feature_Extraction_HACABOX/Fourier_ZCurve'

# ENTROPY_SHANNON_DIR
CD_BOX_ENTROPY_SHANNON_DIR='../../Feature_Extraction_CDBOX/Entropy/Shannon'
HACA_BOX_ENTROPY_SHANNON_DIR='../../Feature_Extraction_HACABOX/Entropy/Shannon'

# ENTROPY_TSALLIS_DIR
CD_BOX_ENTROPY_TSALLIS_DIR='../../Feature_Extraction_CDBOX/Entropy/Tsallis'
HACA_BOX_ENTROPY_TSALLIS_DIR='../../Feature_Extraction_HACABOX/Entropy/Tsallis' 

CD_BOX_COMPLEX_DIR='../../Feature_Extraction_CDBOX/Complex'
HACA_BOX_COMPLEX_DIR='../../Feature_Extraction_HACABOX/Complex'

OUTPUT_FOURIER_REAL_DIR='./Fourier_Real'
OUTPUT_FOURIER_ZCURVE_DIR='./Fourier_ZCurve'
OUTPUT_ENTROPY_SHANNON_DIR='./Entropy/Shannon'
OUTPUT_ENTROPY_TSALLIS_DIR='./Entropy/Tsallis'
OUTPUT_COMPLEX_DIR='./Complex'

clean()
{
	rm -rf $OUTPUT_FOURIER_REAL_DIR/*.csv
	rm -rf $OUTPUT_FOURIER_ZCURVE_DIR/*.csv
	rm -rf $OUTPUT_ENTROPY_SHANNON_DIR/*.csv
	rm -rf $OUTPUT_ENTROPY_TSALLIS_DIR/*.csv
	rm -rf $OUTPUT_COMPLEX_DIR/*.csv
}

usage()
{
	printf '%s\n' "Concatene todos os arquivos contendo as features em um único arquivo mesclado com n labels"
	printf '%s\n' "Uso: ./concatenate_files.sh [fourier_real|fourier_zcurve|complex|entropy_shannon|entropy_tsallis]" 
	printf '%s\n' "Caso queira remover todos os arquivos gerados pela concatenação dos arquivos contendo as features, rode o commando: ./concatenate_files.sh clean"
	exit 0
}

remove_header_duplicates()
{
	local file=$1
	header=$(cat $file | head -n 1)
	pattern=$(cat $file| head -n 1 | cut -f1 -d ',')
	echo $header > tmp.csv
	sed "/$pattern/d" $file >> tmp.csv
	mv tmp.csv $file
	rm -rf *.csv
}

append_files()
{
	local dir=$1
	local file

	case $dir in
		'fourier_real')
			file='./Fourier_Real/fourier_real_data.csv'
			cat $CD_BOX_FOURIER_REAL_DIR/*.csv $HACA_BOX_FOURIER_REAL_DIR/*.csv > $file 
			;;
		'fourier_zcurve')
			file=./Fourier_ZCurve/fourier_zcurve_data.csv
			cat $CD_BOX_FOURIER_ZCURVE_DIR/*.csv  $HACA_BOX_FOURIER_ZCURVE_DIR/*.csv > $file 
			;;
		'entropy_shannon')
			file='./Entropy/Shannon/entropy_shannon_data.csv'
			cat $CD_BOX_ENTROPY_SHANNON_DIR/*.csv  $HACA_BOX_ENTROPY_SHANNON_DIR/*.csv > $file 
			;;
		'entropy_tsallis')
			file='./Entropy/Tsallis/entropy_tsallis_data.csv'
			cat $CD_BOX_ENTROPY_TSALLIS_DIR/*.csv  $HACA_BOX_ENTROPY_TSALLIS_DIR/*.csv > $file 
			;;
		'complex')
			file='./Complex/complex_data.csv'
			cat $CD_BOX_COMPLEX_DIR/*.csv  $HACA_BOX_COMPLEX_DIR/*.csv > $file 
			;;
		*)
			printf '%s\n' "Método de extração de features não reconhecido."
			usage
			;;
	esac
	chmod +rwx $file
	remove_header_duplicates $file 
}

if [ "$1" = "clean" ]; then
	clean
	printf '%s\n' "Todos os arquivos que continham os dados concatenados das features foram removidos"
	exit 0
fi

if [ $# -eq 0 ]; then 
	usage
fi

append_files $1
