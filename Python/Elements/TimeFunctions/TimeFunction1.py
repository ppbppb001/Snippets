
# coding: utf-8

# In[1]:


# DateTime Functions Part-1 
# V1.0 / 2015-08-23
# V1.1 / 2018-01-23

#-----------------------------------------------------------------
# 导入所需的库模块
#-----------------------------------------------------------------
# -*- coding: utf-8 -*- #设置文字编码为UTF-8，以便支持中文打印输出
import datetime            #导入datetime库
import time                #导入time库
import calendar            #导入calendar库
import pytz                #导入pytz库 (python timezone)


# In[2]:


#-----------------------------------------------------------------
# 创建timezone对象
#-----------------------------------------------------------------
print '[ 创建 timezone 对象 ]\n'

# 创建timezone对象
#
tz_utc = pytz.timezone('UTC')                      #创建UTC时区：tz_utc
tz_syd = pytz.timezone('Australia/Sydney')         #创建<悉尼>时区：tz_syd
tz_hk = pytz.timezone('Asia/Hong_Kong')            #创建<香港>时区：tz_hk
tz_sh = pytz.timezone('Asia/Shanghai')             #创建<上海>时区：tz_sh
tz_tokyo = pytz.timezone('Asia/Tokyo')             #创建<东京>时区：tz_tokyo
tz_seoul = pytz.timezone('Asia/Seoul')             #创建<首尔>时区：tz_seoul
tz_sig = pytz.timezone('Asia/Singapore')           #创建<新加坡>时区：tz_sig
tz_nyc = pytz.timezone('America/New_York')         #创建<纽约>时区：tz_nyc

#DEBUG：打印检查所创建的时区对象
#
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
# 创建datetime对象 (无时区属性)
#-----------------------------------------------------------------
print '[ 创建 datetime 对象 ]\n'

year = 1970
month = 1
day = 1
hour = 12
minute = 0
second = 1
microsecond = 123000   # 123000us = 123ms = 0.123s
tt = datetime.datetime(year,month,day,hour,minute,second,microsecond)    # tt = 无时区属性时间对象
print 'tt = ',tt,'| timezone = ',tt.tzinfo


# In[4]:


#-----------------------------------------------------------------
# datetime对象 -> timestamp变量
#-----------------------------------------------------------------
print '[ From <datetime对象> To <timestamp变量> ]\n'

ttsyd = tz_syd.localize(tt)              #由tt生成悉尼时区的datetime对象ttsyd
print "From: ttsyd = ",ttsyd

# 获取本地时间TimeStamp (不进行时区变换)
ts = calendar.timegm(ttsyd.timetuple()) + (ttsyd.microsecond*1e-6)         # ts = 本地时区的timestamp，不进行时区变换
print "  To: ts = %.6f" % ts,"  (Local timestamp)"                         # ts = tts的timestamp, 精确到微秒us(1e-6(s))

# 获取UTC TimeStamp (进行时区变换)
tsutc = calendar.timegm(ttsyd.utctimetuple()) + (ttsyd.microsecond*1e-6)   # tsutc = 进行时区变换，得到此刻UTC时区的timestamp
print "  To: tsutc = %.6f" % tsutc,"  (NTC timestamp)"


# In[5]:


#-----------------------------------------------------------------
# timestamp变量 -> datetime对象 
#-----------------------------------------------------------------
print '[ From <timestamp变量> To <datetime对象> ]\n'

tt2 = datetime.datetime.utcfromtimestamp(ts)     # 由timestamp变量ts，生成datetime对象tt2(无时区属性)
print 'From: ts =  %.6f' % ts
print '  To: tt2 = ',tt2


# In[6]:


#-----------------------------------------------------------------
# 生成带时区属性的datetime对象
#-----------------------------------------------------------------
print '[ 生成带时区属性的datetime对象 ]\n'

# 例子-1：sydney的datetime对象
#
tt_syd = tz_syd.localize(tt)           # 由datetime对象tt，生成新的datetime对象tt_syd(sydney时区)
print 'tt_syd = ',tt_syd,'| timezone = ',tt_syd.tzinfo

# 例子-2：hongkong的datetime对象
#
tt_hk = tz_hk.localize(tt)             # 又datetime对象tt，生成新的datetime对象tt_syd(hongkong时区)
print 'tt_hk =  ',tt_hk,'| timezone = ',tt_hk.tzinfo


# In[7]:


#-----------------------------------------------------------------
# datetime对象的时区变换
#-----------------------------------------------------------------
print '[ datetime对象的时区变换 ]\n'

# 例子1：已知hongkong时间tt_hkx，求此刻的悉尼时间tt_sydx
#
tt_hkx = tt_hk                         # 假设tt_hkx等于上述已定义的tt_hk
tt_sydx = tt_hkx.astimezone(tz_syd)    # 使用astimezone方法，由tt_hkx导出tt_sydx
print 'From: tt_hkx =  ',tt_hkx, '| timezone = ',tt_hkx.tzinfo
print '  To: tt_sydx = ',tt_sydx, '| timezone = ',tt_sydx.tzinfo
print

# 例子2：已知sydney时间tt_sydx，求此刻的hongkong时间tt_hkx
#
tt_hkx = tt_sydx.astimezone(tz_hk)    # 使用astimezone方法，由tt_sydx导出tt_hkx
print 'From: tt_sydx = ',tt_sydx, '| timezone = ',tt_sydx.tzinfo
print '  To: tt_hkx =  ',tt_hkx, '| timezone = ',tt_hkx.tzinfo


# In[8]:


#-----------------------------------------------------------------
# 字符串<->datetime对象
#-----------------------------------------------------------------
print '[ 字符串<->datetime对象 ]\n'

# 日期时间字符串->datetime对象
#
datestr = '12/30/2010'
timestr = '930'
dtstr = datestr+' '+timestr
print 'From: ',dtstr
ttx = datetime.datetime.strptime(dtstr,'%m/%d/%Y %H%M') # ttx is a datetime object
print '  To: ',ttx
print

# datetime对象->日期时间字符串
#
dtstr2 = ttx.strftime('%Y/%m/%d %H:%M:%S')   # datetime object -> formatted string
print 'From: ',ttx
print '  To: ',dtstr2
#
dtstr2_date = ttx.strftime("%Y-%m-%d")       # datetime object -> formatted string
print "Date: ",dtstr2_date
# 
dtstr2_time = ttx.strftime("%H:%M:%S")       # datetime object -> formatted string
print "Time: ",dtstr2_time


# In[9]:


#----------------------------------------------------
# Convert to UTC timezone
#----------------------------------------------------
tt_trade1 = datetime.datetime(2015, 6, 7, 9, 30, 0)
tt_hk1 = tz_hk.localize(tt_trade1) #Hong Kong time zone trade time
tt_utc1 = tt_hk1.astimezone(tz_utc) #convert to UTC time zone
ts_utc1 = int(calendar.timegm(tt_utc1.timetuple())) #ts_utc1 for time bucket allocation
print 'UTC: ',tt_utc1, ts_utc1


# In[10]:


#-------------------------------------------------
# Difference of two datetime strings
#-------------------------------------------------

dtstr1 = "2006-01-02 10:08:12.12345"
dtx1 = datetime.datetime.strptime(dtstr1, "%Y-%m-%d %H:%M:%S.%f") # string -> datetime object
print dtx1
print "year=",dtx1.year, "month=",dtx1.month, "day=",dtx1.day, "hour=",dtx1.hour, "minute=",dtx1.minute   # output elements of dtx1

dtstr2 = "2006-01-04 08:15:10.12345"
dtx2 = datetime.datetime.strptime(dtstr2, "%Y-%m-%d %H:%M:%S.%f") # string -> datetime object
print dtx2
print "year=",dtx2.year, "month=",dtx2.month, "day=",dtx2.day, "hour=",dtx2.hour, "minute=",dtx2.minute   # output elements of dtx2

ddtx =  dtx2 - dtx1                 # Difference of 2 datetime objects
print "\n",type(ddtx)               # ddtx is a timedelta object
print ddtx.days, "day(s) plus",ddtx.seconds,"second(s)"  # difference in days plus seconds
print "total",ddtx.total_seconds(),"second(s)"           # difference in seconds

