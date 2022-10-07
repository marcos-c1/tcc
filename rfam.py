import json 
import requests

f = open("cd-box.txt", "r")
for rna_id in f:
    rna_id = rna_id.replace('\n', '')
    data = requests.get(f'https://rfam.xfam.org/family/{rna_id}/alignment/fasta').text   
    with open(rna_id + '.txt', 'w') as output:
        output.write(data)
        output.close()
f.close()
#
