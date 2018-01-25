
# coding: utf-8

# In[1]:


import time as tm

# numpy
import numpy as np
# pandas
import pandas as pd


# In[2]:


# Make pseudo data set
code_low = 0
code_high = 9999
dataset_size = 100000

codes = np.random.randint(low=code_low+2000, 
                          high=code_high-3000, 
                          size=dataset_size)  # subset of [code_low:code_high]
values = np.random.randint(low=1, 
                           high=dataset_size*100, 
                           size=dataset_size)
tags = ['Tag string is <Code=%4.4d, Tag=%8.8d>'%(x[0], x[1]) for x in zip(codes,values)] # create tag strings

dfData = pd.DataFrame(data=zip(codes, tags),columns=["Code", "Tag"])          # The pseudo data set
dfData


# In[3]:


# Make sub-dataframes by matching the code:

tk1 = tm.clock()  # for benchmark

codeTable = set(dfData["Code"].values)  # code index retrieved from dfData
result = []   # list to store the sub-dataframe for each code
for code in codeTable:
    chk = dfData['Code'].isin([code])
    dfSub = dfData[chk]
    if len(dfSub) > 0:
        result.append(dfSub)
    
tk2 = tm.clock()

print 'count of result =', len(result)   # number of sub-dataframe
print 'time consumed =','%3.3f(s)'%(tk2-tk1)  # benchmark


# In[4]:


# Check result:
dfX = result[100]
print "result[100]: rows=%d\n"%(len(dfX)),dfX.head()
print

dfX = result[1000]
print "result[1000]: rows=%d\n"%(len(dfX)),dfX.head()


# In[5]:


result[200]

