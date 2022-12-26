from sklearn import datasets
from sklearn.model_selection import train_test_split
from sklearn.metrics import f1_score, confusion_matrix
from sklearn import preprocessing
from sklearn.ensemble import RandomForestClassifier
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sn
from DecisionTree import DecisionTree

class CSVData:
    def __init__(self, method) -> None:
        self.method = method

    def _getDir(self):
        if (self.method == 'fourier_real'):
            return './data/Fourier_Real/fourier_real_data.csv'
        elif (self.method == 'fourier_zcurve'):
            return './data/Fourier_ZCurve/fourier_zcurve_data.csv'
        elif (self.method == 'entropy_shannon'):
            return './data/Entropy/Shannon/entropy_shannon_data.csv'
        elif (self.method == 'entropy_tsallis'):
            return './data/Entropy/Tsallis/entropy_tsallis_data.csv'
        elif (self.method == 'complex'):
            return './data/Complex/complex_data.csv'
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
        self.labels = le.inverse_transform([0, 1])
        # Target label (cdbox or hacabox as float numbers)
        y = data['label']
        return X, y

    

def plotGraph(cm, method):
    plt.figure(figsize=(10, 7))
    ax = sn.heatmap(cm, annot=True, fmt='d')
    ax.set(xlabel='Predicted', ylabel='Labels', title=method)
    plt.show()

def createDictMethods():
    fr = CSVData('fourier_real')
    fzc = CSVData('fourier_zcurve')
    es = CSVData('entropy_shannon')
    et = CSVData('entropy_tsallis')
    cmp = CSVData('complex')

    methods = dict()

    methods['fourier_real'] = fr
    methods['fourier_zcurve'] = fzc
    methods['entropy_shannon'] = es
    methods['entropy_tsallis'] = et
    methods['complex'] = cmp

    return methods

def accuracy(y_test, y_pred):
    return np.sum(y_test == y_pred) / len(y_test)

m = createDictMethods()
efficacy = [] 
methods = []
for key, value in m.items(): 
    X, y = value.getXY()
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2)
    clf = RandomForestClassifier(max_depth=10)
    clf.fit(X_train, y_train)
    predictions = clf.predict(X_test)
    cm = confusion_matrix(y_test, predictions)
    plotGraph(cm, value.method)
    efficacy.append(str(f1_score(y_test, predictions) * 100.0) + '%') 
    methods.append(key)

table = pd.DataFrame({'Método': methods, 'Eficácia do classificador RandomForest': efficacy})
print(table)
