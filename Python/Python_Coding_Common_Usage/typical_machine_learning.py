
# coding: utf-8

# In[ ]:

"""
Typical machine learning usage
"""


# In[1]:

import pandas as pd
import numpy as np
import scipy as sp

from sklearn import datasets
from sklearn.datasets import make_blobs
from sklearn import preprocessing
from sklearn.preprocessing import Imputer
from sklearn.preprocessing import LabelEncoder
from sklearn.preprocessing import OneHotEncoder

from sklearn.feature_extraction import DictVectorizer as dv
# from sklearn.cross_validation import train_test_split
from sklearn.model_selection import train_test_split

from sklearn.cluster import KMeans
from sklearn.linear_model import LinearRegression

from sklearn.tree import DecisionTreeClassifier
from sklearn.tree import export_graphviz

from sklearn.ensemble import RandomForestClassifier as RFC
from sklearn.metrics import confusion_matrix
import itertools

from sklearn.gaussian_process import GaussianProcess

import matplotlib.pyplot as plt
from matplotlib.colors import ListedColormap as lcmap
import matplotlib.image as mpimg

from io import StringIO
# from sklearn.externals.six import StringIO as StrIO
from StringIO import StringIO as StrIO
from subprocess import check_call
import pydotplus as pydot

import graphviz as gv


# In[ ]:

# preprocessing - imputation
csv_data = """A,B,C,D
1.0, 2.0, 3.0, 4.0
5.0, 6.0,, 8.0
10.0, 11.0, 12.0,"""

df = pd.read_csv(StringIO(unicode(csv_data)))
df

imr = Imputer(missing_values='NaN', strategy='mean', axis=0)
imr.fit(df)
imputed_data = imr.transform(df.values)
imputed_data


# In[ ]:

# preprocessing - normalization
iris = datasets.load_iris()
X_iris, y_iris = iris.data, iris.target

X, y = X_iris[:, :2], y_iris
X_train, X_test, y_train, Y_test = train_test_split(X, y, test_size=0.25, random_state=33)

scaler = preprocessing.StandardScaler().fit(X_train)
X_train = scaler.transform(X_train)
X_test = scaler.transform(X_test)


# In[ ]:




# In[ ]:

dd = {'ele1':2, 'ele2':3}
dd.keys()


# In[ ]:




# In[ ]:

# preprocessing - sklearn.feature_extraction.DictVectorizer, transform feature-value mappings to 
# vectors.
iris = datasets.load_iris()
y = iris.target
iris_dv = dv(sparse=False)
my_dict = [{'species': iris.target_names[i]} for i in y]
my_dict_trans = iris_dv.fit_transform(my_dict)


# In[ ]:

# Linear regression
boston = datasets.load_boston()
boston_X = boston.data
boston_y = boston.target

lr = LinearRegression()
lr.fit(boston_X, boston_y)
predictions = lr.predict(boston_X)


# In[ ]:

# Clustering - KMeans
blobs, ground_truth = datasets.make_blobs(1000, centers=3, cluster_std=1.75)
kmeans = cluster.KMeans(n_clusters=3)
kmeans.fit(blobs)
for i in range(3): # estimate accuracy of each cluster
    print (kmeans.labels_==ground_truth)[ground_truth==i].astype(int).mean()


# In[ ]:

# decision tree, function for plotting decision regions
def plot_decision_regions (X, y, classifier, test_idx, resolution=0.02):
    
    markers = ('s', 'x', 'o', '^', 'v')
    colors = ('red', 'blue', 'lightgreen', 'gray', 'cyan')
    cmap = lcmap(colors[:len(np.unique(y))])

    x1_min, x1_max = X[:, 0].min()-1, X[:, 0].max()+1
    x2_min, x2_max = X[:, 1].min()-1, X[:, 1].max()+1
    xx1, xx2 = np.meshgrid(np.arange(x1_min, x1_max, resolution), 
                           np.arange(x2_min, x2_max, resolution))
    
    Z = classifier.predict(np.array([xx1.ravel(), xx2.ravel()]).T)
    Z = Z.reshape(xx1.shape)
    
    plt.contourf(xx1, xx2, Z, alpha=0.4, cmap=cmap)
    plt.xlim(xx1.min(), xx1.max())
    plt.ylim(xx2.min(), xx2.max())
    
    for idx, cl in enumerate(np.unique(y)):
        plt.scatter(x=X[y==cl,0], y=X[y==cl,1], alpha=0.8,
                   c=cmap(idx), marker=markers[idx], label=cl)
     
    if test_idx:
        X_test, y_test = X[test_idx, :], y[test_idx]
        plt.scatter(X_test[:,0], X_test[:,1], c='', alpha=1.0, linewidth=1,
                   marker='o', s=55, label='test set')
        
    plt.legend()
    plt.show() 
    


# In[ ]:

# decision tree, plot decision regions
iris = datasets.load_iris()
X = iris.data[:, [2,3]]
y = iris.target
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=0)

dt = DecisionTreeClassifier(class_weight=None, criterion='entropy', max_depth=3,
                           max_features=None, max_leaf_nodes=None, min_samples_leaf=1,
                           min_samples_split=2, min_weight_fraction_leaf=0.0,
                           presort=False, random_state=0, splitter='best')
dt.fit(X_train, y_train)

X_combined = np.vstack((X_train, X_test))
y_combined = np.hstack((y_train, y_test))
plot_decision_regions(X_combined, y_combined, classifier=dt,
                     test_idx=range(105, 150))


# In[ ]:

# decision tree, visualize

# #convert dot to image format, method 1
# export_graphviz(dt, out_file='tree.dot', feature_names =['petal length', 'petal width'])
# check_call(['dot', '-Tpng', 'tree.dot', '-o', 'tree.png'])

#convert dot to image format, method 2  
str_buffer = StrIO()
export_graphviz(dt, out_file=str_buffer, feature_names =['petal length', 'petal width'])
graph = pydot.graph_from_dot_data(str_buffer.getvalue())
graph.write_png('tree.png')

img = mpimg.imread('tree.png')
plt.imshow(img)
plt.show()


# In[ ]:

# random forest, prediction
X, y = datasets.make_classification(1000)
rf = RFC()
rf.fit(X, y)

probs = rf.predict_proba(X)
probs_df = pd.DataFrame(probs, columns = ['0', '1'])
probs_df['was_correct'] = rf.predict(X) == y

f, ax = plt.subplots(figsize=(7, 5))
probs_df.groupby('0').was_correct.mean().plot(kind='bar', ax=ax)
ax.set_title('Accuracy at 0 class probability')
ax.set_ylabel('% Correct')
ax.set_xlabel('% trees for 0')

plt.show()


# In[ ]:

# random forest, confusion matrix
X, y = datasets.make_classification(n_samples=10000,
                                    n_features=20,
                                    n_informative=15,
                                    flip_y=0.5, weights=[0.2, 0.8])
training = np.random.choice([True, False], p=[0.8, 0.2],
                            size=y.shape)
max_feature_params = ['auto', 'sqrt', 'log2', 0.01, 0.5, 0.99]
confusion_matrixes = {}

for max_feature in max_feature_params:
    rf = RFC(max_features=max_feature)
    rf.fit(X[training], y[training])
    confusion_matrixes[max_feature] = confusion_matrix(y[~training], rf.predict(X[~training])).ravel()
#     confusion_matrixes[max_feature] = confusion_matrix(y[~training], rf.predict(X[~training]))
confusion_df = pd.DataFrame(confusion_matrixes)
    
f, ax = plt.subplots(figsize=(7,5))    
confusion_df.plot(kind='bar', ax=ax)   

ax.legend(loc='best')
ax.grid()
ax.set_xticklabels([str((i, j)) for i, j in 
                   list(itertools.product(range(2), range(2)))])

    
plt.show()    


# In[ ]:




# In[ ]:

# Gaussian process
boston = datasets.load_boston()
boston_X = boston.data
boston_y = boston.target

train_set = np.random.choice([True, False], len(boston_y), [0.75, 0.25])
gp = GaussianProcess()
gp.fit(boston_X[train_set], boston_y[train_set])
test_preds = gp.predict(boston_X[~train_set])


# In[35]:

# Encode categorial values with LabelEncoder and OneHotEncoder
X_train = pd.read_csv('../loan_prediction-1/X_train.csv')
Y_train = pd.read_csv('../loan_prediction-1/Y_train.csv')
X_test = pd.read_csv('../loan_prediction-1/X_test.csv')
Y_test = pd.read_csv('../loan_prediction-1/Y_test.csv')

# LabelEncoder
le = LabelEncoder()
for col in X_test.columns.values:
    if X_test[col].dtypes=='object':
        data = X_train[col].append(X_test[col])
        le.fit(data.values)
        X_train[col] = le.transform(X_train[col])
        X_test[col] = le.transform(X_test[col])

# OneHotEncoder
enc = OneHotEncoder(sparse=False)
X_train_1 = X_train
X_test_1 = X_test
columns = ['Gender', 'Married', 'Dependents', 'Education', 'Self_Employed',
          'Credit_History', 'Property_Area']
for col in columns:
    data = pd.DataFrame(X_train[col].append(X_test[col]))
    enc.fit(data.values.reshape(-1,1))
    temp = enc.transform(X_train[col].values.reshape(-1,1))
    temp = pd.DataFrame(temp, columns = [(col+"_"+str(i)) for i in data[col].value_counts().index])
    temp = temp.set_index(X_train.index.values)
    X_train_1 = pd.concat([X_train_1, temp], axis=1)
    
        


# In[ ]:




# In[ ]:




# In[ ]:




# In[ ]:

# practice...








# In[ ]:

data = """
col1, col2, col3
1, st1, 2.0
3, st2, 5.0
2, st2, 3.0
5, st1, 6.0
"""

df = pd.read_csv(StringIO(unicode(data)))


# In[ ]:

df


# In[ ]:

df1 = df.copy()
le = LabelEncoder()
le.fit(df1.ix[:,1])
df1['col'] = le.transform(df1.ix[:,1])


# In[ ]:

df1


# In[ ]:

df2 = df1.copy()
ohe = OneHotEncoder()
ohe.fit(df2.ix[:,3])
temp = ohe.transform(df2.ix[:,3])


# In[ ]:




# In[5]:




# In[ ]:




# In[ ]:



