
# coding: utf-8

# In[ ]:

"""
Common ways of plot
"""


# In[1]:

import pandas as pd
import numpy as np

from sklearn import preprocessing

import matplotlib as mpl
import matplotlib.pyplot as plt
from matplotlib import cm
from matplotlib.colors import ListedColormap as lcmap
from mpl_toolkits.mplot3d import Axes3D

import seaborn as sns


# In[2]:

# time series - function for loading data

def load_preprocess():
    df0 = pd.read_csv('NYSE_no-finance_day_by_day_matrix_close_price.csv', header=None)
    dfo0 = pd.read_csv('NYSE_no-finance_day_by_day_matrix_open_price.csv', header=None)
    dfh0 = pd.read_csv('NYSE_no-finance_day_by_day_matrix_high_price.csv', header=None)
    dftr0 = pd.read_csv('NYSE_no-finance_macrotrend.csv', header=None)
    dfslp0 = pd.read_csv('NYSE_no-finance_macroreturn.csv', header=None)
    
    #stock prices only, exclude date
    dfp = df0.ix[4031:5288, 1:]
    dfpo = dfo0.ix[4031:5288, 1:]
    dfph = dfh0.ix[4031:5288, 1:]
    
    dfp = dfp.set_index(np.arange(0, len(dfp)))
    dfpo = dfpo.set_index(np.arange(0, len(dfpo)))
    dfph = dfph.set_index(np.arange(0, len(dfph)))
    
    dftr = dftr0.ix[0:dftr0.shape[0]-2, :]
    dfslp = dfslp0.ix[0:dfslp0.shape[0]-2, :]
    
    dftr = dftr.set_index(np.arange(0, len(dftr)))
    dfslp = dfslp.set_index(np.arange(0, len(dfslp)))
    
    #price differentiation
    dfp_d = dfp.diff()
    dfp_r = dfp_d / dfp.shift(1)
    dfp_d5 = dfp - dfp.shift(5)
    dfp_r5 = dfp_d5 / dfp.shift(5)
    
    return dfp, dfpo, dfph, dfp_d, dfp_r, dfp_d5, dfp_r5, dftr, dfslp

dfp, dfpo, dfph, dfp_d, dfp_r, dfp_d5, dfp_r5, dftr, dfslp = load_preprocess()


# In[42]:

# time series - curve plot
dftmp = dfp[[134, 166, 799, 687, 1502]]
dftmp.columns = ['Boeing', 'BHP', 'LinkedIn', 'IBM', 'Yelp']

dftmp.plot()
plt.legend(loc='upper left', prop={'size':12})
plt.xlabel('Trading days since 01/01/2010')
plt.ylabel('Price (US$)', fontsize=12)
plt.title('Samples of NYSE Listed Securities', fontsize=14)
plt.show()


# In[57]:

# time series - plot raw return of all equities as an image
dfp_d4 = dfp - dfp.shift(4)
dfp_r4 = dfp_d4 / dfp.shift(4)

dtmp = dfp_r
dtmp = dtmp.fillna(0)
dtmpm = dtmp.as_matrix()

fig = plt.figure(figsize=[12, 8], facecolor='white')
ax = fig.add_subplot(111)
im = ax.imshow(dtmpm, cmap=cm.jet, interpolation='nearest', origin='lower', vmin=-0.02, vmax=0.02)

ax.set_xlabel('Major NYSE listed securities', fontsize=14)
ax.set_ylabel('Trading days since 01/01/2010', fontsize=14)
ax.set_title('Daily Price Movement of Major NYSE Listed Securities', fontsize=16)
ax.set_xticks([0, dfp.shape[1]])
ax.set_xticklabels(['0', '1500'])
ax.set_yticks([0, dfp.shape[0]])
ax.set_yticklabels(['0', '1258'])

plt.colorbar(im, orientation='vertical')
plt.show()


# In[32]:

# scatter plot - 1D, 2D and 3D

#generate synthetic data
np.random.seed(0)
num = 30
pr = np.random.uniform(low=10, high=20, size=num).reshape(num, 1)
pp = np.random.uniform(low=10, high=20, size=num).reshape(num, 1)
rp = np.random.uniform(low=10, high=20, size=num).reshape(num, 1)
apr = np.cos(pr)*np.sin(pp)
label = 1*np.ones(num, np.int).reshape(num, 1)
label[apr>0] = 0
label[apr<=0] = 1

df0 = np.hstack((pr, pp, rp, apr, label))
df = pd.DataFrame(df0)
df.columns = ['pr', 'pp', 'rp', 'apr', 'label']

dcolor= ['red', 'blue']
labels = ['class1', 'class2']

#1D scatter plot
fig, ax = plt.subplots(nrows=1)

for i in range(len(dcolor)):
    xs = df['apr'][df['label']==i]
    ys = np.ones(len(xs), np.int)
    ax.scatter(xs, ys, c=dcolor[i], label=labels[i], linewidths=0)

ax.axvline(x=0, ls='dashed', linewidth=2, c='k')
ax.set_title('Binary class dataset X with single composite feature', fontsize=16)
ax.set_xlabel('Composite feature cos(x1)*sin(x2)', fontsize=14)
ax.legend()
ax.set_yticks([])
ax.set_yticklabels([])

plt.show()

# #2D scatter plot
# for i in range(len(dcolor)):
#     xs = df['pr'][df['label']==i]
#     ys = df['pp'][df['label']==i]
#     plt.scatter(xs, ys, c=dcolor[i], label=labels[i], linewidths=0)

# plt.title('Binary class dataset X with two features x1 and x2', fontsize=16)
# plt.xlabel('Feature x1', fontsize=14)
# plt.ylabel('Feature x2', fontsize=14)
# plt.legend(loc='lower left')
# plt.show()

# #3D scatter plot
# fig = plt.figure()
# ax = fig.add_subplot(111, projection='3d')

# for i in range(len(dcolor)):
#     xs = df['pr'][df['label']==i]
#     ys = df['pp'][df['label']==i]
#     zs = df['rp'][df['label']==i]
#     ax.scatter(xs, ys, zs, c=dcolor[i], marker='o', alpha=1, linewidths=0)
# plt.show()    


# In[3]:

# bar plot, subplot
lsmem = [190, 660, 2130]
lsbala = [10144.07, 20655.94, 20905.43]
index = np.arange(len(lsmem)).tolist()
years = [2014, 2015, 2016]

fig, ax = plt.subplots(figsize = [15,8], ncols=2)

bar_width=0.35


ax[0].bar(index, lsmem, bar_width, align='center', color='green', tick_label=years)
ax[1].bar(index, lsbala, bar_width, align='center', color='yellow', tick_label=years)

ax[0].set_title('Membership fee collected over 2014 ~ 2016', fontsize=16)
ax[0].set_ylabel('Membership fee collected ($)', fontsize=14)
ax[0].set_xticklabels(years, fontsize=14)

ax[1].set_title('Account closing balance over 2014 ~ 2016', fontsize=16)
ax[1].set_ylabel('Account closing balance ($)', fontsize=14)
ax[1].set_xticklabels(years, fontsize=14)

plt.show()


# In[5]:

# mesh plot using custom colormap
x = np.arange(10)
colors = ('red', 'blue', 'lightgreen', 'gray', 'cyan', 'black')
cmap1 = lcmap(colors[0:len(x)])

xx1, xx2 = np.meshgrid(np.arange(0,3), np.arange(0,4))
z1 = np.array([xx2.ravel()]).T
z2 = z1.reshape(xx2.shape)

cmap2 = lcmap(colors[0:len(np.unique(z2))])
plt.contourf(xx1, xx2, z2, cmap=cmap2)
plt.show()


# In[28]:

# image - display synthetic image

#generate image grid
lsx = []
for v in range(-2,3,1):
    lsv = []
    for t in range(-1,2,1):
        lsv.append(t*v)
    lsx.append(lsv)
a = np.array(lsx)
    
#range of image display
vv = np.linspace(-2.5,2.5,6)
tt = np.linspace(-1.5,1.5,4)
ext = [tt[0], tt[-1], vv[0], vv[-1]]

#display image
fig = plt.figure()
ax = fig.add_subplot(111)
ax.imshow(a, extent=ext, cmap=cm.jet, origin='lower')

#draw labels of axes
ax.set_xlabel('tt')
ax.set_ylabel('vv')

#draw colorbar
# nrm = mpl.colors.Normalize(np.min(a), np.max(a))
# csubplt, kw = mpl.colorbar.make_axes(ax, shrink=0.6)
# mpl.colorbar.ColorbarBase(csubplt, cm.jet, norm=nrm)

csubplt, kw = mpl.colorbar.make_axes(ax, shrink=1)
mpl.colorbar.ColorbarBase(csubplt, cm.jet)

plt.show()
fig.savefig('test1.png')


# In[67]:

# two variables correlated plot
longet = pd.read_csv('features_longevity_mixall.csv')
longet['hybrid_metric'] = longet.iloc[:, 4] + 2.2*longet.iloc[:, 8]

scaler = preprocessing.StandardScaler().fit(longet['hybrid_metric'])
longet['hybrid_metric_norm'] = scaler.transform(longet['hybrid_metric'])

ax = sns.jointplot(longet['hybrid_metric_norm'], longet['age'], kind='hex', stat_func=None, xlim=(-2.8, 2.8), ylim=(35, 95))
ax.set_axis_labels('hybrid_facial_metric_1', 'lifespan', fontsize=16)

plt.colorbar()
plt.show()


# In[ ]:

# groupby plot


# In[23]:




# In[ ]:



