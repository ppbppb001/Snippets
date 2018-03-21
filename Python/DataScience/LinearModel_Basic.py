
# coding: utf-8

# In[16]:

import time
import datetime as dt

import numpy as np
import pandas as pd

import sklearn
from sklearn import linear_model
from sklearn import metrics

import matplotlib.pyplot as plt
from matplotlib import cm


# In[2]:

print "numpy version: ", np.__version__
print "scikit-learn version: ", sklearn.__version__
print "pandas version: ", pd.__version__


# In[52]:

# np.random.seed(0)
np.random.seed(np.int64(time.clock()*1000))

dlen = 100
split = 0.7
trainlen = np.int64(dlen * split)
testlen = dlen - trainlen


# In[53]:

values = np.random.random(dlen)
# values = np.linspace(0,1,dlen)

classes = np.random.randint(0,2,dlen)
# classes = [0 if x <0.3 else 1 for x in values]


df = pd.DataFrame({'Value': values, 
                   'Class': classes})
print '>head of df\n', df.head()
print '> tail of df\n', df.tail()

dftrain = df[0:trainlen]
print '> train size = ', len(dftrain)

dftest = df[trainlen:]
print '> test size = ', len(dftest)


# In[5]:

# *********************************
# Linear Regression
# *********************************

lnreg = linear_model.LinearRegression()

lnreg.fit(X=dftrain[['Value']].values, y=dftrain[['Class']].values)

pred = lnreg.predict(dftest[['Value']])
print len(pred)
print pred


# In[6]:

pred_class = np.array([0 if x<0.5 else 1 for x in pred])
print 'pred_class =', pred_class
test_class =dftest['Class'].values
print 'test_class =', test_class


# In[15]:

cmx = metrics.confusion_matrix(y_true=test_class, y_pred = pred_class)
print cmx


# In[8]:

auc = metrics.roc_auc_score(y_true=test_class, y_score = pred)
print auc


# In[9]:

recall = metrics.recall_score(y_true=test_class, y_pred=pred_class)
print recall


# In[10]:

precision = metrics.precision_score(y_true=test_class, y_pred=pred_class)
print precision


# In[11]:

# roc_curve:
fpr, tpr, th = metrics.roc_curve(y_true=test_class, y_score=pred)
print fpr
print tpr
print th


# In[12]:

# precision_recall_curve:
precision, recall, th = metrics.precision_recall_curve(y_true=test_class, probas_pred=pred)
print precision
print recall
print th
print len(th)


# In[ ]:




# In[ ]:




# In[ ]:




# In[63]:

#-----------------------------
# Define color maps
#-----------------------------

mycolormap = cm.jet
# mycolormap = cm.coolwarm
# mycolormap = cm.autumn
# mycolormap = cm.hot
# mycolormap = cm.Greys

# create figure canvas
fig = plt.figure(figsize=[12,12],facecolor='white')   # 16(inches) by 10(inches)
# fig = plt.figure(facecolor='white')   # use default fig size

ax1 = fig.add_subplot(211) 
ax1.plot(fpr,tpr)
ax1.set_title('fpr/tpr')
ax1.set_xlabel('fpr')
ax1.set_ylabel('tpr')

ax2 = fig.add_subplot(212) 
ax2.plot(recall, precision)
ax2.set_title('precision/recall')
ax2.set_ylabel('precison')
ax2.set_xlabel('recall')

plt.show()

# In[56]:

# *********************************
# Logistic Regression
# *********************************

logreg = linear_model.LogisticRegression()

logreg.fit(X=dftrain[['Value']].values, y=dftrain['Class'].values)

pred_log = logreg.predict(dftest[['Value']])
print len(pred_log)
print pred_log


# In[57]:

print dftest['Class'].values
print pred_log


# In[58]:

auc = metrics.roc_auc_score(y_true=test_class, y_score = pred_log)
print 'auc =',auc

recall = metrics.recall_score(y_true=test_class, y_pred=pred_log)
print 'recall =',recall

precision = metrics.precision_score(y_true=test_class, y_pred=pred_log)
print 'precision =',precision


# In[59]:

# roc_curve:
fpr, tpr, th = metrics.roc_curve(y_true=test_class, y_score=pred_log)
print fpr
print tpr
print th


# In[60]:

# precision_recall_curve:
precision, recall, th = metrics.precision_recall_curve(y_true=test_class, probas_pred=pred_log)
print precision
print recall
print th
print len(th)


# In[61]:

print test_class
print pred_log


# In[6]

from sklearn import datasets


# In[ ]:
    
iris = datasets.load_iris()


# In[ ]:




# In[ ]:



