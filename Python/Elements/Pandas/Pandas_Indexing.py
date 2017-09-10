
# coding: utf-8

# In[1]:

import datetime
import time
import calendar
import pytz
import pandas as pd
import numpy as np
import matplotlib


# In[2]:

# df1 = pd.read_csv("quote_nasdaq_aapl_m1_2011.csv")
# dlen = len(df1)
# print dlen


# In[3]:

#---------------------------------------------------
# Load a CSV file to a DataFrame
#---------------------------------------------------

print "Load CSV to DataFrame:"
df1 = pd.read_csv("quote_nasdaq_aapl_m1_2011_v2.csv")
print "df_len =",len(df1)


# In[4]:

#-------------------------------
# Test-1: Select single column
#-------------------------------
# Column = VOLUME

# by column name
sel = df1.loc[:,"VOLUME"]
print "Test-1.1:\n",sel,"\n"

# by coulumn index
sel = df1.iloc[:,7]    # col-7=VOLUME
print "Test-1.2:\n",sel,"\n"

# by column name
sel = df1["VOLUME"]
print "Test-1.3:\n",sel,"\n"

# by dataframe property
sel = df1.VOLUME
print "Test-1.4:\n",sel,"\n"


# In[5]:

#---------------------------------
# Test-2: Select multiple columns 
#---------------------------------
# Column = OPEN,CLOSE,VOLUME

# by column names
sel = df1.loc[:,["OPEN","CLOSE","VOLUME"]]
print "Test-2.1:\n",sel,"\n"

# by column indices
sel = df1.iloc[:,[3,6,7]]     # Col-3=OPEN, Col-6=CLOSE, Col-7=VOLUME
print "Test-2.2:\n",sel,"\n"

#  by column indices
sel = df1.iloc[[3,6,7]]     # Col-3=OPEN, Col-6=CLOSE, Col-7=VOLUME
print "Test-2.3:\n",sel,"\n"


# In[6]:

#---------------------------------
# Test-3: Select range of rows
#---------------------------------

# Sample-1: by index of row ................

# Method-1:
sel = df1[0:10]  # row-0 to row-9
print "Test-3.1.1:\n",sel,"\n"

# Method-2:
sel = df1.iloc[0:9,:] # row-0 to row-9
print "Test-3.1.2:\n",sel,"\n"


# Sample-2: by index of row with multiple columns ................

# Method-1: columns by name
sel = df1.loc[0:9,["OPEN","CLOSE","VOLUME"]]
print "Test-3.2.1:\n",sel,"\n"

# Method-2: columns by index
sel = df1.iloc[0:9,[3,6,7]]
print "Test-3.2.2:\n",sel,"\n"

# Method-3: columns by range
sel = df1.iloc[0:9,3:8]  # row0-9,col3-7
print "Test-3.2.3:\n",sel,"\n"


# In[7]:

#--------------------------------------
# Test-4: Select multiple rows by index
#--------------------------------------

sel = df1.iloc[[0,2,4,6],:]
print "Test-4.1:\n",sel,"\n"

sel = df1.iloc[[0,2,4,6],3:8]
print "Test-4.2:\n",sel,"\n"

sel = df1.iloc[[0,2,4,6],[3,6,7]]
print "Test-4.3:\n",sel,"\n"

sel = df1.loc[[0,2,4,6],["OPEN","CLOSE","VOLUME"]]
print "Test-4.4:\n",sel,"\n"


# In[8]:

#---------------------------------
# Test-5: Select by conditions
#---------------------------------

# Select rows by conditions
sel = df1[(df1.TIME>=1000) & (df1.TIME<1005)]    # All of the records from 10:00 to 10:05
print "Test-5.1.1:\n",sel,"\n"

sel = df1.loc[(df1.TIME>=1000) & (df1.TIME<1005),:]    # All of the records from 10:00 to 10:05
print "Test-5.1.2:\n",sel,"\n"

sel = df1.loc[(df1.CLOSE>=400) & (df1.CLOSE<405),:]    # All of the records with CLOSE from 400.00 to 405.00
print "Test-5.1.3:\n",sel,"\n"

# Select rows by conditions and columns by series
sel = df1.loc[(df1.TIME>=1000) & (df1.TIME<1005),["OPEN","CLOSE","VOLUME"]]    # All of the records from 10:00 to 10:05 with OPEN/CLOSE/VOLUME
print "Test-5.2.1:\n",sel,"\n"


# In[9]:

sel = df1.loc[(df1.CLOSE>=400) & (df1.CLOSE<405),["DATE","CLOSE","VOLUME"]]    # All of the records with CLOSE from 400.00 to 405.00
print "Test-5.2.3:\n",sel,"\n"


# In[10]:

sel = df1[(df1.index>=814) & (df1.TIME>=1000) & (df1.TIME<1005)]    # All of the records from 10:00 to 10:05
print "Test-5.1.1:\n",sel,"\n"
print sel.index
print sel.index[0], sel.index[len(sel)-1]


# In[11]:

df2=df1[0:10]   # Actually no copying happened! df2 is only referenced to part of df1 by given range
print df2


# In[12]:

df1.loc[1,"VOLUME"] += 10   # one cell of df1 is modified
print df1.loc[1,"VOLUME"]  # check the change
print df2                 # the corresponding cell in df2 should be changed as well

