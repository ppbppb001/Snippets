
# coding: utf-8

# In[ ]:

"""
Common Pandas manipulations

"""


# In[1]:

import pandas as pd
import numpy as np


# In[3]:

# series
obj = pd.Series([1, 2, 3, 6], index=['b', 'c', 'd', 'a'])


# In[25]:

# series - create dataframe from series
mcount = 100

sts = pd.Series(np.arange(100000, 100000+mcount))
sts.name = 'TS'
strade_id = pd.Series(np.arange(0, mcount))
strade_id.name = 'TradeID'

x = np.int32((np.random.randn(mcount)+5)*100)
x = x/100.0
sprice= pd.Series(x)
sprice.name = 'Price'

dfall = pd.DataFrame(sts).join(pd.DataFrame(strade_id)).join(pd.DataFrame(sprice))


# In[21]:

# generate and join several dataframes
df1 = pd.DataFrame(np.random.randn(2,2), columns = ['A1', 'A2'])
df2 = pd.DataFrame(np.random.randn(3,2), columns = ['B1', 'B2'])
df3 = pd.DataFrame(np.random.randn(4,2), columns = ['C1', 'C2'])

dfx = df1.join(df2, how='outer').join(df3, how='outer')


# In[2]:

# sort dataframe
np.random.seed(0)
dfsrc = pd.DataFrame(np.random.randn(5,3), columns = ['C1', 'C2', 'C3'])

dfout1 = dfsrc.sort(columns='C2', ascending=False) #sort by C2 in descending order
dfout2 = dfsrc.sort_index(axis=0, ascending=False) #sort by row index in descending order


# In[61]:

# set index and remove a row
# set index
df1 = pd.read_csv("quote_nasdaq_aapl_m1_2011_onetick_ntc.csv")
df11 = df1[0:100]
df11_s = df11[df11.VOLUME<100000]
df11_s = df11_s.set_index(np.arange(0, len(df11_s), 1, dtype=np.int64))

# remove 3rd row
df11_r3 = df11_s.iloc[:3].append(df11_s.iloc[4:])


# In[16]:

# convert to datetime
ts = pd.to_datetime('2015-08-10 09:30')
print ts, ts.value

df = pd.DataFrame({'year': [2015, 2016],
                   'month': [2, 3],
                   'day': [4, 5]})
dfts = pd.to_datetime(df)


# In[55]:

# moving window, rolling
df1 = pd.read_csv('quote_nasdaq_aapl_m1_2011_onetick_ntc.csv')
df2x = df1
s1 = df2x['CLOSE']*df2x['VOLUME']
s2 = pd.rolling_sum(s1, 5)


# In[50]:

# groupby
np.random.seed(0)
df2 = pd.DataFrame({'key1': ['a', 'a', 'b', 'b', 'a'],
                    'key2': ['one', 'two', 'one', 'two', 'one'],
                    'data1': np.random.randn(5),
                    'data2': np.random.randn(5)})
print df2
g1 = df2.groupby('key1')
print list(g1)
g2 = df2['data1'].groupby(df2['key1'])
print list(g2)


# In[ ]:



