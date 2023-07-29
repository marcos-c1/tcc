import json 
import requests

f = open("../misc/negative-group.txt", "r")
for rna_id in f:
    rna_id = rna_id.replace('\n', '')
    data = requests.get(f'https://rfam.org/family/{rna_id}/alignment/fasta').text   
    with open(rna_id + '.fasta', 'w') as output:
        output.write(data)
        output.close()
f.close()
