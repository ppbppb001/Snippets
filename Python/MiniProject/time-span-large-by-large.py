
# coding: utf-8

# In[1]:


import time as tm
import datetime as dt

# numpy
import numpy as np
# pandas
import pandas as pd


# In[2]:


# Make pseudo data set:

timestamp_low = 1e9           # 2001-09-09
timestamp_high = 1e9 + 2e8    # 2008-01-11
total_unit = 200000
total_record = 1000000

codes = np.random.randint(low=0, 
                          high=total_unit, 
                          size=total_record)
lst_code = ["%8.8d"%(x) for x in codes] 

# lst_timestamp = np.random.randint(low=timestamp_low,
#                                   high=timestamp_high,
#                                   size=total_record)
x = np.random.random(total_record)
lst_timestamp = (timestamp_high - timestamp_low)*x + timestamp_low + x
lst_datetime = [str(dt.datetime.fromtimestamp(x)) for x in lst_timestamp]

dfData = pd.DataFrame(data=zip(lst_code, lst_datetime), columns=["Code", "DateTime"])
print dfData.head()
print dfData.tail()


# In[3]:


# Generate a new column of timestamp:

tk1 = tm.clock()

dfData['TimeStamp'] = pd.to_datetime(dfData['DateTime'])   # append timestamp as a new column of dfData

tk2 = tm.clock()
print dfData.head()
print dfData.tail()
print 'time counsumed = %1.3f(s)'%(tk2-tk1)


# In[4]:


# Calculate time span of each group/code:

tk3= tm.clock()

gpTS = dfData.groupby('Code', sort=True)['TimeStamp']   # Col'TimeStamp' is grouped by 'Code'
smax = gpTS.max()     # maximum timestamp value of each group
smin = gpTS.min()     # minimum timestamp value of each group
sdiff = smax - smin   # difference/time-span of each group

tk4= tm.clock()

print 'type=',type(sdiff)
print 'size=',len(sdiff)
print sdiff.head()

print 'time counsumed = %1.3f(s)'%(tk4-tk3)
print '\ntotal time consumed = %1.3f(s)'%((tk2-tk1)+(tk4-tk3))


# In[5]:


# retrieve time span by code:

codex = '00000010'     # code = '00000010' 
diffx = sdiff[codex]   # time-delta = diffx
print 'type=',type(diffx)
print 'diff_ns=', diffx.value,'(ns)'  # time-delta value(numpy int64) in unit of ns
print 'diff_second=', diffx.value/1e9,'(s)'
print 'diff_day=', diffx.value/(1e9*3600*24),'(day)'

