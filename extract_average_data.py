import sys
import os
import argparse

def extractAverageData(media=int, dirname=str) -> None:
    it = 0 
    data = ''
    sequences = dict()
    directory = os.listdir(f'./{dirname}/')
    for filename in directory:
        file = open(f'./{dirname}/{filename}') 
        lines = file.readlines()
        keys = []
        for line in lines:
            if(it == media+1):
                break
            if(line[0] == '>'):
                keys.append(line)
                if(len(keys) > 1):
                    sequences[keys[it-1]] = data
                data = ''
                it += 1
            else:
                data += line
                                                                
        file.close()
        output_file = open(f'./{dirname}-average/{filename}', 'w')
        for key, value in sequences.items():
            output_file.write(f'{key}{value}')
        output_file.close()
        sequences.clear()
        keys.clear()
        it = 0
        data = ''

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('-a', '--average', help='Average data to be extracted of each sequence')
    parser.add_argument('-g', '--group', help='Group of snoRNAs')
    args = parser.parse_args()
    media = int(args.average)
    dirname = str(args.group).lower().strip()
    if(dirname == 'cd-box' or dirname == 'cd'):
        dirname = 'CD-BOX' 
    else:
        dirname = 'HACA-BOX'
    extractAverageData(media, dirname)
