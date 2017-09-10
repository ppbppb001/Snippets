
# coding: utf-8

# In[1]:

# python general
import datetime as dt
from datetime import datetime
from datetime import time
from datetime import date
import time as tm

# numpy
import numpy as np

# pandas
import pandas as pd

# matplotlib
import matplotlib as mpl
from matplotlib import cm
from mpl_toolkits.mplot3d import Axes3D
import matplotlib.pyplot as plt

# display image in the cells of notebook
from IPython.display import Image  
from IPython.display import display


# In[2]:

df1 = pd.DataFrame(np.arange(100,200,10))
df1.columns = ['ColX']
print df1
df2 = pd.DataFrame(np.arange(0,1000,100))
df2.columns = ['ColID']
print df2
dfOurs = df1.join(df2)
print dfOurs


# In[3]:

dfX = pd.DataFrame([[200,0.2],[404,0.44],[600,0.6],[606,0.66]])
dfX.columns = ['ID','Value']
print dfX


# In[4]:

dfRes = dfOurs[dfOurs.ColID.isin(dfX.ID)]
dfRes


# In[5]:

dfRes2 = dfX[dfX.ID.isin(dfOurs.ColID)]
dfRes2


# In[6]:

dfX.ID.isin(dfOurs.ColID)


# In[15]:

dfX.loc[dfX.ID.isin(dfOurs.ColID),'Value'] = np.int64(1)
dfX


# In[8]:

dfX[dfX.Value==0.44]


# In[9]:

print dfX


# In[10]:

dfRes2


# In[11]:

print dfRes2.index
print dfRes2.index[0],dfRes2.index[-1]


# In[12]:

dfRes2.loc[dfRes2.index[-1]]


# In[ ]:



