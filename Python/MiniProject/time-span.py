
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
total_unit = 1000
total_record = 100000

codes = np.random.randint(low=1, 
                          high=total_unit, 
                          size=total_record)
lst_code = ["%4.4d"%(x) for x in codes] 

# lst_timestamp = np.random.randint(low=timestamp_low,
#                                   high=timestamp_high,
#                                   size=total_record)
x = np.random.random(total_record)
lst_timestamp = (timestamp_high - timestamp_low)*x + timestamp_low
lst_datetime = [str(dt.datetime.fromtimestamp(x)) for x in lst_timestamp]

dfData = pd.DataFrame(data=zip(lst_code, lst_datetime), columns=["Code", "DateTime"])
dfData


# In[3]:


# Scan data set to generate time span for each code:

codeTable = set(dfData["Code"])
result = []

tk1 = tm.clock()

for code in codeTable:
    chk = dfData["Code"].isin([code])
    dfSub = dfData[chk]
    
    dts = [dt.datetime.strptime(x,"%Y-%m-%d %H:%M:%S.%f") for x in dfSub["DateTime"].values]
    tss = [tm.mktime(x.timetuple()) for x in dts]
    tss_min = min(tss)
    tss_max = max(tss)
    
    rec = [code,                                # code string
           dt.datetime.fromtimestamp(tss_min),  # datetime object of the minimum
           dt.datetime.fromtimestamp(tss_max),  # datetime object of the maximum
           tss_min,                             # minimium timstamp value
           tss_max,                             # maximum timestamp value
           (tss_max - tss_min),                 # difference of the min and max timestamps (seconds)
           (tss_max - tss_min)/(3600*24)]       # difference repsented by value of days
    result.append(rec)
    
tk2 = tm.clock()
print 'count of result =',len(result)
print 'time counsumer = %1.3f(s)'%(tk2-tk1)
print
print result[0]
print result[100]


# In[4]:


# Result list to dataframe
dfResult = pd.DataFrame(data=result,
                        columns=['code','Min','Max','TS_Min','TS_Max','TS_Diff','Diff_in_Days'])
dfResult

