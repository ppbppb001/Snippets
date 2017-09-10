
# coding: utf-8

# In[1]:

# python general
import datetime as dt
from datetime import datetime
from datetime import time
from datetime import date
import time as tm

# numpy
import numpy as np

# pandas
import pandas as pd

# matplotlib
import matplotlib as mpl
from matplotlib import cm
from mpl_toolkits.mplot3d import Axes3D
import matplotlib.pyplot as plt

# display image in the cells of notebook
from IPython.display import Image  
from IPython.display import display


# In[2]:

# define the function to be called periodically
def mytask():
    print '> ',tm.asctime()


# In[3]:

# start a infinite loop to run <timer_task> every 2s
print '*** How to break the loop:'
print '*** Method-1: Toolbar: STOP'
print '*** Method-2: Menu: Kernel->Interrupt'
try:
    print '[START]'
    while True:
        mytask()
        tm.sleep(2)  # sleep/delay 2s
except:
    print '[END]: terminated by user'


# In[ ]:



