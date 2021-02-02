import pickle
from preprocessing import Preprocess
from features import Features
import numpy as np
import pandas as pd


test_file_name = input("Please enter the test file name: ")
preprocess_obj = Preprocess(test_file_name)
test_file_dataframe = preprocess_obj.get_dataframe()
test_file_features_obj = Features(test_file_dataframe)
test_file_features_obj.compute_features()
test_file_features = test_file_features_obj.get_features()
# print(len(test_file_features))

# Random Forest
random_forest_clf = pickle.load(open('RForest_model.pkl', 'rb'))
y_pred = random_forest_clf.predict(test_file_features)
print('Saving the output of RandomForest classifier prediction')
rforest_dataframe = pd.DataFrame(y_pred, columns=['Meal/NoMeal'])
rforest_dataframe.to_csv('RForest_output.csv')

# AdaBoost
adaboost_clf = pickle.load(open('Adaboost_model.pkl', 'rb'))
y_pred = adaboost_clf.predict(test_file_features)
print('Saving the output of AdaBoost classifier prediction')
adaboost_dataframe = pd.DataFrame(y_pred, columns=['Meal/NoMeal'])
adaboost_dataframe.to_csv('Adaboost_output.csv')

# XGBoost
XGBoost_clf = pickle.load(open('XGBoost_model.pkl', 'rb'))
y_pred = XGBoost_clf.predict(test_file_features)
print('Saving the output of XGBoost classifier prediction')
XGBoost_dataframe = pd.DataFrame(y_pred, columns=['Meal/NoMeal'])
XGBoost_dataframe.to_csv('XGBoost_output.csv')

# NaiveBayes
NB_clf = pickle.load(open('NaiveBayes_model.pkl', 'rb'))
y_pred = NB_clf.predict(test_file_features)
print('Saving the output of NaiveBayes classifier prediction')
NB_dataframe = pd.DataFrame(y_pred, columns=['Meal/NoMeal'])
NB_dataframe.to_csv('NaiveBayes_output.csv')


