from sklearn import datasets
from sklearn.model_selection import train_test_split
from sklearn.metrics import f1_score
from sklearn import preprocessing
from sklearn.ensemble import RandomForestClassifier
import numpy as np
import pandas as pd
from DecisionTree import DecisionTree

# Read all .csv files from each group of snoRNAs
data = pd.read_csv('../Feature_Extraction_CDBOX/Fourier_Real/ACEA_U3.csv')
X = data.drop(columns=['nameseq', 'label'], axis=1)
features = X.columns
print(features)

# Change label cdbox and hacabox to float numbers
le = preprocessing.LabelEncoder()
data['label'] = le.fit_transform(data['label'])
y = data['label']
# Example of reading a breast cancer dataset
#data = datasets.load_breast_cancer()
#X, y = data.data, data.target 

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=1234)
clf = RandomForestClassifier(max_depth=10)
clf.fit(X_train, y_train)
predictions = clf.predict(X_test)


def accuracy(y_test, y_pred):
    return np.sum(y_test == y_pred) / len(y_test)

acc = accuracy(y_test, predictions)
print(f'Score pelo accuracy: {acc}')
print(f'F-score: {f1_score(y_test, predictions)}')
