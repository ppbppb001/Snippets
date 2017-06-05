
# coding: utf-8

# In[1]:

import pandas as pd
import numpy as np


# In[3]:

df1 = pd.read_csv('input.csv')
# print df1


# In[8]:

df1['sum'] = df1['x1'] + df1['x2']

print
print "[Python]: output.csv:"
print df1
print


# In[7]:

df1.to_csv("output.csv",index=False)


# In[ ]:



