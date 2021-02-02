from sklearn.tree import DecisionTreeClassifier


class DecisionTree:
    def __init__(self, x_train, y_train, x_test, y_test):
        self.clf = DecisionTreeClassifier()
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
