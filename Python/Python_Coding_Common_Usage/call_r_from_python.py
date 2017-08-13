
# coding: utf-8

# In[ ]:

"""
Call R from Python
"""


# In[3]:

import pandas as pd
import numpy as np

import os


# In[15]:

# Setup evvironment varibles required by rpy2
# os.environ['R_HOME'] = 'C:\\R\\R-3.1.2'
# os.environ['R_HOME'] = 'C:/R/R-3.1.2'


# In[2]:

x1 = [1,2,3,4]
x2 = [5,6,7,8]
dfx = pd.DataFrame({'col1':x1,
                     'col2':x2})


# In[3]:

dfx.to_csv('input.csv', index=False)


# In[4]:

os.system('Rscript R_func.r')


# In[5]:

dfz = pd.read_csv('output.csv')
dfz


# In[ ]:




# In[ ]:




# In[ ]:



