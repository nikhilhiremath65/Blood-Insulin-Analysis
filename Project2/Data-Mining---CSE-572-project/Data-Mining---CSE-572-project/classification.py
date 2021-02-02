# from LogisticRegression import LogReg
# from DecisionTree import DecisionTree
# from SVM import SVM
from RandomForest import RandomForest
from XGBoostClassifier import XGBoost
from AdaBoostClassifier import AdaBoost
from NaiveBayes import NaiveBayes
from sklearn.model_selection import train_test_split
from sklearn.metrics import f1_score
from sklearn.metrics import accuracy_score
from sklearn.metrics import precision_score
from sklearn.metrics import recall_score

from sklearn.metrics import classification_report, confusion_matrix


class Classification:
    def __init__(self, classifier_name, data, labels):
        self.x = data
        self.y = labels
        self.classifier_name = classifier_name
        self.clf = None
        self.x_train = None
        self.y_train = None
        self.x_test = None
        self.y_test = None
        self.test_train_split()
        self.y_pred = None
        self.accuracy = None
        self.f1_score = None
        self.recall = None
        self.precision = None

    def test_train_split(self):
        self.x_train, self.x_test, self.y_train, self.y_test = train_test_split(self.x, self.y, test_size=0.3,
                                                                                shuffle=True, random_state=43)

    def get_classifier_object(self):
        # if self.classifier_name == 'LogReg':
        #     self.clf = LogReg(self.x_train, self.y_train, self.x_test, self.y_test)
        #     self.clf.train()
        #     self.y_pred = self.clf.predict()
        # elif self.classifier_name == 'DeciTree':
        #     self.clf = DecisionTree(self.x_train, self.y_train, self.x_test, self.y_test)
        #     self.clf.train()
        #     self.y_pred = self.clf.predict()
        # elif self.classifier_name == 'svm':
        #     self.clf = SVM(self.x_train, self.y_train, self.x_test, self.y_test)
        #     self.clf.train()
        #     self.y_pred = self.clf.predict()
        if self.classifier_name == 'RForest':
            self.clf = RandomForest(self.x_train, self.y_train, self.x_test, self.y_test)
            self.clf.train()
            self.y_pred = self.clf.predict()
        elif self.classifier_name == 'XGB':
            self.clf = XGBoost(self.x_train, self.y_train, self.x_test, self.y_test)
            self.clf.train()
            self.y_pred = self.clf.predict()
        elif self.classifier_name == 'NaiveBayes':
            self.clf = NaiveBayes(self.x_train, self.y_train, self.x_test, self.y_test)
            self.clf.train()
            self.y_pred = self.clf.predict()
        elif self.classifier_name == 'AdaBoost':
            self.clf = AdaBoost(self.x_train, self.y_train, self.x_test, self.y_test)
            self.clf.train()
            self.y_pred = self.clf.predict()

        return self.clf.get_classifier()

    def get_classifier(self):
        return self.clf.get_classifier()

    def get_metrics(self):
        print('classifier:', self.classifier_name)
        self.accuracy = accuracy_score(self.y_test, self.y_pred)
        print('Accuracy score', self.accuracy)
        self.precision = precision_score(self.y_test, self.y_pred)
        print('Precision', self.precision)
        self.recall = recall_score(self.y_test, self.y_pred)
        print('Recall', self.recall)
        self.f1_score = f1_score(self.y_test, self.y_pred)
        print('F1 score', self.f1_score)
        # print('confusion matrix')
        # print(confusion_matrix(self.y_test, self.y_pred))
        # print(classification_report(self.y_test, self.y_pred))



