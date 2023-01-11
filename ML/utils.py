import pandas as pd
import numpy as np 
import pickle
from sklearn import preprocessing
from sklearn.metrics import confusion_matrix
import matplotlib.pyplot as plt
import seaborn as sn
from os import getcwd

class CSVData:
    def __init__(self, group, method) -> None:
        self.group = group
        self.method = method

    def _getDir(self):
        if (self.method == 'fourier_real'):
            return f'./data/Fourier_Real/{self.group}_fourier_real_data.csv'
        elif (self.method == 'fourier_zcurve'):
            return f'./data/Fourier_ZCurve/{self.group}_fourier_zcurve_data.csv'
        elif (self.method == 'entropy_shannon'):
            return f'./data/Entropy/Shannon/{self.group}_entropy_shannon_data.csv'
        elif (self.method == 'entropy_tsallis'):
            return f'./data/Entropy/Tsallis/{self.group}_entropy_tsallis_data.csv'
        elif (self.method == 'complex'):
            return f'./data/Complex/{self.group}_complex_data.csv'
        else:
            raise Exception("Diretório não encontrado")

    def getXY(self): 
        data = pd.read_csv(self._getDir())
        X = data.drop(columns=['nameseq', 'label'], axis=1)

        # Can't exceed the maximum value of a float32 type ~ 3.4028235 × 10E38
        X = X[X < 3E38]

        features = X.columns

        # Doesnt accept NaN
        X = np.nan_to_num(X, copy=False, nan=0.0, posinf=0.0, neginf=0.0)

        # Change label cdbox and hacabox to float numbers
        le = preprocessing.LabelEncoder()

        # Get the label itself by float number decoding
        data['label'] = le.fit_transform(data['label'])

        # Get the labels name
        self.labels = np.take(le.inverse_transform([0, 1]), 0)
        # Target label (cdbox or hacabox as float numbers)
        y = data['label']
        return X, y

    

def plotGraph(obj, y_test, predictions):
    cm = confusion_matrix(y_test, predictions)
    plt.figure(figsize=(10, 7))
    ax = sn.heatmap(cm, annot=True, fmt='d')
    ax.set(xlabel='Predicted', ylabel='Labels', title=obj.method)
    plt.savefig(f'./imgs/{obj.method}_{obj.group}')

def createMethods(group):
    fr = CSVData(group, 'fourier_real')
    fzc = CSVData(group, 'fourier_zcurve')
    es = CSVData(group, 'entropy_shannon')
    et = CSVData(group, 'entropy_tsallis')
    cmp = CSVData(group, 'complex')

    methods = dict()

    methods['fourier_real'] = fr
    methods['fourier_zcurve'] = fzc
    methods['entropy_shannon'] = es
    methods['entropy_tsallis'] = et
    methods['complex'] = cmp

    return methods

def accuracy(y_test, y_pred):
    return np.sum(y_test == y_pred) / len(y_test)

def saveModel(save_file, clf):
    cd = getcwd()
    file = open(f'{cd}/models/{save_file}', "wb")
    pickle.dump(clf, file)
    file.close()


def loadModel(save_file):
    loaded_model = pickle.load(open(save_file, "rb"))
    return loaded_model
