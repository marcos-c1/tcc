#!/bin/bash

FOURIER_ALGORITHM="FeatureExtraction/methods/FourierClass.py"
ENTROPY_ALGORITHM="FeatureExtraction/methods/EntropyClass.py"
COMPLEX_ALGORITHM="FeatureExtraction/methods/ComplexNetworksClass.py"

# Input directory
CD_BOX_DIRECTORY="./CD-BOX-average/*.fasta"
HACA_BOX_DIRECTORY="./HACA-BOX-average/*.fasta"

# Output directory for CD-BOX class 
OUTPUT_CDBOX_EXTRACT_FOURIER_REAL_DIRECTORY="./Feature_Extraction_CDBOX/Fourier_Real"
OUTPUT_CDBOX_EXTRACT_FOURIER_ZCURVE_DIRECTORY="./Feature_Extraction_CDBOX/Fourier_ZCurve"
OUTPUT_CDBOX_EXTRACT_ENTROPY_DIRECTORY="./Feature_Extraction_CDBOX/Entropy"
OUTPUT_CDBOX_EXTRACT_COMPLEX_DIRECTORY="./Feature_Extraction_CDBOX/Complex"

# Output directory for HACA-BOX class 
OUTPUT_HACABOX_EXTRACT_FOURIER_REAL_DIRECTORY="./Feature_Extraction_HACABOX/Fourier_Real"
OUTPUT_HACABOX_EXTRACT_FOURIER_ZCURVE_DIRECTORY="./Feature_Extraction_HACABOX/Fourier_ZCurve"
OUTPUT_HACABOX_EXTRACT_ENTROPY_DIRECTORY="./Feature_Extraction_HACABOX/Entropy"
OUTPUT_HACABOX_EXTRACT_COMPLEX_DIRECTORY="./Feature_Extraction_HACABOX/Complex"

# Output directory for Negative sample of CD-BOX class 
OUTPUT_CDBOX_NEGATIVE_EXTRACT_FOURIER_REAL_DIRECTORY="./Feature_Extraction_CDBOX_Negative/Fourier_Real"
OUTPUT_CDBOX_NEGATIVE_EXTRACT_FOURIER_ZCURVE_DIRECTORY="./Feature_Extraction_CDBOX_Negative/Fourier_ZCurve"
OUTPUT_CDBOX_NEGATIVE_EXTRACT_ENTROPY_DIRECTORY="./Feature_Extraction_CDBOX_Negative/Entropy"
OUTPUT_CDBOX_NEGATIVE_EXTRACT_COMPLEX_DIRECTORY="./Feature_Extraction_CDBOX_Negative/Complex"

# Output directory for Negative sample of HACA-BOX class
OUTPUT_HACABOX_NEGATIVE_EXTRACT_FOURIER_REAL_DIRECTORY="./Feature_Extraction_HACABOX_Negative/Fourier_Real"
OUTPUT_HACABOX_NEGATIVE_EXTRACT_FOURIER_ZCURVE_DIRECTORY="./Feature_Extraction_HACABOX_Negative/Fourier_ZCurve"
OUTPUT_HACABOX_NEGATIVE_EXTRACT_ENTROPY_DIRECTORY="./Feature_Extraction_HACABOX_Negative/Entropy"
OUTPUT_HACABOX_NEGATIVE_EXTRACT_COMPLEX_DIRECTORY="./Feature_Extraction_HACABOX_Negative/Complex"

# Negative file
NEGATIVE_FILE="./negative_sample.fasta"

SNORNA_GROUP=$1
EXTRACTION_METHOD=$2
FOURIER_REPRESENTATION=$3

clean()
{
	rm -rf $OUTPUT_CDBOX_EXTRACT_FOURIER_REAL_DIRECTORY/*.csv
	rm -rf $OUTPUT_CDBOX_EXTRACT_FOURIER_ZCURVE_DIRECTORY/*.csv
	rm -rf $OUTPUT_CDBOX_EXTRACT_ENTROPY_DIRECTORY/*.csv
	rm -rf $OUTPUT_CDBOX_EXTRACT_COMPLEX_DIRECTORY/*.csv

	rm -rf $OUTPUT_HACABOX_EXTRACT_FOURIER_REAL_DIRECTORY/*.csv
	rm -rf $OUTPUT_HACABOX_EXTRACT_FOURIER_ZCURVE_DIRECTORY/*.csv
	rm -rf $OUTPUT_HACABOX_EXTRACT_ENTROPY_DIRECTORY/*.csv
	rm -rf $OUTPUT_HACABOX_EXTRACT_COMPLEX_DIRECTORY/*.csv
}

extract()
{
	local group=$1
	local method=$2
	local fourier_number=$3
	local entropy_choice=$3
	local algorithm
	local output_directory

	case $method in
		"fourier")
			if [ -z $fourier_number ]; then
				printf '%s\n' "Escolha o mapeamento numérico desejado\n\t1 = Binary\n\t2 = Z-curve\n\t3 = Real\n\t4 = Integer\n\t5 = EIIP\n\t6 = Complex Number\n\t7 = Atomic Number"
				exit 0
			fi
			if [ $group = 'cdbox' ]; then
				for file in $CD_BOX_DIRECTORY 
				do 
					archive=$(printf '%s\n' $file | cut -f3 -d "/" | cut -f1 -d ".")
					case $fourier_number in
						"3")
							python3 $FOURIER_ALGORITHM -i $file -o $OUTPUT_CDBOX_EXTRACT_FOURIER_REAL_DIRECTORY/$archive.csv -l cdbox -r $fourier_number 1>/dev/null 
							;;
						"2")
							python3 $FOURIER_ALGORITHM -i $file -o $OUTPUT_CDBOX_EXTRACT_FOURIER_ZCURVE_DIRECTORY/$archive.csv -l cdbox -r $fourier_number 1>/dev/null 
							;;
					esac	
					printf '%s\n' "Negative sample\t$group\t$method\t$archive.csv"
				done
			elif [ $SNORNA_GROUP = 'hacabox' ]; then
				for file in $HACA_BOX_DIRECTORY
				do
					archive=$(printf '%s\n' $file | cut -f3 -d "/" | cut -f1 -d ".")
					case $fourier_number in
						"3")
							python3 $FOURIER_ALGORITHM -i $file -o $OUTPUT_HACABOX_EXTRACT_FOURIER_REAL_DIRECTORY/$archive.csv -l hacabox -r $fourier_number 1>/dev/null 
							;;
						"2")
							python3 $FOURIER_ALGORITHM -i $file -o $OUTPUT_HACABOX_EXTRACT_FOURIER_ZCURVE_DIRECTORY/$archive.csv -l hacabox -r $fourier_number 1>/dev/null 
							;;
					esac	
					printf '%s\n' "$group\t$method\t$fourier_number\t$archive.fasta"
				done
			elif [ $SNORNA_GROUP = 'negative' ]; then
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
				printf '%s\n' "$group\t$method\t$fourier_number\t$archive.csv"
			else
				printf '%s\n' "Grupo de snoRNAs não reconhecido."
				exit 0
			fi 
			;;
		"complex")
				if [ $group = 'cdbox' ]; then
					for file in $CD_BOX_DIRECTORY 
					do 
						archive=$(printf '%s\n' $file | cut -f3 -d "/" | cut -f1 -d ".")
						python3 $COMPLEX_ALGORITHM -i $file -o $OUTPUT_CDBOX_EXTRACT_COMPLEX_DIRECTORY/$archive.csv -l cdbox -k 3 -t 10 1>/dev/null 
						printf '%s\n' "Negative sample\t$group\t$method\t$archive.csv"
					done
				elif [ $SNORNA_GROUP = 'hacabox' ]; then
					for file in $HACA_BOX_DIRECTORY
					do
						archive=$(printf '%s\n' $file | cut -f3 -d "/" | cut -f1 -d ".")
						python3 $COMPLEX_ALGORITHM -i $file -o $OUTPUT_HACABOX_EXTRACT_COMPLEX_DIRECTORY/$archive.csv -l hacabox -k 3 -t 10 1>/dev/null 
						printf '%s\n' "Negative sample\t$group\t$method\t$archive.csv"
					done
				elif [ $SNORNA_GROUP = 'negative' ]; then
					archive="negative_complex"
					python3 $COMPLEX_ALGORITHM -i $NEGATIVE_FILE -o $OUTPUT_CDBOX_NEGATIVE_EXTRACT_COMPLEX_DIRECTORY/$archive.csv -l negative -k 3 -t 10 1>/dev/null
					python3 $COMPLEX_ALGORITHM -i $NEGATIVE_FILE -o $OUTPUT_HACABOX_NEGATIVE_EXTRACT_COMPLEX_DIRECTORY/$archive.csv -l negative -k 3 -t 10 1>/dev/null
					printf '%s\n' "$group\t$method\t$archive.csv"
				else	
					printf '%s\n' "Grupo de snoRNAs não reconhecido."
					exit 0
				fi 

			;;
		"entropy")
			if [ $group = 'cdbox' ]; then
				for file in $CD_BOX_DIRECTORY 
				do 
					archive=$(printf '%s\n' $file | cut -f3 -d "/" | cut -f1 -d ".")
					if [ $entropy_choice = 'shannon' ]; then
						python3 $ENTROPY_ALGORITHM -i $file -o $OUTPUT_CDBOX_EXTRACT_ENTROPY_DIRECTORY/Shannon/$archive.csv -l cdbox -k 2 -e Shannon 1>/dev/null 
					elif [ $entropy_choice = 'tsallis' ]; then
						python3 $ENTROPY_ALGORITHM -i $file -o $OUTPUT_CDBOX_EXTRACT_ENTROPY_DIRECTORY/Tsallis/$archive.csv -l cdbox -k 2 -e Tsallis 1>/dev/null 
					else
						printf '%s\n' "Escolha uma entropia adequada [shannon|tsallis]"
						exit 0
					fi
					printf '%s\n' "$group\t$method\t$entropy_choice\t$archive.fasta"
				done
			elif [ $SNORNA_GROUP = 'hacabox' ]; then
				for file in $HACA_BOX_DIRECTORY
				do
					archive=$(printf '%s\n' $file | cut -f3 -d "/" | cut -f1 -d ".")
					if [ $entropy_choice = 'shannon' ]; then
						python3 $ENTROPY_ALGORITHM -i $file -o $OUTPUT_HACABOX_EXTRACT_ENTROPY_DIRECTORY/Shannon/$archive.csv -l hacabox -k 2 -e Shannon 1>/dev/null 
					elif [ $entropy_choice = 'tsallis' ]; then
						python3 $ENTROPY_ALGORITHM -i $file -o $OUTPUT_HACABOX_EXTRACT_ENTROPY_DIRECTORY/Tsallis/$archive.csv -l hacabox -k 2 -e Tsallis 1>/dev/null 
					else
						printf '%s\n' "Tipo de entropia não identificada. Escolha uma das duas opções: [shannon|tsallis]"
						exit 0
					fi
					printf '%s\n' "$group\t$method\t$entropy_choice\t$archive.fasta"
				done
			elif [ $SNORNA_GROUP = 'negative' ]; then
				if [ $entropy_choice = 'shannon' ]; then
					archive="negative_shannon"
					python3 $ENTROPY_ALGORITHM -i $NEGATIVE_FILE -o $OUTPUT_CDBOX_NEGATIVE_EXTRACT_ENTROPY_DIRECTORY/Shannon/$archive.csv -l negative -k 2 -e Shannon 1>/dev/null 
					python3 $ENTROPY_ALGORITHM -i $NEGATIVE_FILE -o $OUTPUT_HACABOX_NEGATIVE_EXTRACT_ENTROPY_DIRECTORY/Shannon/$archive.csv -l negative -k 2 -e Shannon 1>/dev/null 
				elif [ $entropy_choice = 'tsallis' ]; then
					archive="negative_tsallis"
					python3 $ENTROPY_ALGORITHM -i $NEGATIVE_FILE -o $OUTPUT_CDBOX_NEGATIVE_EXTRACT_ENTROPY_DIRECTORY/Tsallis/$archive.csv -l negative -k 2 -e Tsallis 1>/dev/null 
					python3 $ENTROPY_ALGORITHM -i $NEGATIVE_FILE -o $OUTPUT_HACABOX_NEGATIVE_EXTRACT_ENTROPY_DIRECTORY/Tsallis/$archive.csv -l negative -k 2 -e Tsallis 1>/dev/null 
				else
					printf '%s\n' "Tipo de entropia não identificada. Escolha uma das duas opções: [shannon|tsallis]"
					exit 0
				fi
				printf '%s\n' "$group\t$method\t$entropy_choice\t$archive.csv"
			else	
				printf '%s\n' "Grupo de snoRNAs não reconhecido."
				exit 0
			fi 
			;;
		*)
			printf '%s\n' "Método de extração de features não reconhecido"
			exit 0
			;;
	esac
	printf '%s\n' "Extração concluída!\n"
}

if [ "$1" = "clean" ]; then
	clean
	printf '%s\n' "Todos os arquivos que continham as features das sequências foram removidos"
	exit 0
fi
# ASSERT length of args > 1 
if [ $# -le 1 ]; then 
	printf '%s\n' "Grupo de snoRNAs ou método de extração de features não reconhecido."
	printf '%s\n' "Caso queira remover todos os arquivos gerados pela extração de features rode o commando: ./feature_extraction.sh clean"
	printf '%s\n' "Uso: ./feature_extraction.sh [cdbox|hacabox|negative] [fourier|complex|entropy] [fourier_representation]" 
	printf '%s\n' "Escolha o mapeamento numérico se a representação do Mapeamento de Fourier foi escolhida:\n\t1 = Binary\n\t2 = Z-curve\n\t3 = Real\n\t4 = Integer\n\t5 = EIIP\n\t6 = Complex Number\n\t7 = Atomic Number"
	printf '%s\n' "Escolha a entropia adequada se a representação for entropia:\n\tShannon\n\tTsallis\n"
	exit 0
fi

extract $SNORNA_GROUP $EXTRACTION_METHOD $FOURIER_REPRESENTATION 
