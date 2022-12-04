import sys
        
if __name__ == "__main__":
    it = 0 
    media = int(sys.argv[1])
    data = ''
    sequences = dict()
    file = open(r'./CD-BOX/ACEA_U3.fasta') 
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
    for key, value in sequences.items():
        print(f'{key}{value}\n', end='')
