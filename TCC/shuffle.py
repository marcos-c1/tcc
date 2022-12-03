import random
from toolz import compose, curry, concat 
import sys

def shuffle(sequence, times, order):
    seq = sequence
    for i in range(times):
        kmers = [seq[i:i + order] for i in range(0, len(seq), order)]
        random.shuffle(kmers)
        seq_out = ''.join(kmers)
        print(seq_out)
        
if __name__ == "__main__":
    sequence = 'GCCGAC----UACUUAGUC--CAAGGA--UCAUUGCU-AU-AGUA-UUU--GUGAU--GUUUUAAUU-GUUAUAAACA--AAACAG---AUUUU------CAAAAGUGAUGAUGAA---CA-GACGC-UGCUCU--AAAUUGAAUUGUUUUC--GAAAUUUUU-------------------CC---A-CCUUCUU-AAGGAAAAU---------------------UGUAAAACUUUCCG-AAAAAUUACAUGAUAUU-----AUUUUGUUGGCAAAUUGAA----UUUUUAUUUUUUU------UGC--------CAAUCAUAAAUA--AAUGAGCUCGCGUC--CGCUGAACUUAC'
    shuffle(sequence, times=1, order=2)
