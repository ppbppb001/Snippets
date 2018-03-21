
# coding: utf-8

# In[4]:


import time
import datetime as dt
import sys

import numpy as np
import pandas as pd

import sklearn
from sklearn import linear_model
from sklearn import metrics

import matplotlib.pyplot as plt
from matplotlib import cm


# In[7]:


print ("python version", sys.version)
print ("numpy version: ", np.__version__)
print ("scikit-learn version: ", sklearn.__version__)
print ("pandas version: ", pd.__version__)


# In[8]:


# np.random.seed(0)
np.random.seed(np.int64(time.clock()*1000))

dlen = 100
split = 0.7
trainlen = np.int64(dlen * split)
testlen = dlen - trainlen


# In[9]:


values = np.random.random(dlen)
# values = np.linspace(0,1,dlen)

classes = np.random.randint(0,2,dlen)
# classes = [0 if x <0.3 else 1 for x in values]


df = pd.DataFrame({'Value': values, 
                   'Class': classes})
print ('>head of df\n', df.head())
print ('> tail of df\n', df.tail())

dftrain = df[0:trainlen]
print ('> train size = ', len(dftrain))

dftest = df[trainlen:]
print ('> test size = ', len(dftest))


# In[10]:


# *********************************
# Linear Regression
# *********************************

lnreg = linear_model.LinearRegression()

lnreg.fit(X=dftrain[['Value']].values, y=dftrain[['Class']].values)

pred = lnreg.predict(dftest[['Value']])
print (len(pred))
print (pred)


# In[11]:


pred_class = np.array([0 if x<0.5 else 1 for x in pred])
print ('pred_class =', pred_class)
test_class =dftest['Class'].values
print ('test_class =', test_class)


# In[12]:


cmx = metrics.confusion_matrix(y_true=test_class, y_pred = pred_class)
print (cmx)


# In[13]:


auc = metrics.roc_auc_score(y_true=test_class, y_score = pred)
print ("AUC:", auc)


# In[14]:


recall = metrics.recall_score(y_true=test_class, y_pred=pred_class)
print ("ReCall:", recall)


# In[15]:


precision = metrics.precision_score(y_true=test_class, y_pred=pred_class)
print ("Precision:", precision)


# In[17]:


# roc_curve:
fpr, tpr, th = metrics.roc_curve(y_true=test_class, y_score=pred)
print ("ROC_fpr:\n", fpr)
print ("ROC_tpr:\n", tpr)
print ("ROC_th:\n", th)


# In[20]:


# precision_recall_curve:
precision, recall, th = metrics.precision_recall_curve(y_true=test_class, probas_pred=pred)
print ("Precision:\n", precision)
print ("ReCall:\n", recall)
print ("th:\n", th)
print ("length of th: ",len(th))


# In[21]:


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


# In[22]:


# *********************************
# Logistic Regression
# *********************************

logreg = linear_model.LogisticRegression()

logreg.fit(X=dftrain[['Value']].values, y=dftrain['Class'].values)

pred_log = logreg.predict(dftest[['Value']])
print ("Length of pred_log:", len(pred_log))
print ("pred_log:\n",pred_log)


# In[23]:


print (dftest['Class'].values)
print (pred_log)


# In[24]:


auc = metrics.roc_auc_score(y_true=test_class, y_score = pred_log)
print ('auc =',auc)

recall = metrics.recall_score(y_true=test_class, y_pred=pred_log)
print ('recall =',recall)

precision = metrics.precision_score(y_true=test_class, y_pred=pred_log)
print ('precision =',precision)


# In[26]:


# roc_curve:
fpr, tpr, th = metrics.roc_curve(y_true=test_class, y_score=pred_log)
print ("fpr:", fpr)
print ("tpr:", tpr)
print ("th:", th)


# In[29]:


# precision_recall_curve:
precision, recall, th = metrics.precision_recall_curve(y_true=test_class, probas_pred=pred_log)
print ("Precision:\n", precision)
print ("ReCall:\n", recall)
print ("th:\n", th)
print ("Length of th:", len(th))


# In[30]:


print (test_class)
print (pred_log)

