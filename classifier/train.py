from utils import CSVData, plot_graph, save_model, load_model, dp, average 
import time
from sklearn import datasets
from sklearn.metrics.pairwise import effective_n_jobs
from sklearn.model_selection import train_test_split, GridSearchCV
from sklearn.metrics import (
    f1_score,
    fbeta_score,
    recall_score,
    precision_score,
    roc_auc_score,
    accuracy_score
)
from sklearn.ensemble import RandomForestClassifier
from os import path
import pandas as pd
import time
import numpy as np
from datetime import datetime
import argparse

class snoRNAs():
    f1_scores = []
    recalls = []
    fbeta_scores = []
    precisions = []
    auc = []
    measure_time = []
    methods = []
    labels = []
    cm_arr = []
    standard_deviations = []
    averages = []
    evaluation = []
    datetime_str = datetime.now().strftime("%d-%m-%Y_%H-%M-%S.%f")
    list_organisms_real_data = ["chicken", "drosophilas", "cElegans", "leishmania", "platypus", "yang_human"]

    def __init__(self, group, has_cv, test_counter=1):
        self.group = group
        self.extraction_methods = self._get_extraction_methods_data() 
        self.has_cv = has_cv
        self.test_counter = test_counter

    def _get_extraction_methods_data(self):
        fr = CSVData(self.group, "fourier_real")
        fzc = CSVData(self.group, "fourier_zcurve")
        es = CSVData(self.group, "entropy_shannon")
        et = CSVData(self.group, "entropy_tsallis")
        cmp = CSVData(self.group, "complex")

        methods = dict()

        methods["fourier_real"] = fr
        methods["fourier_zcurve"] = fzc
        methods["entropy_shannon"] = es
        methods["entropy_tsallis"] = et
        methods["complex"] = cmp

        return methods

    def _evaluate_model(self, arr):
        max_f1score = 0 
        current_index = -1
        for index, value in enumerate(arr):
            if(value[3] >=  max_f1score):
               max_f1score = value[3] 
               current_index = index

        group = arr[current_index][0]
        method = arr[current_index][1]
        clf = arr[current_index][2]
        y_test = arr[current_index][4]
        return group, method, clf, y_test

    def train(self):
        if not self.has_cv:
            for key, value in self.extraction_methods.items():
                for _ in range(self.test_counter):
                    initial_time = time.time()
                    X, y = value.get_XY()
                    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3)
                    clf = RandomForestClassifier(max_depth=10)
                    clf.fit(X_train, y_train)
                    predictions = clf.predict(X_test)
                    self.evaluation.append((value.group, value.method, clf, f1_score(y_test, predictions), y_test))
                    plot_graph(value, y_test, predictions, self.cm_arr)
                    self.f1_scores.append(str(f1_score(y_test, predictions) * 100.0) + "%")
                    self.fbeta_scores.append(
                        str(fbeta_score(y_test, predictions, beta=0.5) * 100.0) + "%"
                    )
                    self.recalls.append(str(recall_score(y_test, predictions) * 100.0) + "%")
                    self.precisions.append(
                        str(precision_score(y_test, predictions, average="macro") * 100.0) + "%"
                    )
                    self.auc.append(str(roc_auc_score(y_test, predictions) * 100.0) + "%")
                    self.labels.append(value.group)
                    self.methods.append(key)
                    end_time = time.time()
                    self.measure_time.append(str(end_time - initial_time) + "s")

                group, method, clf, y_test = self._evaluate_model(self.evaluation)
                model_file = f"{group}_{method}_{self.datetime_str}.pickle"
                save_model(model_file, clf)
                self.test(y_test, model_file, group, method)
                self.evaluation.clear()
                deviation = dp(self.cm_arr)
                avg = average(self.cm_arr)
                self.standard_deviations.append(
                    {"class": value.group, "method": value.method, "deviation": deviation}
                )
                self.averages.append({"class": value.group, "method": value.method, "average": avg})
    
        else:
            space = dict()
            space['n_estimators'] = [10, 100, 500]
            for key, value in self.extraction_methods.items():
                initial_time = time.time()
                X, y = value.get_XY()
                X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3)
                model = RandomForestClassifier(max_depth=10)

                clf_f1 = GridSearchCV(model, space, scoring="f1", refit=True)
                clf_precision = GridSearchCV(model, space, scoring="precision", refit=True)
                clf_recall = GridSearchCV(model, space, scoring="recall", refit=True)
                clf_accuracy = GridSearchCV(model, space, scoring="accuracy", refit=True)
                clf_auc = GridSearchCV(model, space, scoring="roc_auc", refit=True)

                result_f1 = clf_f1.fit(X_train, y_train)
                result_precision = clf_precision.fit(X_train, y_train)
                result_recall = clf_recall.fit(X_train, y_train)
                result_accuracy = clf_accuracy.fit(X_train, y_train)
                result_auc = clf_auc.fit(X_train, y_train)
                
                self.test_with_cv(result_f1.best_estimator_, result_f1.best_score_, "f1", value.group, value.method)
                self.test_with_cv(result_precision.best_estimator_, result_precision.best_score_, "precision", value.group, value.method)
                self.test_with_cv(result_recall.best_estimator_, result_recall.best_score_, "recall", value.group, value.method)
                self.test_with_cv(result_accuracy.best_estimator_, result_accuracy.best_score_, "accuracy", value.group, value.method)
                self.test_with_cv(result_auc.best_estimator_, result_auc.best_score_, "auc_roc", value.group, value.method)
                
                
                predictions = clf_f1.predict(X_test)
                plot_graph(value, y_test, predictions, self.cm_arr)
                
                self.f1_scores.append(str(f1_score(y_test, predictions) * 100.0) + "%")
                self.fbeta_scores.append(
                        str(fbeta_score(y_test, predictions, beta=0.5) * 100.0) + "%"
                    )
                self.recalls.append(str(recall_score(y_test, predictions) * 100.0) + "%")
                self.precisions.append(
                        str(precision_score(y_test, predictions, average="macro") * 100.0) + "%"
                    )
                self.auc.append(str(roc_auc_score(y_test, predictions) * 100.0) + "%")
                
                self.labels.append(value.group)
                self.methods.append(key)
                end_time = time.time()
                self.measure_time.append(str(end_time - initial_time) + "s")

    def test(self, y_test, model_file, group, method):
        path = f'./models/{model_file}'
        model = load_model(path)
        real_valid = CSVData(group, method)                           
        out_file = f"./output/validation/validation_{self.datetime_str}.csv"
        content = ""
        if not path.isfile(out_file):
            content = f'classe,metodo,organismo,positivos,negativos,total,modelo,eficiencia\n'
            f = open(out_file, "w")  
        else:
            f = open(out_file, "a+")
        for org in self.list_organisms_real_data:
            X = real_valid.get_X(org)
            prediction = model.predict(X)
            pos = 0
            neg = 0
            total = 0
            for i in prediction:
                if i == 1:
                    pos += 1
                else:
                    neg += 1
            total = pos + neg   
            content += f'{group},{method},{org},{pos},{neg},{total},{model_file},{pos/total}\n'
        f.write(content)
        f.close()

    def test_with_cv(self, best_model, best_score, score_type, group, method):
        real_valid = CSVData(group, method)                           
        out_file = f"./output/validation/{score_type}_{self.datetime_str}.csv"
        content = ""
        if not path.isfile(out_file):
            content = f'classe,metodo,organismo,positivos,negativos,total,eficiencia,{score_type}\n'
            f = open(out_file, "w")  
        else:
            f = open(out_file, "a+")
        for org in self.list_organisms_real_data:
            X = real_valid.get_X(org)
            prediction = best_model.predict(X)
            pos = 0
            neg = 0
            total = 0
            for i in prediction:
                if i == 1:
                    pos += 1
                else:
                    neg += 1
            total = pos + neg   
            content += f'{group},{method},{org},{pos},{neg},{total},{pos/total},{best_score}\n'
        f.write(content)
        f.close()

    def _get_variables(self):
        return (
        self.averages,
        self.f1_scores,
        self.recalls,
        self.fbeta_scores,
        self.precisions,
        self.auc,
        self.labels,
        self.methods,
        self.measure_time,
        self.cm_arr,
        self.standard_deviations
        )

    def train_and_test(has_cv):
        test_counter = 1
        if not has_cv:
            parser = argparse.ArgumentParser("train_py")
            parser.add_argument("test_counter", help="How many tests you want to do in your dataset to obtain the standard deviation")
            args = parser.parse_args() 
            test_counter = int(args.test_counter)

        cd_box = snoRNAs("cd_box", has_cv, test_counter=test_counter)
        haca_box = snoRNAs("haca_box", has_cv, test_counter=test_counter)

        cd_box.train()
        haca_box.train()
                                        
        avg1, f1_sc, rec1, fbeta1, p1, auc1, l1, m1, mt1, cm_arr1, dev1 = cd_box._get_variables()
        avg2, f2_sc, rec2, fbeta2, p2, auc2, l2, m2, mt2, cm_arr2, dev2 = haca_box._get_variables()

        averages = avg1 + avg2
        f1_scores = f1_sc + f2_sc                                                       
        recalls = rec1 + rec2                                                           
        fbeta_scores = fbeta1 + fbeta2                                                  
        precisions_scores = p1 + p2                                                     
        auc_scores = auc1 + auc2                                                        
        labels = l1 + l2                                                                
        methods = m1 + m2
        measure_time = mt1 + mt2                                                        
        confusion_matrix = cm_arr1 + cm_arr2                                            
        deviations = dev1 + dev2
                            
        table = pd.DataFrame(                                                           
            {                                                                           
                "classe": labels,                                                       
                "metodo": methods,                                                      
                "f1_score": f1_scores,                                                  
                "recall": recalls,                                                      
                "fbeta_score": fbeta_scores,                                            
                "precisions_score": precisions_scores,
                "auc_scores": auc_scores,                                               
                "tempo_corrido": measure_time,                                          
                "matriz_da_confusao": confusion_matrix,                                 
            }                                                                           
        )                                                                               
        table.to_csv(f"./output/metrics_{self.datetime_str}.csv", index=False)                    
                                                                                        
        statistics = pd.DataFrame({                                                     
            f"desvio_padrao (n = {args.test_counter})": deviations,                     
            f"media_aritmetica (n = {args.test_counter})": averages                     
        })                                                                              
                                                                                        
        if not has_cv:
            statistics.to_csv(f"./output/statistics/statistics_{self.datetime_str}.csv", index=False)        
        else:
            table.to_csv(f"./output/cross_validation/metrics_{self.datetime_str}.csv", index=False)    
