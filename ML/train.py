from sklearn import datasets
from sklearn.metrics.pairwise import effective_n_jobs
from sklearn.model_selection import train_test_split
from sklearn.metrics import f1_score 
from sklearn.ensemble import RandomForestClassifier
import time
import numpy as np
import pandas as pd
from utils import *

def train(snoRNA_class):
    efficacy = [] 
    methods = []
    measure_time = []
    labels = []
    for key, value in snoRNA_class.items(): 
        initial_time = time.time()
        X, y = value.getXY()
        X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2)
        clf = RandomForestClassifier(max_depth=10)
        clf.fit(X_train, y_train)
        predictions = clf.predict(X_test)
        efficacy.append(str(f1_score(y_test, predictions) * 100.0) + '%') 
        labels.append(value.labels)
        methods.append(key)
        end_time = time.time()
        measure_time.append(str(end_time - initial_time) + 's')

    return efficacy, methods, measure_time, labels 

if __name__ == '__main__':
    cd_box = createMethods('cd_box')
    haca_box = createMethods('haca_box')

    ef1, m1, mt1, l1 = train(cd_box)
    ef2, m2, mt2, l2 = train(haca_box)

    efficacy = ef1 + ef2
    labels = l1 + l2
    methods = m1 + m2
    measure_time = mt1 + mt2

    table = pd.DataFrame({'classe': labels, 'metodo': methods, 'eficacia_rf': efficacy, 'tempo_corrido': measure_time})
    table.to_csv('accuracy.csv', index=False)
