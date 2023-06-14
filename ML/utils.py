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
        # cd_box | haca_box | real
        self.group = group
        self.method = method

    def _getDir(self):
        if self.method == "fourier_real":
            return f"./data/Fourier_Real/{self.group}_fourier_real_data.csv"
        elif self.method == "fourier_zcurve":
            return f"./data/Fourier_ZCurve/{self.group}_fourier_zcurve_data.csv"
        elif self.method == "entropy_shannon":
            return f"./data/Entropy/Shannon/{self.group}_entropy_shannon_data.csv"
        elif self.method == "entropy_tsallis":
            return f"./data/Entropy/Tsallis/{self.group}_entropy_tsallis_data.csv"
        elif self.method == "complex":
            return f"./data/Complex/{self.group}_complex_data.csv"
        else:
            raise Exception("Diretório não encontrado")

    def _getOrganismDir(self, organism):
        if self.method == "fourier_real":
            return f"../extraction/Feature_Extraction_Real_Data/Fourier_Real/{organism}_{self.group}.csv"
        elif self.method == "fourier_zcurve":
            return f"../extraction/Feature_Extraction_Real_Data/Fourier_ZCurve/{organism}_{self.group}.csv"
        elif self.method == "entropy_shannon":
            return f"../extraction/Feature_Extraction_Real_Data/Entropy/Shannon/{organism}_{self.group}.csv"
        elif self.method == "entropy_tsallis":
            return f"../extraction/Feature_Extraction_Real_Data/Entropy/Tsallis/{organism}_{self.group}.csv"
        elif self.method == "complex":
            return f"../extraction/Feature_Extraction_Real_Data/Complex/{organism}_{self.group}.csv"
        else:
            print(f"{COLORS.BOLD}[DEBUG] {COLORS.ERROR}Diretório não encontrado!{COLORS.ENDC}")
            exit(-1)
        
    def getXY(self):
        data = pd.read_csv(self._getDir())
        X = data.drop(columns=["nameseq", "label"], axis=1)

        # Can't exceed the maximum value of a float32 type ~ 3.4028235 × 10E38
        X = X[X < 3e38]

        # Doesnt accept NaN
        X = np.nan_to_num(X, copy=False, nan=0.0, posinf=0.0, neginf=0.0)

        # Change label cdbox and hacabox to float numbers
        # le = preprocessing.LabelEncoder()

        changeLabel = lambda x: [
            1 if label == "cdbox" or label == "hacabox" else 0 for label in x
        ]
        # Get the label itself by float number decoding
        data["label"] = changeLabel(data["label"].tolist())

        # Target label (cdbox or hacabox as float numbers)
        y = data["label"]
        return X, y

    def getX(self, organism):
        data = pd.read_csv(self._getOrganismDir(organism))
        X = data.drop(columns=["nameseq", "label"], axis=1)
        X = X[X < 3e38]
        X = np.nan_to_num(X, copy=False, nan=0.0, posinf=0.0, neginf=0.0)
        return X

def plotGraph(obj, y_test, predictions, cm_arr):
    plt.figure(figsize=(10, 7))
    cm = getConfusionMatrix(obj, y_test, predictions, cm_arr)
    ax = sn.heatmap(cm, annot=True, fmt="d")
    ax.set(xlabel="Predicted", ylabel="Labels", title=obj.method)
    plt.savefig(f"./imgs/{obj.method}_{obj.group}")


def getConfusionMatrix(obj, y_test, predictions, tp_arr):
    cm = confusion_matrix(y_test, predictions)
    tn, fp, fn, tp = cm.ravel()
    tp_arr.append(
        {
            "class": obj.group,
            "method": obj.method,
            "tn": tn,
            "fp": fp,
            "fn": fn,
            "tp": tp,
        }
    )
    print(f"{COLORS.BOLD}[DEBUG] {COLORS.SUCCESS}{obj.group}\t{obj.method}\t{cm.ravel()}{COLORS.ENDC}")
    return cm


def createMethods(group):
    fr = CSVData(group, "fourier_real")
    fzc = CSVData(group, "fourier_zcurve")
    es = CSVData(group, "entropy_shannon")
    et = CSVData(group, "entropy_tsallis")
    cmp = CSVData(group, "complex")

    methods = dict()

    methods["fourier_real"] = fr
    methods["fourier_zcurve"] = fzc
    methods["entropy_shannon"] = es
    methods["entropy_tsallis"] = et
    methods["complex"] = cmp

    return methods

def accuracy(y_test, y_pred):
    return np.sum(y_test == y_pred) / len(y_test)

def average(tp_arr):
    sum_n = 0
    for i in tp_arr:
        sum_n += i["tp"]
    return sum_n / len(tp_arr)


def dp(tp_arr):
    avg = average(tp_arr)
    sum_n = 0
    for i in tp_arr:
        sum_n += pow(i["tp"] - avg, 2)
    return sqrt(sum_n / len(tp_arr))


def saveModel(save_file, clf):
    cd = getcwd()
    file = open(f"{cd}/models/{save_file}", "wb")
    pickle.dump(clf, file)
    file.close()


def loadModel(save_file):
    loaded_model = pickle.load(open(save_file, "rb"))
    return loaded_model

class COLORS:
    INFO = '\033[94m'
    SUCCESS = '\033[92m'
    WARNING = '\033[93m'
    ERROR = '\033[91m'
    BOLD = '\033[1m'
    ENDC = '\033[0m'
    UNDERLINE = '\033[4m'

