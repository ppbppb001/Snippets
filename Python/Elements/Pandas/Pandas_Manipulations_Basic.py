
# coding: utf-8

# In[1]:

import datetime as dt
from datetime import datetime
from datetime import time
from datetime import date
import time as tm
import numpy as np
import pandas as pd


# ====================
#  目录：
# ====================
# 
# In [3]:
#     #-----------------------
#     # 实验-1
#     #-----------------------
#     # 按条件截取子DataFrame
# 
# In [4]:
#     #-----------------------
#     # 实验-2
#     #-----------------------
#     # 重新整理index of DataFrame
#     
# In [5]:
#     #-----------------------
#     # 实验-3
#     #-----------------------
#     # List -> DataFrame
#     
# In [6]:
#     #-----------------------
#     # 实验-4
#     #-----------------------
#     # 在DataFrame末尾添加一行drow1
# 
# In [7]:
#     #-----------------------
#     # 实验-5
#     #-----------------------
#     # 删除一行或者多行
#     
# In [8]:
#     #-----------------------
#     # 实验-6
#     #-----------------------
#     # 组合Columns
#     
# In [9]:
#     #-----------------------
#     # 实验-7
#     #-----------------------
#     # 手工生成DataFrame和Series
# 
# In [10]:
#     #-----------------------
#     # 实验-8
#     #-----------------------
#     # 纵向(row by row)和横向(col by col)拼接
# 
# In [11]:
#     #-----------------------
#     # 实验-9
#     #-----------------------
#     # 增加新的一列(Add one new column )
#     # 以df1为例，在其中增加一列ns数据
#         
# In [12]:
#     #-----------------------
#     # 实验-10.1
#     #-----------------------
#     # DataFrame排序In [13]:
#     
# In [13]:
#     #-----------------------
#     # 实验-10.2
#     #-----------------------
#     # Series排序
# 
# In [14]:
#     #-----------------------
#     # 实验-10.3
#     #-----------------------
#     # List排序

# In[2]:

# 读入测试数据
df1 = pd.read_csv("quote_nasdaq_aapl_m1_2011_onetick_ntc.csv")
df1.head()

# 取测试数据的前100行作为实验数据
df11 = df1[0:100]     # df11=实验源数据


# In[3]:

#-----------------------
# 实验-1
#-----------------------
# 按条件截取子DataFrame

df11_s = df11[df11.VOLUME < 100000]   # df11_s的类型为DataFrame
print 'len(df11_s) =',len(df11_s)
print 'df11_s:\n',df11_s.head(5)      
print

s1 = df11_s.iloc[0]                   # s1=第一行，类型=Series
f1 = pd.DataFrame([s1])               # 由Series:s1生成DataFrame:f1 
print 'type(f1) =',type(f1)
print 'f1:\n',f1

# 注意： df11_s的index不是连续的，而是等于df11中的对应数据行


# In[4]:

#-----------------------
# 实验-2
#-----------------------
# 重新整理index of DataFrame

# 利用np.arange(start,stop,step,dtype)来生成顺序index
df11_s = df11_s.set_index(np.arange(0,len(df11_s),1,dtype=np.int64)) #0->len(df11_s)-1

print df11_s.head(10)  #显示前10行


# In[5]:

#-----------------------
# 实验-3
#-----------------------
# List -> DataFrame

# row1 = List of column data collections
row1 = [df11_s.DATE[0], 
        df11_s.TIME[0], 
        df11_s.TIMESTAMP[0], 
        df11_s.OPEN[0], 
        df11_s.HIGH[0], 
        df11_s.LOW[0], 
        df11_s.CLOSE[0], 
        df11_s.VOLUME[0]]
print 'type(row1) = ',type(row1)
print 'row1 = ',row1
print

# drow1 = 由row1 list生成的一行的DataFrame
drow1 = pd.DataFrame([row1])
drow1.columns = df11_s.columns
print 'type(drow1) = ',type(drow1)
print 'drow1:\n',drow1
print


# In[6]:

#-----------------------
# 实验-4
#-----------------------
# 在DataFrame末尾添加一行drow1

dfy = df11_s.append(drow1,ignore_index=True)  # append drow1 to the tail of df11_s
print 'dfy:\n',dfy.tail()

# 注意：添加了drow1后的dfy最后一行序号为0，即drow1自己的行号
# 应该使用<实验-2>中的方法重新整理index后再进行其他操作


# In[7]:

#-----------------------
# 实验-5
#-----------------------
# 删除一行或者多行

# 删除一行：第1行
df11_r1 = df11_s.iloc[1:]
print 'df11_r1: (remove #0 row)\n',df11_r1.head(5)
print

# 删除一行：第3行
df11_r3 = df11_s.iloc[:3].append(df11_s.iloc[4:])
print 'df11_r3: (remove #3 row)\n',df11_r3.head(6)

# 剔除三行：第2-4行
df11_r4 = df11_s.iloc[:2].append(df11_s.iloc[5:])
print 'df11_r4: (remove #2,#3,#4 rows)\n',df11_r4.head(6)


# 注意：删除末几行后，index不会重新排列
# 如有需要，可使用<实验-2>中的方法重新整理index后再进行其他操作


# In[8]:

#-----------------------
# 实验-6
#-----------------------
# 组合Columns

# 不同行的Columns组合成一个新行
s1 = df11_s.iloc[0][0:3]    # Series:s1 = row_0,col_0-2
s2 = df11_s.iloc[1][3:8]    # Series:s2 = row_1,col_3-7
s3 = s1.append(s2)          # Series:s3 = s1+s2
f3 = pd.DataFrame([s3])     # Series:s3 -> DataFrame:f3
print 'f3: as one new row(dataframe)\n',f3
print

# 组合的新行添加到原DataFrame末尾, 并自动适应index
df11_s = df11_s.append(f3, ignore_index = True)  #一定包括 ignore_index=True
print 'df_11s.tail(): one new row appened to the end\n',df11_s.tail()


# In[9]:

#-----------------------
# 实验-7
#-----------------------
# 手工生成DataFrame和Series

# <7.1> 生成只有一行三列的DataFrame,
#并初始化为0:
dfZero = pd.DataFrame([np.full(3,0)])      # Filled with zeros
dfZero.columns = ['Col1','Col2','Col3']    # Assign column names
print 'DataFrame initialized with all zeros:\n',dfZero
print

#并初始化为Nan:
dfNan = pd.DataFrame([np.full(3,np.nan)])  # Filled with Nans
dfNan.columns = ['Col1','Col2','Col3']     # Assign column names
print 'DataFrame initialized with all Nans:\n',dfNan
print


# <7.2> 由其他DataFrame的数据单元生成DataFrame:f1
# List:x = names of column
x = [df11_s.columns.values[0], 
     df11_s.columns.values[2], 
     df11_s.columns.values[4]] 
# Series:s = list of values
s = pd.Series([df11_s.iloc[0][0], 
               df11_s.iloc[0][2], 
               df11_s.iloc[0][4]])
f1 = pd.DataFrame([s])    # Series:s -> DataFrame:f1
f1.columns = x            # f1 is assigned with column names
print 'f1: DataFrame ',type(f1)
print f1
print 


# <7.3> 用np.arange生成数字序列Series:s2
s2 = pd.Series(np.arange(0,100,1,dtype=np.int64))
print 's2: Series ',type(s2)
print s2.head(),'\n',s2.tail()
print


# <7.4> 用np.arange生成数字序列DataFrame:f2
f2 = pd.DataFrame([np.arange(0,100,1,dtype=np.int64)])
print 'f2: DataFame ',type(f2)
print f2


# In[10]:

#-----------------------
# 实验-8
#-----------------------
# 纵向(row by row)和横向(col by col)拼接

dfp1 = df1.iloc[0:5]    #提取子DataFrame:dfp1 = row0-4
dfp2 = df1.iloc[4:9]    #提取子DataFrame:dfp2 = row4-8

#纵向拼接: row by row, sorted by index
dfm1 = dfp1.append(dfp2)  #拼接
                          #因dfp1,dfp2的column name相同
                          #按行index进行排序并拼接
dfm1 = dfm1.set_index(np.arange(0,len(dfm1),1,np.int64))  #重置index
print '纵向拼接: dfm1'
print dfm1
print

#横向拼接: col by col, sorted by index
dfp1 = dfp1.set_index(np.arange(0,len(dfp1),1,dtype=np.int64)) #重置序号
dfp2 = dfp2.set_index(np.arange(0,len(dfp2),1,dtype=np.int64)) #重置序号
# ------
# case-1: dfp1,dfp2 column name相同
dfm2 = dfp1.join(dfp2,lsuffix='-L',rsuffix='-R')      #拼接
print '横向拼接-1: dfm2'
print dfm2
print
# ------
# case-2: dfp1,dfp2 column name 不同
dfp2.columns = ['C1', 'C2 ', 'C3','C4','C5','C6','C7','C8']  #设置dfp2的column名
dfm3 = dfp1.join(dfp2)       #拼接
                             #因dfp1,dfp2的行index相同，column name不同
                             #按行index进行排序并按column横向拼接
print '横向拼接-2: dfm3'
print dfm3



# 注意：
# Pandas的DataFrame join功能，是按行Index和ColumnName进行排序后再拼接
# 行拼接(row by row)必须保证column名称数量相同，
# 列拼接要保证row index相同，column name不同
# 因此要特别注意column名和重置index


# In[11]:

#-----------------------
# 实验-9
#-----------------------
# 增加新的一列(Add one new column )
# 以df1为例，在其中增加一列ns数据

# 如何生成实验副本DataFrame
dfx1 = df1.copy()  # (1) dfx1 = df1.copy()的含义：dfx1=df1的副本，即一个新的拷贝
                   #     dfx1上的任何操作不会改变df1里面的内容
                   # (2) dfx1 = df1，那么dfx1只是reference of df1
                   #     dfx1上的任何修改直接影响df1

# 提取Column:TIMESTAMP，并生成新的Series:ns
# 以Series:ns为待插入列
sns = dfx1['TIMESTAMP'] % int(1e9)   #Series:sns = ns part of TIMESTAMP

# (9.1) 插入到DataFrame末尾
dfx1 = df1.copy()
dfx1['NS'] = sns
print '(9.1)\n',dfx1.head()
print

# (9.2) 插入到DataFrame开始
dfx1 = df1.copy()
dfx1.insert(0,'NS',sns)
print '(9.2)\n',dfx1.head()
print

# (9.3) 插入到DataFrame的TIMESTAMP列之后(colindex=3)
dfx1 = df1.copy()
dfx1.insert(3,'NS',sns)
print '(9.3)\n',dfx1.head()
print

# (9.4) 生成新数据列并插入
dfx1 = df1.copy()
lx = []                       # 空List
for i in range(len(dfx1)):    # 生成List数据，List长度=len(dfx1)
    lx.append(i*4+3)
sx = pd.Series(lx)            # List:lx -> Series:sx
dfx1.insert(3,'X',sx)
print '(9.4)\n',dfx1.head()


# In[12]:

#-----------------------
# 实验-10.1
#-----------------------
# DataFrame排序

# 用随机数生成5行3列的测试源DataFrame:dfSrc
dfSrc = pd.DataFrame(np.random.randn(5,3),columns=['C1','C2','C3'])
print 'Source DataFrame:\n',dfSrc
print 

# 按列C1升序
dfOut = dfSrc.sort_values('C1',ascending=True)
print 'Sort: Ascending by column C1\n',dfOut
print


# 按列C2降序
dfOut = dfSrc.sort_values('C2',ascending=False)
print 'Sort: Descending by column C2\n',dfOut
print

# 按列C3降序, 改变原DataFrame:dfSrc
dfSrc.sort_values('C3',ascending=False,inplace=True)
print 'Sort: Descending by column C3, inplace=True\n',dfSrc
print

# 按index of row降序, 改变原DataFrame:dfSrc
dfSrc.sort_index(axis=0,ascending=False,inplace=True) #axis=0: by row index
print 'Sort: Descending by row index, inplace=True\n',dfSrc
print

# 按index of column降序, 改变原DataFrame:dfSrc
dfSrc.sort_index(axis=1,ascending=False,inplace=True)  #axis=1: by column index
print 'Sort: Descending by column index, inplace=True\n',dfSrc


# In[13]:

#-----------------------
# 实验-10.2
#-----------------------
# Series排序

# 用随机数生成5行3列的测试源Series:seSrc
seSrc = pd.Series(np.random.randn(10),name='C1')
print 'Source Series:\n',seSrc
print 

# 数值降序 (descending by values)
seSrc.sort_values(axis=0,ascending=False)  #缺省是inplace=True
print 'Sort: Descending by values\n',seSrc
print

# 数值升序 (ascending by values)
seSrc.sort_values(axis=0,ascending=True)  #缺省是inplace=True
print 'Sort: Ascending by values\n',seSrc
print

# 索引降序 (descending by index)
seSrc = seSrc.sort_index(ascending=False)  #inplace=False
print 'Sort: Descending by index\n',seSrc
print

# 索引升序 (ascending by index)
seSrc = seSrc.sort_index(ascending=True)  #inplace=False
print 'Sort: Ascending by index\n',seSrc


# In[14]:

#-----------------------
# 实验-10.3
#-----------------------
# List排序

# 生成包含10个随机数的List:lsSrc
lsSrc = list(np.random.rand(10))
print 'Source List:\n',lsSrc
print

# 降序
lsSrc.sort()         #升序ascending
lsSrc = lsSrc[::-1]  #倒置reverse
print 'Sort: Descending\n',lsSrc
print

# 升序
lsSrc.sort()
print 'Sort: Ascending\n',lsSrc

#注意: List的排序功能sort只支持升序！
#     如果要倒序，要分两步操作:
#     Step-1 升序: lsX.sort()
#     Step-2 倒置: lsX = lsX[::-1]


# In[ ]:



