# FOURIER_REAL_DIR
CD_BOX_FOURIER_REAL_DIR='../../Feature_Extraction_CDBOX/Fourier_Real'
HACA_BOX_FOURIER_REAL_DIR='../../Feature_Extraction_HACABOX/Fourier_Real'
CD_BOX_NEGATIVE_FOURIER_REAL_DIR='../../Feature_Extraction_CDBOX_Negative/Fourier_Real'
HACA_BOX_NEGATIVE_FOURIER_REAL_DIR='../../Feature_Extraction_HACABOX_Negative/Fourier_Real'

# FOURIER_ZCURVE_DIR
CD_BOX_FOURIER_ZCURVE_DIR='../../Feature_Extraction_CDBOX/Fourier_ZCurve'
HACA_BOX_FOURIER_ZCURVE_DIR='../../Feature_Extraction_HACABOX/Fourier_ZCurve'
CD_BOX_NEGATIVE_FOURIER_ZCURVE_DIR='../../Feature_Extraction_CDBOX_Negative/Fourier_ZCurve'
HACA_BOX_NEGATIVE_FOURIER_ZCURVE_DIR='../../Feature_Extraction_HACABOX_Negative/Fourier_ZCurve'

# ENTROPY_SHANNON_DIR
CD_BOX_ENTROPY_SHANNON_DIR='../../Feature_Extraction_CDBOX/Entropy/Shannon'
HACA_BOX_ENTROPY_SHANNON_DIR='../../Feature_Extraction_HACABOX/Entropy/Shannon'
CD_BOX_NEGATIVE_ENTROPY_SHANNON_DIR='../../Feature_Extraction_CDBOX_Negative/Entropy/Shannon'
HACA_BOX_NEGATIVE_ENTROPY_SHANNON_DIR='../../Feature_Extraction_HACABOX_Negative/Entropy/Shannon'

# ENTROPY_TSALLIS_DIR
CD_BOX_ENTROPY_TSALLIS_DIR='../../Feature_Extraction_CDBOX/Entropy/Tsallis'
HACA_BOX_ENTROPY_TSALLIS_DIR='../../Feature_Extraction_HACABOX/Entropy/Tsallis' 
CD_BOX_NEGATIVE_ENTROPY_TSALLIS_DIR='../../Feature_Extraction_CDBOX_Negative/Entropy/Tsallis'
HACA_BOX_NEGATIVE_ENTROPY_TSALLIS_DIR='../../Feature_Extraction_HACABOX_Negative/Entropy/Tsallis'

# COMPLEX_DIR
CD_BOX_COMPLEX_DIR='../../Feature_Extraction_CDBOX/Complex'
HACA_BOX_COMPLEX_DIR='../../Feature_Extraction_HACABOX/Complex'
CD_BOX_NEGATIVE_COMPLEX_DIR='../../Feature_Extraction_CDBOX_Negative/Complex'
HACA_BOX_NEGATIVE_COMPLEX_DIR='../../Feature_Extraction_HACABOX_Negative/Complex'

# OUTPUT DIR
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
	echo -e "Concatene todos os arquivos de conjunto positivo com negativo contendo as features em um único arquivo mesclado com n labels"
	echo -e "Caso queira remover todos os arquivos gerados pela concatenação dos arquivos contendo as features, rode o commando: ./concatenate_files.sh clean"
  echo -e "Caso queira concatenar todos os arquivos gerados pela extracao contendo os conjuntos positivos e negativos, rode o comando ./concatenate_files.sh all"
	echo -e "Uso: ./concatenate_files.sh [cd-box|haca-box] [fourier_real|fourier_zcurve|complex|entropy_shannon|entropy_tsallis]" 
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
	local group=$1
	local method=$2
	local file

	if [ $group == 'cd-box' ]; then 
		case $method in
			'fourier_real')
				file='./Fourier_Real/cd_box_fourier_real_data.csv'
				cat $CD_BOX_FOURIER_REAL_DIR/*.csv $CD_BOX_NEGATIVE_FOURIER_REAL_DIR/*.csv > $file 
				;;
			'fourier_zcurve')
				file='./Fourier_ZCurve/cd_box_fourier_zcurve_data.csv'
				cat $CD_BOX_FOURIER_ZCURVE_DIR/*.csv  $CD_BOX_NEGATIVE_FOURIER_ZCURVE_DIR/*.csv > $file 
				;;
			'entropy_shannon')
				file='./Entropy/Shannon/cd_box_entropy_shannon_data.csv'
				cat $CD_BOX_ENTROPY_SHANNON_DIR/*.csv  $CD_BOX_NEGATIVE_ENTROPY_SHANNON_DIR/*.csv > $file 
				;;
			'entropy_tsallis')
				file='./Entropy/Tsallis/cd_box_entropy_tsallis_data.csv'
				cat $CD_BOX_ENTROPY_TSALLIS_DIR/*.csv  $CD_BOX_NEGATIVE_ENTROPY_TSALLIS_DIR/*.csv > $file 
				;;
			'complex')
				file='./Complex/cd_box_complex_data.csv'
				cat $CD_BOX_COMPLEX_DIR/*.csv  $CD_BOX_NEGATIVE_COMPLEX_DIR/*.csv > $file 
				;;
			*)
				echo -e "Método de extração de features não reconhecido."
				usage
				;;
		esac
	elif [ $group == 'haca-box' ]; then
		case $method in
			'fourier_real')
				file='./Fourier_Real/haca_box_fourier_real_data.csv'
				cat $HACA_BOX_FOURIER_REAL_DIR/*.csv $HACA_BOX_NEGATIVE_FOURIER_REAL_DIR/*.csv > $file 
				;;
			'fourier_zcurve')
				file='./Fourier_ZCurve/haca_box_fourier_zcurve_data.csv'
				cat $HACA_BOX_FOURIER_ZCURVE_DIR/*.csv  $HACA_BOX_NEGATIVE_FOURIER_ZCURVE_DIR/*.csv > $file 
				;;
			'entropy_shannon')
				file='./Entropy/Shannon/haca_box_entropy_shannon_data.csv'
				cat $HACA_BOX_ENTROPY_SHANNON_DIR/*.csv  $HACA_BOX_NEGATIVE_ENTROPY_SHANNON_DIR/*.csv > $file 
				;;
			'entropy_tsallis')
				file='./Entropy/Tsallis/haca_box_entropy_tsallis_data.csv'
				cat $HACA_BOX_ENTROPY_TSALLIS_DIR/*.csv  $HACA_BOX_NEGATIVE_ENTROPY_TSALLIS_DIR/*.csv > $file 
				;;
			'complex')
				file='./Complex/haca_box_complex_data.csv'
				cat $HACA_BOX_COMPLEX_DIR/*.csv  $HACA_BOX_NEGATIVE_COMPLEX_DIR/*.csv > $file 
				;;
			*)
				echo -e "Método de extração de features não reconhecido."
				usage
				;;
		esac
	else
		echo -e "Grupo de snoRNA não reconhecido."
		usage
	fi

	chmod +rwx $file
	remove_header_duplicates $file 
}

if [ "$1" = "clean" ]; then
	clean
	echo -e "Todos os arquivos que continham os dados concatenados das features foram removidos"
	exit 0
elif [ "$1" = "all" ]; then
  append_files "cd-box" "fourier_real"
  append_files "cd-box" "fourier_zcurve"
  append_files "cd-box" "complex"
  append_files "cd-box" "entropy_shannon"
  append_files "cd-box" "entropy_tsallis" 

  append_files "haca-box" "fourier_real"
  append_files "haca-box" "fourier_zcurve"
  append_files "haca-box" "complex"
  append_files "haca-box" "entropy_shannon"
  append_files "haca-box" "entropy_tsallis" 

  echo -e "Todos os arquivos foram concatenados."
elif [ $# -le 1 ]; then 
	usage
else
	append_files $1 $2
fi
