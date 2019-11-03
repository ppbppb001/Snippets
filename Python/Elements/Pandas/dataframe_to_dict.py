
# coding: utf-8

# In[1]:


import pandas as pd


# In[2]:


df1 = pd.DataFrame(data=[["Joan Bradley",3],["Manning Clark",4],["Mapleton Ave",5],["Oodgeroo Ave",6]],
                   columns=["Address","Count"])
df1


# In[3]:


df2 = pd.DataFrame(data=[["Joan Bradley",0],["Manning Clark",0],["Mapleton Ave",0],["Oodgeroo Ave",0]],
                   columns=["Address","Result"])
df2


# In[4]:


dict = pd.Series(data=df1.Count.values, index=df1.Address.values ).to_dict()


# In[5]:


df2['Result'] = df2['Address'].apply(lambda x: dict[x])


# In[6]:


df2

