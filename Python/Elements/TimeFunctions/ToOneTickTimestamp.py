
# coding: utf-8

# In[1]:

import datetime as dt
from datetime import datetime
from datetime import date
from datetime import time
import time as tm
import calendar
import numpy as np
import pandas as pd
import io


# In[2]:

df1 = pd.read_csv("quote_nasdaq_aapl_m1_2011_v2.csv")
print "df_len =",len(df1)


# In[3]:

df2 = df1
df2['TIMESTAMP'] -= long(3600*8)
df2['TIMESTAMP'] *= long(1e9)
df2['TIMESTAMP'] += 12345
df2.head()


# In[4]:

df2.to_csv('quote_nasdaq_aapl_m1_2011_onetick_ntc.csv',index=None)


# In[5]:

dfx2 = df2[:]
cols = df2['TIMESTAMP'] % int(1e9)
dfx2.insert(3,'NS',cols)
dfx2.head()


# In[6]:

dfx2.to_csv('quote_nasdaq_aapl_m1_2011_onetick_ntc_ns.csv',index=None)  # with new column of 'NS' 


# In[7]:

pd.to_datetime(df2.loc[0,'TIMESTAMP'])


# In[8]:

df1len = len(df1)
d1 = np.ones(df1len,dtype=np.int64)
s1 = pd.Series(d1)
# s1.name = ''
s1
df2 = df1.copy()
df2['ONES'] = s1
df2.head()


# In[9]:

df3 = pd.read_csv('quote_nasdaq_aapl_m1_2011_onetick_ntc.csv')
df3.head()


# In[ ]:



