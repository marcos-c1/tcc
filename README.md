![Python](https://img.shields.io/badge/python-v3.10-blue)
![Dependencies](https://img.shields.io/badge/dependencies-up%20to%20date-brightgreen.svg)
![Status](https://img.shields.io/badge/status-up-brightgreen)

# Feature extraction in snoRNAs using mathematical approach 

The number of biological sequences available has increased significantly in recent years due to several scientific discoveries about the genetic code that composes living beings, creating a huge volume of data. Consequently, new computational methods were shaped to analyze and extract information from these genetic sequences. The learning methods (AM) have shown wide applicability in bioinformatics and proven to be essential for the selection of useful information from the secondary structures of genomes by perfecting his techniques based on the mathematical archetype in contrast to the model biological standard of analysis. Therefore, this work aims to analyze the mathematical models for feature extraction, mainly extraction techniques that were verified efficient in classifying C/D box snoRNAs in vertebrate and invertebrate organisms with an F-score of 98% and in classifier snoRNAs as H/ACA box with an F-score of 95%. Algorithms such as Fourier Numerical Transformation and Complex Networks reached a greater than 90% rate in classifying C/D box and H/ACA box snoRNAs in genetics sequences of Homo Sapiens, Platypus, Gallus gallus, Nematodes, Drosophila and Leishmania proving to be promising in non-coding RNA (ncRNA) molecules of the class of snoRNAs.

## Author

* Marcos Bezerra Campos 
* **Email:** marcos.b.campos14@gmail.com

## Dependencies

- Python (>=3.10.6)
- Pip (>= 22.0.2)
- Biopython
- Igraph
- NumPy
- Pandas
- SciPy
- Scikit-Learn
- Matplotlib
- Seaborn
- Requests

## Mathematical Approaches used in Extraction 

* Numerical Mapping with Fourier Transform (Real and Z-Curve)
* Entropy (Tsallis and Shannon)
* Complex Networks

## Description of scripts and classifier 

* In folder *scripts*
    - feature\_extraction.sh: Used to automate feature extraction stage from all samples (positive, negative, validation data)  
    - extract\_sequences\_count.sh: Used to extract the amount of sequences from all samples 
    - extract\_average\_data.py: Used to extract the average data to be extracted of each family defined in pre-processing phase. The objective is to balance the positive and negative sample with similar amount of sequences. 
    - rfam.py: Used to make a get request from rfam repository which will get the family from snoRNAs family and output to a file with fasta extension 
    - shuffle.py: Used to shuffle all pyrimidines and purines based on a parameter known as "k" (similar to the number of codons in a sequence), this parameter will shuffle the sequence until k-th codon

* In folder *classifier*
    - train.py: The learning algorithm itself. Used to train and test the data across all samples including the validation dataset which has been extracted.
    - utils.py: Utility file helper with auxiliary functions to plot graph, calculate the deviation, standard deviation, arithmetic average, etc.

## Setting up 

```bash
$ git clone https://github.com/marcos-c1/tcc 
$ cd tcc/classifier
$ pip install -r requirements.txt
$ apt-get -y install python3-igraph
```

## Graduation Project 

The monography can be found named as TCC.pdf.
