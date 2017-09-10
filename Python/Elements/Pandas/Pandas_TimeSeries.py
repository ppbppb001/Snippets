
# coding: utf-8

# In[1]:

import datetime as dt           #将datetime库的name_space改为dt
from datetime import datetime   #从datetime库导入datetime对象
from datetime import time       #从datetime库导入time对象
import calendar
import time as tm               #将time库的name_space改为tm
import pytz
import pandas as pd             #将pandas库的name_space改为pd
import numpy as np              #将numpy库的name_space改为np
import matplotlib.pyplot as plt #将matplotlib.pyplot的name_space改为plt


# In[2]:

#---------------------------------------------------
# Timestamp of Pandas  (Part-1)
#---------------------------------------------------

# 创建Timestamp .....................................
# 无时区属性
ts1 = pd.to_datetime('1970-01-01 02:00:00')       #方法-1
# ts1 = pd.to_datetime(datetime(1970,1,1,2,0,0))  #方法-2
# ts1 = pd.Timestamp('1970-01-01 02:00:00')       #方法-3
print 'ts1: ',ts1,type(ts1),'|',ts1.value,type(ts1.value)

# 时区=香港
ts2 = pd.to_datetime('1970-01-01 10:00:00').tz_localize('Asia/Hong_Kong')    #方法-1
# ts2 = pd.to_datetime(datetime(1970,1,1,10,0,0)).tz_localize('Asia/Hong_Kong')  #方法-2
# ts2 = pd.Timestamp('1970-01-01 10:00:00',tz='Asia/Hong_Kong')                #方法-3
print 'ts2: ',ts2,type(ts2),'|',ts2.value,type(ts2.value)

# 时区=悉尼
ss = str.format('%4.4d-%2.2d-%2.2d %2.2d:%2.2d:%2.2d' % (1970,1,1,12,0,0))  #从整数创建时间字符串
ts3 = pd.to_datetime(ss).tz_localize('Australia/Sydney')
# ts3 = pd.Timestamp(ss,tz='Australia/Sydney')
print 'ts3: ',ts3,type(ts3),'|',ts3.value,type(ts3.value)


# Timestamp时区变换 ....................................
ts4 = ts3.tz_convert('UTC')
print 'ts4: ',ts4,type(ts4),'|',ts4.value,type(ts4.value)


# Pandas Timestamp -> Python DateTime ..................
tt2 = ts2.to_pydatetime()
print 'tt2: ',tt2,type(tt2)

# 四个pandas timestamp: ts1,ts2,ts3,ts4
# ts1: 无时区信息
# ts2: 时区=香港
# ts3: 时区=悉尼
# ts4: 时区=UTC
# 注意：四个timestamp的value都相同：
#      ts1.value=ts2.value=ts3.value=ts4.value = 2h x 3600s x 1e9ns 


# In[3]:

#---------------------------------------------------
# Timestamp of Pandas  (Part-2)
#---------------------------------------------------
#整数 -> pandas timestamp

tseconds = 36000    # 10h x 3600s = 36000s

ts0 = pd.to_datetime(tseconds,unit='s')     #输入整数单位=秒
print 'ts0: ',ts0,'| timestamp =',ts0.value   #ts0时区=无

ts1 = ts0.tz_localize('UTC')              #ts1 = ts0 + UTC时区信息
print 'ts1: ',ts1,'| timestamp =',ts1.value  #ts1时区=UTC

ts2 = ts1.tz_convert('Asia/Hong_Kong')    #ts2 = ts1时区属性修改为香港
print 'ts2: ',ts2,'| timestamp =',ts2.value  #ts2时区=香港

ts3 = ts1.tz_convert('Australia/Sydney')    #ts3 = ts1时区属性修改为悉尼
print 'ts3: ',ts3,'| timestamp =',ts3.value  #ts3时区=悉尼

# 四个pandas timestamp: ts0,ts1,ts2,ts3
# ts0: 无时区信息
# ts1: 时区=UTC
# ts2: 时区=香港
# ts3: 时区=悉尼
# 注意：四个timestamp的value都相同：
#      ts0.value=ts1.value=ts2.value=ts3.value = 10h x 3600s x 1e9ns 


# In[4]:

#---------------------------------------------------
# Timestamp of Pandas  (Part-3)
#---------------------------------------------------
# 杂项
#---------------------------------------------------

# 日期偏移
tpd = pd.to_datetime(datetime(2012,11,1)).tz_localize('UTC').tz_convert('Asia/Hong_Kong')
print 'tpd:',tpd
print 'tpd+3days: ',tpd + pd.tseries.offsets.Day(3)
print 'tpd->end of month: ',tpd + pd.tseries.offsets.MonthEnd()


# In[5]:

#---------------------------------------------------
# Load a CSV file to DataFrame
#---------------------------------------------------

print "Load CSV to DataFrame:"
df1 = pd.read_csv("quote_nasdaq_aapl_m1_2011_v2.csv")
print "df_len =",len(df1)


# In[6]:

#---------------------------------------------------
# DateTimeIndex of Pandas (Part-1)
#----------------------------------
# 创建DateTimeIndex
#---------------------------------------------------

tsvals = df1.TIMESTAMP.values   #tsvals=df1的TIMESTAMP列的数值列表(List)

# 从数值列表tsvals生成TimeStampIndex索引：
# 指定输入值列表tsvals的单位是s，时区是UTC
# 变换结果tsind是pandas的DateTimeIndex，单位是ns
tsind = pd.to_datetime(tsvals,unit='s').tz_localize('UTC')  #tsind = DateTimeIndex(单位=ns)
print '> timezone = UTC:\n',tsind

tsind = tsind.tz_convert('Asia/Hong_Kong')  #将tsind的时区设置为香港
print '> timezone = HK:\n',tsind

# 注意：
# 示范数据文件里面的TIMESTAMP定义自美国东部交易时间09:30-15:59
# 为仿真OneTick数据，假设其为UTC时区，再变换到香港时区
# 所以最终显示出来的是DateTimeIndex是17:30-23:59


# In[7]:

#---------------------------------------------------
# DateTimeIndex of Pandas (Part-2)
#---------------------------------
# 用DateTimeIndex重置DataFrame的索引
#---------------------------------------------------

# 利用Part-1生成的DateTimeIndex tsind来创建新的DataFrame df2，保留df1不变
df2 = df1.set_index(tsind)   

print '[Source: df1]\n',df1.head()  #df1头5行
print 'df1_len:',len(df1)   #df1长度

print '[Output: df2]\n',df2.head()  #df2头5行
print 'df2_len:',len(df2)   #df2长度

# 读取DataFrame的DateTimeIndex
tsindx = df2.index
print '[tsindx]:\n',tsindx


# In[8]:

#---------------------------------------------------
# DateTimeIndex of Pandas (Part-3)
#---------------------------------
# 杂项
#---------------------------------------------------

# 生成DateTimeIndex: 2015-02-01开始的100个日历天,interval=1天
tsindx1 = pd.date_range('2015-02-01',periods=100,freq='1D')
print '> 100 calendar days from 2015-02-01:\n',tsindx1

# 生成DateTimeIndex: 2015-02-01开始的100工作日,interval=1天
tsindx2 = pd.date_range('2015-02-01',periods=100,freq='1B')
print '> 100 business days from 2015-02-01:\n',tsindx2



# In[9]:

#---------------------------------------------------
# DataFrame indexed by DateTimeIndex
#-----------------------------------
# indexing/selecting
#---------------------------------------------------

# 时间字串生成select条件:
dfx = df2['2011-01-03 17:30:00' : '2011-01-03 17:40:00']          #方法-1        
# dfx = df2.loc['2011-01-03 17:30:00' : '2011-01-03 17:40:00']      #方法-2

# Python datetime.datetime()生成select条件:
dfx = df2[datetime(2011,1,3,17,30) : datetime(2011,1,3,17,40)]    #方法-1
# dfx = df2.ix[datetime(2011,1,3,17,30) : datetime(2011,1,3,17,40)] #方法-2 
# dfx = df2.loc[datetime(2011,1,3,17,30) : datetime(2011,1,3,17,40)] #方法-3

# Pandas timestamp数值(ns)生成select条件:
dfx = df2[pd.to_datetime(1294047000*1e9) : pd.to_datetime(1294047600*1e9)]  #方法-1
# dfx = df2.loc[pd.to_datetime(1294047000*1e9) : pd.to_datetime(1294047600*1e9)]  #方法-2

# 筛选每天指定时间段的数据
# 方法-1
dfx = df2.between_time(start_time='17:30',end_time='17:32',include_end=False)
# 方法-2： 可支持整数变量
h=17; m1=30; m2=32
tstr1 = str(h)+':'+str(m1)
tstr2 = str(h)+':'+str(m2)
dfx = df2.between_time(start_time=tstr1,end_time=tstr2,include_end=False)

# 输出结果
dfx

#注意: 上述几种select方法输出的df3完全相同


# In[10]:

#---------------------------------------------------
# DataFrame Resample
#-----------------------------------
# Downsampling
#---------------------------------------------------

# <Step-1> 
# df2feb: 截取的2月份数据
df2feb = df2['2011-02-01':'2011-02-28']

# <Step-2.1> 
# df3c: 由df2feb.CLOSE生成的只有一列的DataFrame
#       Frequency: 1min to 10min, sampling_method=mean (for close price)
df3c = df2feb[['CLOSE']].resample(rule='10T',how='mean')                 #方法-1
# df3c = pd.DataFrame(df2feb['CLOSE']).resample(rule='10T',how='mean')   #方法-2

# <Step-2.2>
# df3v: 由df2feb.VOLUME生成的只有一列的DataFrame
#       Frequency: 1min to 10min, sampling_method=sum (for volume value)
df3v = df2[['VOLUME']].resample(rule='10T',how='mean')                #方法-1
# df3v = pd.DataFrame(df2['VOLUME']).resample(rule='10T',how='sum')   #方法-2

# <Step3>
# 输出
# df3x = df3c            # 只输出df3c (dataframe of CLOSE)
# df3x = df3v            # 只输出df3v (dataframe of VOLUME)
df3x = df3c.join(df3v)   # 合并df3c,df3v后再输出

# <Step4>
# df3x: 提取指定时段，不包括时段右边界(include_end=False)
df3x = df3x.between_time(start_time='17:30:00',end_time='23:00:00',include_end=False)
df3x


#注意：为了使用join和resample方法，必须保证column提取的输出结果为DataFrame类型
#     x = df2[['CLOSE']]  : x为pd.DataFrame类型，column数量=1
#     x = df2['CLOSE']    : x为pd.Series类型，是一维序列


# In[11]:

#---------------------------------------------------
# DataFrame Resample
#-----------------------------------
# Upsampling (CLOSE price)
#---------------------------------------------------

# <Step-1>
# df2feb: 截取的2月份数据
df2feb = df2['2011-02-01':'2011-02-28']

# <Step-2.1>
# 由df2feb.CLOSE生成的只有一列的DataFrame: df4c
# Frequency: 1min -> 1s, fill_method: forward filling (eliminate Nan)
df4c = df2feb[['CLOSE']].resample(rule='1S',fill_method='ffill')               #方法-1
# df4c = pd.DataFrame(df2feb['CLOSE']).resample(rule='s',fill_method='ffill')  #方法-2

# <Step-2.2>
# 由df2feb.VOLUME生成的只有一列的DataFrame: df4v
# Frequency: 1min -> 1s, fill_method: NONE
df4v = df2feb[['VOLUME']].resample(rule='1S')               #方法-1
# df4v = pd.DataFrame(df2feb['VOLUME']).resample(rule='s')  #方法-2
# 处理NaN
df4v.fillna(value=0,inplace=True)   # NaN->0, 回写新数值，方法-1
# df4v = df4v.fillna(0)             # 方法-2，作用同上

# <Step3>
# 输出
# df4x = df4c            # 只输出df4c (dataframe of CLOSE)
# df4x = df4v            # 只输出df4v (dataframe of VOLUME)
df4x = df4c.join(df4v)   # 合并df4c,df4v后再输出

# df4x: 提取指定时段，不包括时段右边界(include_end=False)
df4x = df4x.between_time(start_time='17:30:00',end_time='23:00:00',include_end=False)

df4x

# 注意： 因为是将数据从freq=1minute upsampling to 1s，因此
#       会产生很多插入的空slot，数值=Nan。针对CLOSE和VOLUME的NaN
#       处理方式不同
#       NaN in CLOSE: fill_method='ffill', forward filling
#       NaN in VOLUME: fillna(0) -> NaN=0


# In[12]:

#---------------------------------------------------
# DataFrame Resample
#-----------------------------------
# Dealing with NaN
#---------------------------------------------------

# df2feb: 截取的2月份数据
df2feb = df2['2011-02-01':'2011-02-28']

# Upsampling to produce NaN
df5c = df2feb[['CLOSE']].resample(rule='1S')
# df5c
df5v = df2feb[['VOLUME']].resample(rule='1S')
# df5v

# Drop Nan
df5c.dropna(inplace=True)  # inplce=true: 改写调用对象, 方法-1
# df5c = df5c.dropna()     # 方法-2，效果同上
# df5c

# Forward filling
df5c.fillna(method='ffill',inplace=True)  #forward filling, 方法-1
# df5c = df5c.fillna(method='ffill')      #方法-2
# df5c

# Assigning a vaule
df5v.fillna(value=0,inplace=True)   # NaN->0, 方法-1
# df5v = df5v.fillna(0)             # 方法-2   
# df5v


# Process DataFrame with multiple columns
df5feb = df2feb.resample(rule='1S')
# df5feb
df5feb['CLOSE'].fillna(method='ffill',inplace=True)  #处理CLOSE列的NaN: forward filling
df5feb['VOLUME'].fillna(value=0,inplace=True)   #处理VOLUME列的NaN: NaN->0
df5feb


# In[13]:

#---------------------------------------------------
# DataFrame Misc-1
#-----------------------------------
# Add row(s)
#---------------------------------------------------


# Add one row
dfsrc = df1[0:10]   # a sample dataframe to be appened with new row

dfx = pd.DataFrame([[1,2,3,4,5,6,7,8]])  #生成新DataFrame，列数必须跟主DataFrame一致
dfx.columns = dfsrc.columns              #新DataFrame的column名必须跟主DataFrame一致
dfsrc = dfsrc.append(dfx,ignore_index=True)  #一定要有这个参数: ignore_index=True

print dfsrc

print '\n'


# Add multiple rows
dfsrc = df1[0:10] # a sample dataframe to be appened with new row

for i in range(10):   # add 10 rows
    dfx = pd.DataFrame([[i,1030,11234,1,2,3,4,1000]])
    dfx.columns = dfsrc.columns
    dfsrc = dfsrc.append(dfx,ignore_index=True)
    
print dfsrc


# In[14]:

#---------------------------------------------------
# DataFrame Misc-2
#-----------------------------------
# 不同行数的DataFrame合并
#---------------------------------------------------

# 生成两个不同长度的测试DF: df5a,df5b
df5x = df4x.copy()
df5a = df5x['2011-02-01 17:30:00':'2011-02-01 17:30:09'].copy()
df5b = df5x['2011-02-01 17:30:00':'2011-02-01 17:30:19'].copy()
print 'df5a: rows=',len(df5b),'\n',df5b
print
print 'df5b: rows=',len(df5b),'\n',df5b


# In[15]:

# 方法-1: 利用join(how='outer')合并生成一个新的DF，
#         行数等于df5a,df5b中最大者的行数
df5c = df5a.join(df5b,how='outer',lsuffix='-L',rsuffix='-R') 
print 'df5c: rows=',len(df5c),'\n',df5c

#备注: 因index和column name命相同的行join会报错，必须通过lsuffix/rsuffix参数
#      添加加后缀区分不同DF的列名


# In[16]:

#生成测试副本
df5ax = df5a.copy()
df5bx = df5b.copy()

# 方法-2: 添加NaN列，然后利用join(how='outer')方法对齐
if len(df5ax)>=len(df5bx):
    dfnan = pd.DataFrame(np.full(len(df5ax),np.nan)) #生成NaN DF
    dfnan = dfnan.set_index(df5ax.index)             #设置Nan DF的Index
else:
    dfnan = pd.DataFrame(np.full(len(df5bx),np.nan)) #生成NaN DF
    dfnan = dfnan.set_index(df5bx.index)             #设置Nan DF的Index
    
dfnan.columns=['NAN']                  #命名NaN DF的column
df5ax = df5ax.join(dfnan,how='outer')  #利用join对齐df5ax 
df5bx = df5bx.join(dfnan,how='outer')  #利用join对齐df5bx

print 'df5ax: rows=',len(df5ax),'\n',df5ax
print
print 'df5bx: rows=',len(df5bx),'\n',df5bx


# In[17]:

#生成测试副本
df5ax = df5a.copy()
df5bx = df5b.copy()

# 方法-3: 利用resample方法对齐df5a/df5b
if len(df5ax) > len(df5bx):       #如果len(df5ax)>len(df5bx)
    x = df5ax.iloc[-1].copy()     #提取df5ax最后一行
    x.CLOSE = np.nan              #columns赋值=Nan
    x.VOLUME = np.nan             #columns赋值=Nan
    df5bx = df5bx.append(x)       #添加到df5bx最后
    df5bx = df5bx.resample('1s')  #resample
else:
    if len(df5ax) < len(df5bx):   #如果len(df5bx)>len(df5ax)
        x = df5bx.iloc[-1].copy() #提取df5bx最后一行
        x.CLOSE = np.nan
        x.VOLUME = np.nan
        df5ax = df5ax.append(x)
        df5ax = df5ax.resample('1s')

print 'df5ax: rows=',len(df5ax),'\n',df5ax
print
print 'df5bx: rows=',len(df5bx),'\n',df5bx


# In[ ]:



