import numpy as np
import matplotlib.pyplot as plt
import pandas as pd


dataset = pd.read_csv('mealAmountData1.csv')
X = dataset.values

from sklearn.cluster import kMeans
wcss = []

# for i in range(1,11):

kmeans = KMeans(n_clusters=i,)