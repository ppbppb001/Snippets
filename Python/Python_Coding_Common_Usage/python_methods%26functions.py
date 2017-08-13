
# coding: utf-8

# In[ ]:

"""
Python methods and functions
"""


# In[1]:

import pandas as pd
import numpy as np

import mydictclass as myclasses


# In[12]:

# list - sorting
np.random.seed(0)
lssrc = list(np.random.rand(10))

lssrc_s = sorted(lssrc)
lssrc
lssrc[::-1] #reverse


# In[1]:

# dictionary - basics
table = {'1975': 'Holy Grail',
         '1979': 'Life of Brian',
         '1983': 'The Meaning of Life'}

year= '1983'
movie = table[year]

for year in table:
    print(year +'\t'+table[year])


# In[12]:

# dictionary - construct dictionary
dfcodes = pd.read_csv('dicttest.csv')

dictcodes = {}
for idx, name in enumerate(dfcodes['name']):
    dictcodes[name] = dfcodes.ix[idx,1]


# In[19]:

# dictionary - manipulate with predefined class
stockcodes = ['AAPL', 'GOOG', 'MSFT', 'INTL', 'FB']

dx = myclasses.MyDict(stockcodes)
dictx = dx.GetDict()

dy = myclasses.MyDict([])
dy.AddCode(stockcodes)


# In[7]:

# create grid with for loop
grid = [[0 for i in range(3)] for j in range(5)]
ngrid = np.matrix(grid)
grid


# In[1]:

# lambda
strings = ['foo', 'card', 'bar', 'aaaa', 'abab']  # sort by number of distinct letters
strings.sort(key=lambda x:len(set(list(x))))
strings


# In[ ]:




# In[ ]:



