
# coding: utf-8

# In[ ]:

"""
Date and time
"""


# In[34]:

import pandas as pd
import numpy as np

import datetime as dt
from datetime import datetime
from datetime import timedelta
from dateutil.parser import parse

import time
import calendar
import pytz  #world time zone definition


# In[20]:

#date and time basics
now = datetime.now() #date and time now
now.year, now.month, now.day

delta = datetime(2011, 1, 7) - datetime(2008, 6, 24, 8, 15) #temporal difference
delta.days, delta.seconds

start = datetime(2001, 1, 7) #shifted datetime
start + timedelta(12)


# In[33]:

#convert between string and datetime
stamp = datetime(2011, 1, 3) #datetime to string
str(stamp), stamp.strftime('%Y-%m')

value = '2011-01-03' #string to datetime
datetime.strptime(value, '%Y-%m-%d')
parse('2011-01-03')

datestrs = ['7/6/2011', '8/6/2011'] #string to datetime with pandas
pd.to_datetime(datestrs)


# In[43]:

#pandas timeseries - generate series with dates as index
dates = [datetime(2011, 1, 2), datetime(2011, 1, 5), datetime(2011, 1, 7)] 
ts = pd.Series(np.random.randn(3), index=dates) #pandas series, dates as index
ts['01/02/2011'], ts['20110105']


# In[46]:

#pandas timeseries - generate date range
drange1 = pd.date_range('1/1/2000', periods=1000) #date range
drange2 = pd.date_range('1/1/2000', '12/1/2000', freq='BM') #last business day of each month
drange3 = pd.date_range('1/1/2000', '1/3/2000 23:59', freq='4h')
drange4 = pd.date_range('1/1/2012', '9/1/2012', freq='WOM-3FRI') #third Friday of each month


# In[ ]:




# In[ ]:

#time zone object
tz_hk = pytz.timezone('Asia/Hong_Kong')
tz_syd = pytz.timezone('Australia/Sydney')
tz_utc = pytz.timezone('UTC')


# In[ ]:

#construct trade time
tt_trade1 = datetime(2015, 6, 7, 9, 30, 0, 10000)
tt_trade2 = datetime(2015, 6, 7, 16, 0, 0, 20000)
print tt_trade1
print tt_trade2


# In[ ]:

#convert to timestamp at differnt time zone
tt_hk1 = tz_hk.localize(tt_trade1) #Hong Kong time zone trade time
ts_hk1 = int(calendar.timegm(tt_hk1.timetuple())) #timestamp at Hong Kong time zone
tt_hk2 = tz_hk.localize(tt_trade2)
ts_hk2 = int(calendar.timegm(tt_hk2.timetuple()))
print tt_hk1, ts_hk1, tt_hk2, ts_hk2
#convert Hong Kong time zone trade time to Sydney time zone trade time
tt_syd1 = tt_hk1.astimezone(tz_syd)
ts_syd1 = int(calendar.timegm(tt_syd1.timetuple()))
tt_syd2 = tt_hk2.astimezone(tz_syd)
ts_syd2 = int(calendar.timegm(tt_syd2.timetuple()))
print tt_syd1, ts_syd1, tt_syd2, ts_syd2

print tt_syd1.weekday()


# In[ ]:

#test steps

#step 1: confirm consistency of onetick timestamp value and IPython displayed timestamp value

#step 2: convert timestamp of first record to datetime
#        assume timestamp = 1433669400 (2015-06-07 09:30:00)
ts_1st = 1433669400 #put IPython displayed timestamp value here
tt_1st = datetime.utcfromtimestamp(ts_1st) 
print 'trade time = ',tt_1st

#step 3: from tt_1st value, determine it's represented time zone
#        if tt_1st = 01:30:00, it represents UTC time zone
#        if tt_1st = 09:30:00, it represents Hong Kong time zone
#        if tt_1st = 11:30:00 or 12:30:00, it represents Sydney time zone

#step 4: from step 3 results, set correct trade time and timestamp
#        if UTC time zone
tt_trade1 = datetime(2015, 6, 7, 9, 30, 0)
tt_hk1 = tz_hk.localize(tt_trade1) #Hong Kong time zone trade time
tt_utc1 = tt_hk1.astimezone(tz_utc) #convert to UTC time zone
ts_utc1 = int(calendar.timegm(tt_utc1.timetuple())) #ts_utc1 is used for time bucket allocation
print 'UTC: ',tt_utc1, ts_utc1

#        if Hong Kong time zone
tt_trade1 = datetime(2015, 6, 7, 9, 30, 0)
tt_hk1 = tz_hk.localize(tt_trade1) #Hong Kong time zone trade time
ts_hk1 = int(calendar.timegm(tt_hk1.timetuple())) #ts_hk1 is used for time bucket allocation
print 'HK: ',tt_hk1, ts_hk1

#        if Sydney time zone
tt_trade1 = datetime(2015, 6, 7, 9, 30, 0)
tt_hk1 = tz_hk.localize(tt_trade1) #Hong Kong time zone trade time
tt_syd1 = tt_hk1.astimezone(tz_syd) #convert to Sydney time zone
ts_syd1 = int(calendar.timegm(tt_syd1.timetuple())) #ts_syd1 is used for time bucket allocation
print 'SYD: ',tt_syd1, ts_syd1



# In[ ]:



