import random
import os
import argparse
import sys

def shuffle(sequence, times, order):
    seq = sequence
    sequences = []
    for i in range(times):
        kmers = [seq[i:i + order] for i in range(0, len(seq), order)]
        random.shuffle(kmers)
        seq_out = ''.join(kmers)
        sequences.append(seq_out)
    return sequences

def getSequence(dirname):
    directory = os.listdir(f'../average_data/{dirname}/')
    negative = dict()
    key = ''
    for filename in directory:
        file = open(f'../average_data/{dirname}/{filename}')
        lines = file.readlines()
        for line in lines:
            if(line[0] == '>'):
                key = line[1:].strip()                
            else:
                if key not in negative and key != '':
                    negative[key] = ''
                negative[key] += line.strip().replace('-', '')
        file.close()
        file_output = open(f'../average_data/{dirname}_negative/{filename}', 'w')
        for key, value in negative.items():
            sequences = shuffle(value, times=3, order=2)
            for i in range(len(sequences)):
                file_output.write(f'>{key}_neg_{i+1}\n')
                file_output.write(f'{sequences[i]}\n')  
        negative.clear()
        file_output.close()

def joinFamilyByClass(file, group):
    haca_dirname = f'{group}_negative'
    cd_dirname = f'{group}_negative'

    haca_dir = os.listdir(f'../average_data/{haca_dirname}')
    cd_dir = os.listdir(f'../average_data/{cd_dirname}')
    negative = dict()

    if (group == 'haca_box'):
        f_out = open(f'{file}.fasta', 'w')
        for filename in haca_dir:
            f_in = open(f'../average_data/{haca_dirname}/{filename}')
            lines = f_in.readlines()
            for line in lines:
                if(line[0] == '>'):
                    key = line[1:].strip()                
                else:
                    if key not in negative:
                        negative[key] = ''
                    negative[key] += line.strip()
            f_in.close()
    
    elif (group == 'cd_box'):
        for filename in cd_dir:
            f_in = open(f'../average_data/{cd_dirname}/{filename}')
            lines = f_in.readlines()
            for line in lines:
                if(line[0] == '>'):
                    key = line[1:].strip()                
                else:
                    if key not in negative:
                        negative[key] = ''
                    negative[key] += line.strip()
            f_in.close()
    
    f_out = open(f'{file}.fasta', 'w')
    for key, value in negative.items():
        f_out.write(f'>{key}\n')
        sequences = shuffle(value, times=5, order=2)
        for i in range(len(sequences)):
            f_out.write(f'{sequences[i]}\n') 

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('-g', '--group', help='Group of snoRNAs')   
    parser.add_argument('-j', '--join', help='Join all families into one negative file sample')
    usage = 'Usage: python ' + sys.argv[0] +  ' -g <Group of snoRNAs>\n' + '-j <Output file from negative sample>\nType -h for help'
    args = parser.parse_args()
    dirname = str(args.group).lower().strip()
    join = str(args.join).lower().strip()

    if(dirname == 'cd-box' or dirname == 'cd'):
        dirname = 'cd_box'
    elif(dirname == 'haca-box' or dirname == 'haca'):
        dirname = 'haca_box'
    else:
        print(usage)
        sys.exit()

    getSequence(dirname)
    if (join != "none"):
        joinFamilyByClass(join, dirname)
