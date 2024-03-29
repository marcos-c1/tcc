#!/bin/bash

# Extraction algorithms
FOURIER_ALGORITHM="../extraction/methods/FourierClass.py"
ENTROPY_ALGORITHM="../extraction/methods/EntropyClass.py"
COMPLEX_ALGORITHM="../extraction/methods/ComplexNetworksClass.py"

# Input directory
CD_BOX_DIRECTORY="../average_data/cd_box/*.fasta"
HACA_BOX_DIRECTORY="../average_data/haca_box/*.fasta"
REAL_DATA_DIRECTORY="../validation/*"

# Output directory for CD-BOX class
OUTPUT_CDBOX_EXTRACT_FOURIER_REAL_DIRECTORY="../extraction/cd_box/Fourier_Real"
OUTPUT_CDBOX_EXTRACT_FOURIER_ZCURVE_DIRECTORY="../extraction/cd_box/Fourier_ZCurve"
OUTPUT_CDBOX_EXTRACT_ENTROPY_DIRECTORY="../extraction/cd_box/Entropy"
OUTPUT_CDBOX_EXTRACT_COMPLEX_DIRECTORY="../extraction/cd_box/Complex"

# Output directory for HACA-BOX class
OUTPUT_HACABOX_EXTRACT_FOURIER_REAL_DIRECTORY="../extraction/haca_box/Fourier_Real"
OUTPUT_HACABOX_EXTRACT_FOURIER_ZCURVE_DIRECTORY="../extraction/haca_box/Fourier_ZCurve"
OUTPUT_HACABOX_EXTRACT_ENTROPY_DIRECTORY="../extraction/haca_box/Entropy"
OUTPUT_HACABOX_EXTRACT_COMPLEX_DIRECTORY="../extraction/haca_box/Complex"

# Output directory for Negative sample of CD-BOX class
OUTPUT_CDBOX_NEGATIVE_EXTRACT_FOURIER_REAL_DIRECTORY="../extraction/cd_box_negative/Fourier_Real"
OUTPUT_CDBOX_NEGATIVE_EXTRACT_FOURIER_ZCURVE_DIRECTORY="../extraction/cd_box_negative/Fourier_ZCurve"
OUTPUT_CDBOX_NEGATIVE_EXTRACT_ENTROPY_DIRECTORY="../extraction/cd_box_negative/Entropy"
OUTPUT_CDBOX_NEGATIVE_EXTRACT_COMPLEX_DIRECTORY="../extraction/cd_box_negative/Complex"

# Output directory for Negative sample of HACA-BOX class
OUTPUT_HACABOX_NEGATIVE_EXTRACT_FOURIER_REAL_DIRECTORY="../extraction/haca_box_negative/Fourier_Real"
OUTPUT_HACABOX_NEGATIVE_EXTRACT_FOURIER_ZCURVE_DIRECTORY="../extraction/haca_box_negative/Fourier_ZCurve"
OUTPUT_HACABOX_NEGATIVE_EXTRACT_ENTROPY_DIRECTORY="../extraction/haca_box_negative/Entropy"
OUTPUT_HACABOX_NEGATIVE_EXTRACT_COMPLEX_DIRECTORY="../extraction/haca_box_negative/Complex"

# Output directory for Real Data sample
OUTPUT_REAL_DATA_FOURIER_REAL_DIRECTORY="../extraction/real_data/Fourier_Real"
OUTPUT_REAL_DATA_FOURIER_ZCURVE_DIRECTORY="../extraction/real_data/Fourier_ZCurve"
OUTPUT_REAL_DATA_ENTROPY_DIRECTORY="../extraction/real_data/Entropy"
OUTPUT_REAL_DATA_COMPLEX_DIRECTORY="../extraction/real_data/Complex"

# Negative file
NEGATIVE_FILE="../negatives/all_negative.fasta"

# Remove all positive extraction files
clean_positive() {
	rm -rf $OUTPUT_CDBOX_EXTRACT_FOURIER_REAL_DIRECTORY/*.csv
	rm -rf $OUTPUT_CDBOX_EXTRACT_FOURIER_ZCURVE_DIRECTORY/*.csv
	rm -rf $OUTPUT_CDBOX_EXTRACT_ENTROPY_DIRECTORY/Shannon/*.csv
	rm -rf $OUTPUT_CDBOX_EXTRACT_ENTROPY_DIRECTORY/Tsallis/*.csv
	rm -rf $OUTPUT_CDBOX_EXTRACT_COMPLEX_DIRECTORY/*.csv

	rm -rf $OUTPUT_HACABOX_EXTRACT_FOURIER_REAL_DIRECTORY/*.csv
	rm -rf $OUTPUT_HACABOX_EXTRACT_FOURIER_ZCURVE_DIRECTORY/*.csv
	rm -rf $OUTPUT_HACABOX_EXTRACT_ENTROPY_DIRECTORY/Shannon/*.csv
	rm -rf $OUTPUT_HACABOX_EXTRACT_ENTROPY_DIRECTORY/Tsallis/*.csv
	rm -rf $OUTPUT_HACABOX_EXTRACT_COMPLEX_DIRECTORY/*.csv
}

# Remove all validation extraction files
clean_real_data() {
	rm -rf $OUTPUT_REAL_DATA_FOURIER_REAL_DIRECTORY/*.csv
	rm -rf $OUTPUT_REAL_DATA_FOURIER_ZCURVE_DIRECTORY/*.csv
	rm -rf $OUTPUT_REAL_DATA_ENTROPY_DIRECTORY/Shannon/*.csv
	rm -rf $OUTPUT_REAL_DATA_ENTROPY_DIRECTORY/Tsallis/*.csv
	rm -rf $OUTPUT_REAL_DATA_COMPLEX_DIRECTORY/*.csv
}

# Remove all negatives extraction files
clean_negative() {
	rm -rf $OUTPUT_CDBOX_NEGATIVE_EXTRACT_FOURIER_REAL_DIRECTORY/*.csv
	rm -rf $OUTPUT_CDBOX_NEGATIVE_EXTRACT_FOURIER_ZCURVE_DIRECTORY/*.csv
	rm -rf $OUTPUT_CDBOX_NEGATIVE_EXTRACT_ENTROPY_DIRECTORY/Shannon/*.csv
	rm -rf $OUTPUT_CDBOX_NEGATIVE_EXTRACT_ENTROPY_DIRECTORY/Tsallis/*.csv
	rm -rf $OUTPUT_CDBOX_NEGATIVE_EXTRACT_COMPLEX_DIRECTORY/*.csv

	rm -rf $OUTPUT_HACABOX_NEGATIVE_EXTRACT_FOURIER_REAL_DIRECTORY/*.csv
	rm -rf $OUTPUT_HACABOX_NEGATIVE_EXTRACT_FOURIER_ZCURVE_DIRECTORY/*.csv
	rm -rf $OUTPUT_HACABOX_NEGATIVE_EXTRACT_ENTROPY_DIRECTORY/Shannon/*.csv
	rm -rf $OUTPUT_HACABOX_NEGATIVE_EXTRACT_ENTROPY_DIRECTORY/Tsallis/*.csv
	rm -rf $OUTPUT_HACABOX_NEGATIVE_EXTRACT_COMPLEX_DIRECTORY/*.csv

}

extract() {
	local group=$1
	local method=$2
	local fourier_number=$3
	local entropy_choice=$3
	local algorithm
	local output_directory

	case $method in
	"fourier")
		if [ -z $fourier_number ]; then
			echo -e "Escolha o mapeamento numérico desejado\n\t1 = Binary\n\t2 = Z-curve\n\t3 = Real\n\t4 = Integer\n\t5 = EIIP\n\t6 = Complex Number\n\t7 = Atomic Number"
			exit 0
		fi
		if [ $group = 'cdbox' ]; then
			for file in $CD_BOX_DIRECTORY; do
				archive=$(echo -e $file | cut -f3 -d "/" | cut -f1 -d ".")
				case $fourier_number in
				"3")
					python3 $FOURIER_ALGORITHM -i $file -o $OUTPUT_CDBOX_EXTRACT_FOURIER_REAL_DIRECTORY/$archive.csv -l cdbox -r $fourier_number 1>/dev/null
					;;
				"2")
					python3 $FOURIER_ALGORITHM -i $file -o $OUTPUT_CDBOX_EXTRACT_FOURIER_ZCURVE_DIRECTORY/$archive.csv -l cdbox -r $fourier_number 1>/dev/null
					;;
				esac
				echo -e "Extracting...\t$group\t$method\t$fourier_number\t$archive.csv"
			done
		elif [ $group = 'hacabox' ]; then
			for file in $HACA_BOX_DIRECTORY; do
				archive=$(echo -e $file | cut -f3 -d "/" | cut -f1 -d ".")
				case $fourier_number in
				"3")
					python3 $FOURIER_ALGORITHM -i $file -o $OUTPUT_HACABOX_EXTRACT_FOURIER_REAL_DIRECTORY/$archive.csv -l hacabox -r $fourier_number 1>/dev/null
					;;
				"2")
					python3 $FOURIER_ALGORITHM -i $file -o $OUTPUT_HACABOX_EXTRACT_FOURIER_ZCURVE_DIRECTORY/$archive.csv -l hacabox -r $fourier_number 1>/dev/null
					;;
				esac
				echo -e "Extracting...\t$group\t$method\t$fourier_number\t$archive.fasta"
			done
		elif [ $group = 'negative' ]; then
			case $fourier_number in
			"3")
				archive="negative_fourier_real"
				python3 $FOURIER_ALGORITHM -i $NEGATIVE_FILE -o $OUTPUT_CDBOX_NEGATIVE_EXTRACT_FOURIER_REAL_DIRECTORY/$archive.csv -l negative -r $fourier_number 1>/dev/null
				python3 $FOURIER_ALGORITHM -i $NEGATIVE_FILE -o $OUTPUT_HACABOX_NEGATIVE_EXTRACT_FOURIER_REAL_DIRECTORY/$archive.csv -l negative -r $fourier_number 1>/dev/null
				;;
			"2")
				archive="negative_fourier_zcurve"
				python3 $FOURIER_ALGORITHM -i $NEGATIVE_FILE -o $OUTPUT_CDBOX_NEGATIVE_EXTRACT_FOURIER_ZCURVE_DIRECTORY/$archive.csv -l negative -r $fourier_number 1>/dev/null
				python3 $FOURIER_ALGORITHM -i $NEGATIVE_FILE -o $OUTPUT_HACABOX_NEGATIVE_EXTRACT_FOURIER_ZCURVE_DIRECTORY/$archive.csv -l negative -r $fourier_number 1>/dev/null
				;;
			esac
			echo -e "$group\t$method\t$fourier_number\t$archive.csv"
		elif [ $group = 'real' ]; then
			for file in $REAL_DATA_DIRECTORY; do
				archive=$(echo -e $file | cut -f3 -d "/" | cut -f1 -d ".")
				case $fourier_number in
				"3")
					python3 $FOURIER_ALGORITHM -i $file -o $OUTPUT_REAL_DATA_FOURIER_REAL_DIRECTORY/$archive.csv -l real -r $fourier_number 1>/dev/null
					;;
				"2")
					python3 $FOURIER_ALGORITHM -i $file -o $OUTPUT_REAL_DATA_FOURIER_ZCURVE_DIRECTORY/$archive.csv -l real -r $fourier_number 1>/dev/null
					;;
				esac
				echo -e "Extracting...\t$group\t$method\t$archive.csv"
			done
		else
			echo -e "Grupo de snoRNAs não reconhecido."
			exit 0
		fi
		;;
	"complex")
		if [ $group = 'cdbox' ]; then
			for file in $CD_BOX_DIRECTORY; do
				archive=$(echo -e $file | cut -f3 -d "/" | cut -f1 -d ".")
				python3 $COMPLEX_ALGORITHM -i $file -o $OUTPUT_CDBOX_EXTRACT_COMPLEX_DIRECTORY/$archive.csv -l cdbox -k 3 -t 10 1>/dev/null
				echo -e "Negative sample\t$group\t$method\t$archive.csv\n"
			done
		elif [ $group = 'hacabox' ]; then
			for file in $HACA_BOX_DIRECTORY; do
				archive=$(echo -e $file | cut -f3 -d "/" | cut -f1 -d ".")
				python3 $COMPLEX_ALGORITHM -i $file -o $OUTPUT_HACABOX_EXTRACT_COMPLEX_DIRECTORY/$archive.csv -l hacabox -k 3 -t 10 1>/dev/null
				echo -e "Extracting...\t$group\t$method\t$archive.csv"
			done
		elif [ $group = 'negative' ]; then
			archive="negative_complex"
			python3 $COMPLEX_ALGORITHM -i $NEGATIVE_FILE -o $OUTPUT_CDBOX_NEGATIVE_EXTRACT_COMPLEX_DIRECTORY/$archive.csv -l negative -k 3 -t 10 1>/dev/null
			python3 $COMPLEX_ALGORITHM -i $NEGATIVE_FILE -o $OUTPUT_HACABOX_NEGATIVE_EXTRACT_COMPLEX_DIRECTORY/$archive.csv -l negative -k 3 -t 10 1>/dev/null
			echo -e "$group\t$method\t$archive.csv"
		elif [ $group = 'real' ]; then
			for file in $REAL_DATA_DIRECTORY; do
				archive=$(echo -e $file | cut -f3 -d "/" | cut -f1 -d ".")
				python3 $COMPLEX_ALGORITHM -i $file -o $OUTPUT_REAL_DATA_COMPLEX_DIRECTORY/$archive.csv -l real -k 3 -t 10 1>/dev/null
				echo -e "Extracting...\t$group\t$method\t$archive.csv"
			done
		else
			echo -e "Grupo de snoRNAs não reconhecido."
			exit 0
		fi

		;;
	"entropy")
		if [ $group = 'cdbox' ]; then
			for file in $CD_BOX_DIRECTORY; do
				archive=$(echo -e $file | cut -f3 -d "/" | cut -f1 -d ".")
				if [ $entropy_choice = 'shannon' ]; then
					python3 $ENTROPY_ALGORITHM -i $file -o $OUTPUT_CDBOX_EXTRACT_ENTROPY_DIRECTORY/Shannon/$archive.csv -l cdbox -k 2 -e Shannon 1>/dev/null
				elif [ $entropy_choice = 'tsallis' ]; then
					python3 $ENTROPY_ALGORITHM -i $file -o $OUTPUT_CDBOX_EXTRACT_ENTROPY_DIRECTORY/Tsallis/$archive.csv -l cdbox -k 2 -e Tsallis 1>/dev/null
				else
					echo -e "Escolha uma entropia adequada [shannon|tsallis]"
					exit 0
				fi
				echo -e "Extracting...\t$group\t$method\t$entropy_choice\t$archive.fasta"
			done
		elif [ $group = 'hacabox' ]; then
			for file in $HACA_BOX_DIRECTORY; do
				archive=$(echo -e $file | cut -f3 -d "/" | cut -f1 -d ".")
				if [ $entropy_choice = 'shannon' ]; then
					python3 $ENTROPY_ALGORITHM -i $file -o $OUTPUT_HACABOX_EXTRACT_ENTROPY_DIRECTORY/Shannon/$archive.csv -l hacabox -k 2 -e Shannon 1>/dev/null
				elif [ $entropy_choice = 'tsallis' ]; then
					python3 $ENTROPY_ALGORITHM -i $file -o $OUTPUT_HACABOX_EXTRACT_ENTROPY_DIRECTORY/Tsallis/$archive.csv -l hacabox -k 2 -e Tsallis 1>/dev/null
				else
					echo -e "Tipo de entropia não identificada. Escolha uma das duas opções: [shannon|tsallis]"
					exit 0
				fi
				echo -e "Extracting...\t$group\t$method\t$entropy_choice\t$archive.fasta"
			done
		elif [ $group = 'negative' ]; then
			if [ $entropy_choice = 'shannon' ]; then
				archive="negative_shannon"
				python3 $ENTROPY_ALGORITHM -i $NEGATIVE_FILE -o $OUTPUT_CDBOX_NEGATIVE_EXTRACT_ENTROPY_DIRECTORY/Shannon/$archive.csv -l negative -k 2 -e Shannon 1>/dev/null
				python3 $ENTROPY_ALGORITHM -i $NEGATIVE_FILE -o $OUTPUT_HACABOX_NEGATIVE_EXTRACT_ENTROPY_DIRECTORY/Shannon/$archive.csv -l negative -k 2 -e Shannon 1>/dev/null
			elif [ $entropy_choice = 'tsallis' ]; then
				archive="negative_tsallis"
				python3 $ENTROPY_ALGORITHM -i $NEGATIVE_FILE -o $OUTPUT_CDBOX_NEGATIVE_EXTRACT_ENTROPY_DIRECTORY/Tsallis/$archive.csv -l negative -k 2 -e Tsallis 1>/dev/null
				python3 $ENTROPY_ALGORITHM -i $NEGATIVE_FILE -o $OUTPUT_HACABOX_NEGATIVE_EXTRACT_ENTROPY_DIRECTORY/Tsallis/$archive.csv -l negative -k 2 -e Tsallis 1>/dev/null
			else
				echo -e "Tipo de entropia não identificada. Escolha uma das duas opções: [shannon|tsallis]"
				exit 0
			fi
			echo -e "$group\t$method\t$entropy_choice\t$archive.csv"
		elif [ $group = 'real' ]; then
			for file in $REAL_DATA_DIRECTORY; do
				archive=$(echo -e $file | cut -f3 -d "/" | cut -f1 -d ".")
				if [ $entropy_choice = 'shannon' ]; then
					python3 $ENTROPY_ALGORITHM -i $file -o $OUTPUT_REAL_DATA_ENTROPY_DIRECTORY/Shannon/$archive.csv -l real -k 2 -e Shannon 1>/dev/null
				elif [ $entropy_choice = 'tsallis' ]; then
					python3 $ENTROPY_ALGORITHM -i $file -o $OUTPUT_REAL_DATA_ENTROPY_DIRECTORY/Tsallis/$archive.csv -l real -k 2 -e Tsallis 1>/dev/null
				else
					echo -e "Tipo de entropia não identificada. Escolha uma das duas opções: [shannon|tsallis]"
					exit 0
				fi
				echo -e "Extracting...\t$group\t$method\t$entropy_choice\t$archive.fasta"
			done
		else
			echo -e "Grupo de snoRNAs não reconhecido."
			exit 0
		fi
		;;
	*)
		echo -e "Método de extração de features não reconhecido"
		exit 0
		;;
	esac
	echo -e "Extração concluída!\n"
}

extract_all_positives() {
	extract "cdbox" "fourier" "3"
	extract "cdbox" "fourier" "2"
	extract "cdbox" "complex"
	extract "cdbox" "entropy" "shannon"
	extract "cdbox" "entropy" "tsallis"
	extract "hacabox" "fourier" "3"
	extract "hacabox" "fourier" "2"
	extract "hacabox" "complex"
	extract "hacabox" "entropy" "shannon"
	extract "hacabox" "entropy" "tsallis"
	echo -e "Todas as extraçoes no conjunto positivo foram feitas!"
}

extract_all_negatives() {
	extract "negative" "fourier" "3"
	extract "negative" "fourier" "2"
	extract "negative" "complex"
	extract "negative" "entropy" "shannon"
	extract "negative" "entropy" "tsallis"
	echo -e "Todas as extraçoes no conjunto negativo foram feitas!"
}

extract_all_real() {
	extract "real" "fourier" "3"
	extract "real" "fourier" "2"
	extract "real" "complex"
	extract "real" "entropy" "shannon"
	extract "real" "entropy" "tsallis"
	echo -e "Todas as extraçoes no conjunto real foram feitas!"
}

if [ "$1" = "clean" ]; then
	read -p "Limpar o conjunto positivo, negativo ou real? (p/n/r): " response
	if [ "$response" = "p" ]; then
		clean_positive
	elif [ "$response" = "n" ]; then
		clean_negative
	elif [ "$response" = "r" ]; then
		clean_real_data
	else
		echo -e "Por favor, digite apenas 'p', 'n' ou 'r'"
		exit 0
	fi
	echo -e "Todos os arquivos que continham as features das sequências foram removidos"
elif [ "$1" = "all" ]; then
	read -p "Extrair o conjunto positivo, negativo ou real? (p/n/r): " response
	if [ "$response" = "p" ]; then
		extract_all_positives
	elif [ "$response" = "n" ]; then
		extract_all_negatives
	elif [ "$response" = "r" ]; then
		extract_all_real
	else
		echo -e "Por favor, digite apenas 'p', 'n' ou 'r'"
		exit 0
	fi
elif [ $# -le 1 ]; then
	echo -e "Grupo de snoRNAs ou método de extração de features não reconhecido.\n"
	echo -e "Caso queira remover todos os arquivos gerados pela extração de features, rode o commando: ./feature_extraction.sh clean"
	echo -e "Caso queira extrair todas as caracteristicas de ambas classes gerados pela extração de features, rode o commando: ./feature_extraction.sh all"
	echo -e "Uso: ./feature_extraction.sh [cdbox|hacabox|negative|real] [fourier|complex|entropy] [fourier_representation]\n"
	echo -e "Escolha o mapeamento numérico se a representação do Mapeamento de Fourier foi escolhida:\n\t1 = Binary\n\t2 = Z-curve\n\t3 = Real\n\t4 = Integer\n\t5 = EIIP\n\t6 = Complex Number\n\t7 = Atomic Number"
	echo -e "Escolha a entropia adequada se a representação for entropia:\n\tShannon\n\tTsallis\n"
	exit 0
else
	extract $1 $2 $3
fi
