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
import argparse

def train(snoRNA_class, test_counter):
    if test_counter == 0:
        raise Exception("test_counter must be >= 1")

    current_method = ""
    current_class = ""
    f1_scores = [] 
    recalls = []
    fbeta_scores = []
    precisions = []
    auc = []
    methods = []
    classes = []
    measure_time = []
    labels = []
    files = []
    cm_arr = []
    dp_arr = []
    avg_arr = []
    dt_str = datetime.now().strftime("%d-%m-%Y_%H-%M-%S")
    for i in range(test_counter):
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
            plotGraph(value, y_test, predictions, cm_arr)
            f1_scores.append(str(f1_score(y_test, predictions) * 100.0) + '%') 
            fbeta_scores.append(str(fbeta_score(y_test, predictions, beta=0.5) * 100.0) + '%')
            recalls.append(str(recall_score(y_test, predictions) * 100.0) + '%')
            precisions.append(str(precision_score(y_test, predictions, average='macro') * 100.0) + '%')
            auc.append(str(roc_auc_score(y_test, predictions) * 100.0) + '%') 
            labels.append(value.group)
            methods.append(key)
            classes.append(value.group)
            end_time = time.time()
            measure_time.append(str(end_time - initial_time) + 's')
        deviation = dp(cm_arr)
        avg = average(cm_arr)
        dp_arr.append({'class': classes[i], 'method': methods[i], 'deviation': deviation})
        avg_arr.append({'class': classes[i],'method': methods[i], 'average': avg})
    return f1_scores, recalls, fbeta_scores, precisions, auc, methods, measure_time, labels, files, cm_arr, dp_arr, avg_arr 

if __name__ == '__main__':
    cd_box = createMethods('cd_box')
    haca_box = createMethods('haca_box')

    parser = argparse.ArgumentParser("train_py")
    parser.add_argument("test_counter", help="How many tests you want to do in your dataset to obtain the standard deviation")
    args = parser.parse_args()

    f1_sc, rec1, fbeta1, p1, auc1, m1, mt1, l1, f1, cm_arr1, dev1, avg1 = train(cd_box, int(args.test_counter))
    f2_sc, rec2, fbeta2, p2, auc2, m2, mt2, l2, f2, cm_arr2, dev2, avg2 = train(haca_box, int(args.test_counter))

    
    deviations = dev1 + dev2
    averages = avg1 + avg2
    f1_scores = f1_sc + f2_sc
    recalls = rec1 + rec2
    fbeta_scores = fbeta1 + fbeta2
    precisions_scores = p1 + p2
    auc_scores = auc1 + auc2
    models = f1 + f2
    labels = l1 + l2
    methods = m1 + m2
    measure_time = mt1 + mt2
    confusion_matrix = cm_arr1 + cm_arr2 

    dt_str = datetime.now().strftime("%d-%m-%Y_%H-%M-%S")
    table = pd.DataFrame({'classe': labels, 'metodo': methods, 'f1_score': f1_scores, 'recall': recalls, 'fbeta_score': fbeta_scores, 'precisions_score': precisions_scores, 'auc_scores': auc_scores, 'tempo_corrido': measure_time, 'matriz_da_confusao': confusion_matrix, 'modelo': models})
    table = table._append({f'desvio_padrao (n = {args.test_counter})': deviations}, ignore_index=True)
    table.to_csv(f'./output/accuracy_{dt_str}.csv', index=False)
