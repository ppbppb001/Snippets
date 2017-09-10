
# coding: utf-8

# In[1]:

import datetime as dt
from datetime import datetime
from datetime import time
from datetime import date
import time as tm
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

from IPython.display import Image  # 在cell中显示图片


# In[2]:

# 读入测试数据
dfAAPL = pd.read_csv("quote_nasdaq_aapl_m1_2011_onetick_ntc.csv")

# 取测试数据的前100行作为实验数据
dfSrc = dfAAPL[100:300]     # df11=实验源数据
dfSrc = dfSrc.set_index(np.arange(0,len(dfSrc),1,dtype=np.int64))
print 'dfSrc: len=',len(dfSrc)
print 'top 5 of dfSrc:\n',dfSrc.head()


# In[3]:

#---------------------------
# <Step-1>生成3个key column

# Key by Hours
seKeyH = pd.Series(np.int64(dfSrc['TIME']/100))  # Buckets created by Hours
seKeyH.name = 'KeyH'
print 'top 5 of KyeH:\n',seKeyH.head(),'\n'

# Key by OPEN/CLOSE
seKeyP = dfSrc['CLOSE']/dfSrc['OPEN']  # X=CLOSE/OPEN
seKeyP[seKeyP >= 1.0002] = 3
seKeyP[seKeyP <1.0 ] = 2
seKeyP[seKeyP < 2] = 1
seKeyP[seKeyP == 3] = 'P+' # P+: 1.0002<=X
seKeyP[seKeyP == 2] = 'P'  # P:  1.0=<X<=1.0002
seKeyP[seKeyP == 1] = 'P-' # P-: X<1.0
seKeyP.name = 'KeyP'
print 'top 5 of KyeP:\n',seKeyP.head(),'\n'

# key by Volume
seKeyV = dfSrc['VOLUME'] - np.int64(dfSrc['VOLUME'].mean())  # X = Vol - Vol.mean
seKeyV[seKeyV >= 0] = 'V+'  # V+: X>=0
seKeyV[seKeyV < 0] = 'V-'   # V-: X<0
seKeyV.name='KeyV'
print 'top 5 of KyeV:\n',seKeyV.head(),'\n'


# In[4]:

#-----------------------------------------
# <Step-2> 添加生成的3个Key columns到dfTest

dfTest = dfSrc.join(seKeyH).join(seKeyP).join(seKeyV)
print 'top 5 of dfTest:\n',dfTest.head()


# In[5]:

#-----------------------------------------
# <Step-3> 
# 用上面生成的3个Keys对dfTest进行GroupBy操作
# 生成dfTest的groupby对象gpTest

gpTest = dfTest.groupby(['KeyH','KeyP','KeyV'])
print 'type(gpTest) = ',type(gpTest)


# In[6]:

#---------------
# 实验-1
#---------------
# CLOSE.count() by stacked keys: keyH,KeyP,KeyV

dfCloseA = pd.DataFrame(gpTest.CLOSE.count())   #输出count of CLOSE
print dfCloseA


# In[7]:

# 绘图输出 dfCloseA
dfCloseA.plot(kind='bar',stacked=True)
plt.show()


# In[8]:

# Image(filename='figure_closea.png')


# In[9]:

#---------------
# 实验-2
#---------------
# CLOSE.count() by stacked keys: KeyH,KeyV
# keyV is unstacked (row -> col)

dfCloseB = gpTest.CLOSE.count().unstack(['KeyP'])  # unstack keyP
print dfCloseB


# In[10]:

# 绘图输出 dfCloseB
dfCloseB.plot(kind='bar',stacked=True)
# dfCloseB.plot(kind='bar',stacked=False)

plt.show()


# In[11]:

# Image(filename='figure_closeb.png')


# In[12]:

#---------------
# 实验-3
#---------------
# CLOSE.count() ONLY by key: KeyH
# keyP/keyV are unstacked (rows -> cols)

dfCloseC = gpTest.CLOSE.count().unstack(['KeyP','KeyV'])  # unstack KeyP/KeyV
print dfCloseC


# In[13]:

# 绘图输出 dfCloseC
dfCloseC.plot(kind='bar',stacked=True)
plt.show()


# In[14]:

# Image(filename='figure_closec.png')


# In[15]:

#---------------
# 实验-4
#---------------
# 只用KeyH/KeyP两组key对dfTest进行groupby

gpTest2 = dfTest.groupby(['KeyH','KeyP'])


# In[16]:

#---------------
# 实验-4.1
#---------------
# 直接显示

dfCloseA2 = pd.DataFrame(gpTest2.CLOSE.count())   #输出count of CLOSE
print dfCloseA2


# In[17]:

dfCloseA2.plot(kind='bar',stacked=True)
plt.show()


# In[18]:

# Image(filename='figure_closea2.png')


# In[19]:

#---------------
# 实验-4.2
#---------------
# unstack KeyP

dfCloseC2 = gpTest2.CLOSE.count().unstack(['KeyP'])  # unstack KeyP
print dfCloseC2


# In[20]:

dfCloseC2.plot(kind='bar',stacked=True)
plt.show()


# In[21]:

# Image(filename='figure_closec2.png')


# In[22]:

#---------------
# 实验-5
#---------------
# 计算输出结果DF的寻址(多重index)

dfCloseC = gpTest.CLOSE.count().unstack(['KeyP','KeyV'])  # unstack KeyP/KeyV
print 'dfCloseC:\n',dfCloseC
print

#Row=2,Col=1
print '[row=2,col=1] by iloc[1,0] = ',dfCloseC.iloc[1,0]  
print '[row=3,col=1] by iloc[2,0] = ',dfCloseC.iloc[2,0]


# In[23]:

#---------------
# 实验-6
#---------------
# Fill NaN

print 'INPUT = dfCloseC:\n',dfCloseC    # dfCloseC 做为测试DF
print

# 方法-1: fillna并赋值
dfCloseX = dfCloseC.copy()              # dfCloseX=dfCloseC的副本，用于测试
dfCloseX = dfCloseX.fillna(value=0)
print 'OUTPUT1 = dfCloseX:\n',dfCloseX
print

# 方法-2: fillna并修改原DF
dfCloseX = dfCloseC.copy()              # dfCloseX=dfCloseC的副本，用于测试
dfCloseX.fillna(value=0,inplace=True)
print 'OUTPUT2 = dfCloseX:\n',dfCloseX
print


# In[24]:

#---------------
# 实验-7
#---------------
# 多重索引的排序

dfCloseA2 = dfCloseA.copy()
print 'Before sorting:\n',dfCloseA2
dfCloseA2 = dfCloseA2.unstack(['KeyP','KeyV'])
print 'unstacked:\n',dfCloseA2
print

dfCloseA2 = dfCloseA.copy()
# dfCloseA2.sortlevel(level=1,ascending=False,sort_remaining=False,inplace=True) #按KeyP降序 # Obsoleted!!!
dfCloseA2.sort_index(level=1,ascending=False,sort_remaining=False,inplace=True) #按KeyP降序
print 'After sorting:\n',dfCloseA2
dfCloseA2 = dfCloseA2.unstack(['KeyP','KeyV'])
print 'unstacked:\n',dfCloseA2


# In[ ]:



