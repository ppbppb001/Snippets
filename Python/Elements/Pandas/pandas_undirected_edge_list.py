
# coding: utf-8

# In[1]:


import pandas as pd


# In[2]:


df1 = pd.DataFrame([["James","Robert"],["James","Robert"],["James","Andrew"],["Robert","James"],["0101","2020"],["2020","0101"]],
                   columns=["ColA","ColB"])
df1


# In[3]:


df2 = df1.drop_duplicates()
df2


# In[4]:


df2['ColC'] = df2.apply(lambda x: x['ColA'] + '_' + x['ColB'] if x['ColA'] >= x['ColB'] else x['ColB'] + '_' + x['ColA'], axis=1)
df2


# In[5]:


df2.drop_duplicates(subset=["ColC"])

