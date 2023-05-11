from sklearn import datasets
from sklearn.metrics.pairwise import effective_n_jobs
from sklearn.model_selection import train_test_split
from sklearn.metrics import f1_score, fbeta_score, recall_score, precision_score, roc_auc_score 
from sklearn.ensemble import RandomForestClassifier
from datetime import datetime
import time
import numpy as np
import pandas as pd
from utils import *

def train(snoRNA_class):
    f1_scores = [] 
    recalls = []
    fbeta_scores = []
    precisions = []
    auc = []
    methods = []
    measure_time = []
    labels = []
    files = []
    dt_str = datetime.now().strftime("%d-%m-%Y_%H-%M-%S")
    for key, value in snoRNA_class.items(): 
        initial_time = time.time()
        X, y = value.getXY()
        X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3)
        clf = RandomForestClassifier(max_depth=10)
        clf.fit(X_train, y_train)
        save_file = f'{value.group}_{value.method}_{dt_str}.pickle'
        files.append(save_file)
        saveModel(save_file, clf)
        predictions = clf.predict(X_test)
        plotGraph(value, y_test, predictions)
        f1_scores.append(str(f1_score(y_test, predictions) * 100.0) + '%') 
        fbeta_scores.append(str(fbeta_score(y_test, predictions, beta=0.5) * 100.0) + '%')
        recalls.append(str(recall_score(y_test, predictions) * 100.0) + '%')
        precisions.append(str(precision_score(y_test, predictions) * 100.0) + '%')
        auc.append(str(roc_auc_score(y_test, predictions) * 100.0) + '%') 
        labels.append(value.labels)
        methods.append(key)
        end_time = time.time()
        measure_time.append(str(end_time - initial_time) + 's')

    return f1_scores, recalls, fbeta_scores, precisions, auc, methods, measure_time, labels, files 

if __name__ == '__main__':
    cd_box = createMethods('cd_box')
    haca_box = createMethods('haca_box')

    f1_sc, rec1, fbeta1, p1, auc1, m1, mt1, l1, f1 = train(cd_box)
    f2_sc, rec2, fbeta2, p2, auc2, m2, mt2, l2, f2 = train(haca_box)

    f1_scores = f1_sc + f2_sc
    recalls = rec1 + rec2
    fbeta_scores = fbeta1 + fbeta2
    precisions_scores = p1 + p2
    auc_scores = auc1 + auc2
    models = f1 + f2
    labels = l1 + l2
    methods = m1 + m2
    measure_time = mt1 + mt2

    dt_str = datetime.now().strftime("%d-%m-%Y_%H-%M")
    table = pd.DataFrame({'classe': labels, 'metodo': methods, 'f1_score': f1_scores, 'recall': recalls, 'fbeta_score': fbeta_scores, 'precisions_score': precision_score, 'auc_scores': auc_scores, 'tempo_corrido': measure_time, 'modelo': models})
    table.to_csv(f'./output/accuracy_{dt_str}.csv', index=False)
