from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import GridSearchCV
import numpy as np


class LogReg:
    def __init__(self, x_train, y_train, x_test, y_test):
        self.clf = LogisticRegression(penalty='l2')
        self.grid_search_params = {'C': np.logspace(-3, 3, 7), 'solver': ['lbfgs', 'liblinear', 'sag', 'saga']}
        self.clf = GridSearchCV(self.clf, self.grid_search_params, cv=10)
        self.x_train = x_train
        self.y_train = y_train
        self.x_test = x_test
        self.y_Test = y_test
        self.y_pred = None

    def get_classifier(self):
        return self.clf

    def train(self):
        self.clf.fit(self.x_train, self.y_train)

    def predict(self, x_test=None):
        self.y_pred = self.clf.predict(self.x_test)
        return self.y_pred



