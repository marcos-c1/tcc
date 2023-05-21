import pandas as pd
from math import sqrt 
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
        #le = preprocessing.LabelEncoder()

        changeLabel = lambda x: [1 if label == 'cdbox' or label == 'hacabox' else 0 for label in x]
        # Get the label itself by float number decoding
        data['label'] = changeLabel(data['label'].tolist()) 

        # Target label (cdbox or hacabox as float numbers)
        y = data['label']
        return X, y

def plotGraph(obj, y_test, predictions, cm_arr):
    plt.figure(figsize=(10, 7))
    cm = getConfusionMatrix(obj, y_test, predictions, cm_arr)
    ax = sn.heatmap(cm, annot=True, fmt='d')
    ax.set(xlabel='Predicted', ylabel='Labels', title=obj.method)
    plt.savefig(f'./imgs/{obj.method}_{obj.group}')

def getConfusionMatrix(obj, y_test, predictions, tp_arr):
    cm = confusion_matrix(y_test, predictions)
    tn, fp, fn, tp = cm.ravel()
    tp_arr.append({'class': obj.group, 'method': obj.method, 'tn': tn, 'fp': fp, 'fn': fn, 'tp': tp})
    print(f'{obj.group}\t{obj.method}\t{cm.ravel()}')
    return cm

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

#def predictModel(loadedModel):


def average(tp_arr):
    sum_n = 0
    for i in tp_arr:
        sum_n += i['tp']
    return sum_n / len(tp_arr)
        
def dp(tp_arr):
    avg = average(tp_arr)
    sum_n = 0
    for i in tp_arr:
        sum_n += pow(i['tp'] - avg, 2)
    return sqrt(sum_n / len(tp_arr)) 

def saveModel(save_file, clf):
    cd = getcwd()
    file = open(f'{cd}/models/{save_file}', "wb")
    pickle.dump(clf, file)
    file.close()


def loadModel(save_file):
    loaded_model = pickle.load(open(save_file, "rb"))
    return loaded_model
