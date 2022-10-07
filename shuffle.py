import random

def shuffle(sequence, times=None, order=None):
    header, seq = sequence
    for i in range(times):
        kmers = [seq[i:i + order] for i in range(0, len(seq), order)]
        random.shuffle(kmers)
        seq_out = ''.join(kmers)
        yield header, seq_out
        
if __name__ == "__main__":
    sequence = []
    shuffle(sequence, 5, 2)
