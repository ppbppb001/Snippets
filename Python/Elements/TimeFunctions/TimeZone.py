
# coding: utf-8

# In[1]:

#-----------------------------------------------------------------
# 第一步：导入所需的库模块
#-----------------------------------------------------------------
# -*- coding: utf-8 -*- #设置文字编码为UTF-8，以便支持中文打印输出
import datetime            #导入datetime库
import time                #导入time库
import calendar            #导入calendar库
import pytz                #导入pytz库 (python timezone)


# In[2]:

#-----------------------------------------------------------------
# 第二步：创建时区对象
#-----------------------------------------------------------------
print '[2] 创建 timezone 对象:'

tz_utc = pytz.timezone('UTC')                      #创建UTC时区：tz_utc
tz_syd = pytz.timezone('Australia/Sydney')         #创建<悉尼>时区：tz_syd
tz_hk = pytz.timezone('Asia/Hong_Kong')            #创建<香港>时区：tz_hk
tz_sh = pytz.timezone('Asia/Shanghai')             #创建<上海>时区：tz_sh
tz_tokyo = pytz.timezone('Asia/Tokyo')             #创建<东京>时区：tz_tokyo
tz_seoul = pytz.timezone('Asia/Seoul')             #创建<首尔>时区：tz_seoul
tz_sig = pytz.timezone('Asia/Singapore')           #创建<新加坡>时区：tz_sig
tz_nyc = pytz.timezone('America/New_York')         #创建<纽约>时区：tz_nyc

#DEBUG：打印检查所创建的时区对象
print 'tz_utc =',tz_utc         #DEBUG_PRINT
print 'tz_syd =',tz_syd         #DEBUG_PRINT
print 'tz_hk =',tz_hk           #DEBUG_PRINT
print 'tz_sh =',tz_sh           #DEBUG_PRINT
print 'tz_tokyo =',tz_tokyo     #DEBUG_PRINT
print 'tz_seoul =',tz_seoul     #DEBUG_PRINT
print 'tz_sig =',tz_sig         #DEBUG_PRINT
print 'tz_nyc =',tz_nyc         #DEBUG_PRINT


# In[3]:

#-----------------------------------------------------------------
# 第三步：设定交易时间
#-----------------------------------------------------------------
print '[3] 设定交易时间：'
tt_trade = datetime.datetime(1970,1,1,9,30,0)    #tt_trade: 设定交易时间datetime对象（无时区信息）
print 'tt_trade =',tt_trade


# In[4]:

#-----------------------------------------------------------------
# 第四步：不同时区时间变换 & timestamp转换
#-----------------------------------------------------------------
#    Test-1: 香港->悉尼
#-----------------------------------------------------------------
print '[4.1] Test-1: 香港->悉尼'
print '* From <香港>：'

#创建<香港>交易时间
tt_hk=tz_hk.localize(tt_trade)                      #从设定交易时间tt_trade创建香港时区交易时间
print 'tt_hk =',tt_hk,'| tz =',tt_hk.tzinfo         #DEBUG_PRINT

#提取<香港>交易时间timestamp
ts_hk = calendar.timegm(tt_hk.timetuple())          #ts_hk=香港时区的timestamp
print 'ts_hk =',ts_hk,' (python_timestamp)'            
tsone_hk = int(ts_hk * 1e9)                           #tsone_hk=香港时区的onetick timestamp (resolution = 1ns = 10e-9s)
print 'tsone_hk =',tsone_hk,'  (onetick_timestamp)'

print '* To <悉尼>：'
#<香港>交易时间转换为<悉尼>时间
tt_syd = tt_hk.astimezone(tz_syd)                     #将香港交易时间tt_hk转换为悉尼时间tt_syd
print 'tt_syd =',tt_syd,'| tz=',tt_syd.tzinfo          #DEBUG_PRINT

#提取<悉尼>时间timestamp
ts_syd = calendar.timegm(tt_syd.timetuple())              #ts_syd=悉尼时区的timestamp
print 'ts_syd =',ts_syd,'  (python_timestamp)'
tsone_syd = int(ts_syd * 1e9)                         #tsone_syd=悉尼时区的onetick timestamp
print 'tsone_syd =',tsone_syd,'  (onetick_timestamp)'


# In[5]:

#-----------------------------------------------------------------
# 第四步：不同时区时间变换 & timestamp转换
#-----------------------------------------------------------------
#    Test-2: 悉尼->香港
#-----------------------------------------------------------------
print '[4.2] Test-2: 悉尼->香港'
print '* From <悉尼>：'

#创建<悉尼>交易时间
tt_syd=tz_syd.localize(tt_trade)                      #从设定交易时间tt_trade创建悉尼时区交易时间
print 'tt_syd =',tt_syd,'| tz =',tt_syd.tzinfo          #DEBUG_PRINT

#提取<悉尼>交易时间timestamp
ts_syd = calendar.timegm(tt_syd.timetuple())              #ts_syd=悉尼时区的timestamp
print 'ts_syd =',ts_syd,' (python_timestamp)'            
tsone_syd = int(ts_syd * 1e9)                         #tsone_syd=悉尼时区的onetick timestamp (resolution = 1ns = 10e-9s)
print 'tsone_syd =',tsone_syd,'  (onetick_timestamp)'

print '* To <香港>：'
#<悉尼>交易时间转换为<香港>时间
tt_hk = tt_syd.astimezone(tz_hk)                      #将悉尼交易时间tt_hk转换为香港时间tt_syd
print 'tt_hk =',tt_hk,'| tz=',tt_hk.tzinfo             #DEBUG_PRINT

#提取<香港>时间timestamp
ts_hk = calendar.timegm(tt_hk.timetuple())                #ts_syd=香港时区的timestamp
print 'ts_hk =',ts_hk,'  (python_timestamp)'
tsone_hk = int(ts_hk * 1e9)                           #tsone_syd=香港时区的onetick timestamp
print 'tsone_hk =',tsone_hk,'  (onetick_timestamp)'


# In[6]:

#-----------------------------------------------------------------
# 第四步：不同时区时间变换 & timestamp转换
#-----------------------------------------------------------------
#    Test-3: 东京->悉尼
#-----------------------------------------------------------------
print '[4.3] Test-3: 东京->悉尼'
print '* From <东京>：'

#创建<东京>交易时间
tt_tokyo = tz_tokyo.localize(tt_trade)                #从设定交易时间tt_trade创建东京时区交易时间
print 'tt_tokyo =',tt_tokyo,'| tz =',tt_tokyo.tzinfo    #DEBUG_PRINT

#提取<东京>交易时间timestamp
ts_tokyo = calendar.timegm(tt_tokyo.timetuple())          #ts_tokyo=东京时区的timestamp
print 'ts_tokyo =',ts_tokyo,' (python_timestamp)'            
tsone_tokyo = int(ts_tokyo * 1e9)                     #tsone_tokyo=东京时区的onetick timestamp
print 'tsone_tokyo =',tsone_tokyo,'  (onetick_timestamp)'

print '* To <悉尼>：'
#<香港>交易时间转换为<悉尼>时间
tt_syd = tt_tokyo.astimezone(tz_syd)                  #将东京交易时间tt_tokyo转换为悉尼时间tt_syd
print 'tt_syd =',tt_syd,'| tz=',tt_syd.tzinfo          #DEBUG_PRINT

#提取<悉尼>时间timestamp
ts_syd = calendar.timegm(tt_syd.timetuple())              #ts_syd=悉尼时区的timestamp
print 'ts_syd =',ts_syd,'  (python_timestamp)'
tsone_syd = int(ts_syd * 1e9)                         #tsone_syd=悉尼时区的onetick timestamp
print 'tsone_syd =',tsone_syd,'  (onetick_timestamp)'


# In[7]:

#-----------------------------------------------------------------
# 第四步：不同时区时间变换 & timestamp转换
#-----------------------------------------------------------------
#    Test-4: 悉尼->东京
#-----------------------------------------------------------------
print '[4.4] Test-4: 悉尼->东京'
print '* From <悉尼>：'

#创建<悉尼>交易时间
tt_syd = tz_syd.localize(tt_trade)                      #从设定交易时间tt_trade创建悉尼时区交易时间
print 'tt_syd =',tt_syd,'| tz =',tt_syd.tzinfo          #DEBUG_PRINT

#提取<悉尼>交易时间timestamp
ts_syd = calendar.timegm(tt_syd.timetuple())              #ts_syd=悉尼时区的timestamp
print 'ts_syd =',ts_syd,' (python_timestamp)'            
tsone_syd = int(ts_syd * 1e9)                         #tsone_syd=悉尼时区的onetick timestamp (resolution = 1ns = 10e-9s)
print 'tsone_syd =',tsone_syd,'  (onetick_timestamp)'

print '* To <东京>：'
#<悉尼>交易时间转换为<东京>时间
tt_tokyo = tt_syd.astimezone(tz_tokyo)                #将悉尼交易时间tt_hk转换为东京时间tt_syd
print 'tt_tokyo =',tt_tokyo,'| tz=',tt_tokyo.tzinfo    #DEBUG_PRINT

#提取<东京>时间timestamp
ts_tokyo = calendar.timegm(tt_tokyo.timetuple())          #ts_syd=东京时区的timestamp
print 'ts_tokyo =',ts_tokyo,'  (python_timestamp)'
tsone_tokyo = int(ts_tokyo * 1e9)                     #tsone_syd=东京时区的onetick timestamp
print 'tsone_tokyo =',tsone_tokyo,'  (onetick_timestamp)'


# In[ ]:



