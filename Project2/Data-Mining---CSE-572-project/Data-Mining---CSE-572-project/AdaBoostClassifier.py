from sklearn.ensemble import AdaBoostClassifier
from sklearn.model_selection import GridSearchCV


class AdaBoost:
    def __init__(self, x_train, y_train, x_test, y_test):
        self.clf = AdaBoostClassifier()
        self.grid_search_params = {'n_estimators': [500, 1000], 'learning_rate': [.001, 0.01, .1]}
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
