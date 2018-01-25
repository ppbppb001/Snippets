
# coding: utf-8

# In[1]:


import time as tm

# numpy
import numpy as np
# pandas
import pandas as pd


# In[2]:


# Make pseudo data set
code_low = 1000
code_high = 4000
dataset_size = 100000

codes = ['%s'%(x) for x in range(code_low, code_high)]   # list of codes
# dfCode = pd.DataFrame(data=codes, columns=["Code"])

data_codes = np.random.randint(low=code_low+100, 
                               high=code_high, 
                               size=dataset_size)  # 100items less than 'codes'
data_tagcodes = np.random.randint(low=1, 
                                  high=dataset_size*100, 
                                  size=dataset_size)
data_tags = ['Tag string is <Code=%4.4d, Tag=%8.8d>'%(x[0], x[1]) for x in zip(data_codes,data_tagcodes)] # create tag strings

dfData = pd.DataFrame(data=zip(data_codes, data_tags),
                      columns=["Code", "Tag"])          # The pseudo data set
dfData


# In[3]:


tk1 = tm.clock()  # for benchmark

result = []  # list to store the sub-dataframe for each code
for code in codes:
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


result[100]

