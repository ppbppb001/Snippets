
# coding: utf-8

# In[1]:


import pandas as pd


# In[2]:


# Retrieve all columns in csv file as string type:
# df = pd.read_csv('mydata.csv', dtype=str)


# In[3]:


df = pd.DataFrame(data = ["123", "123 456 789", float("Nan"), None, "234 567 890"],
                  columns = ["A"])
df


# In[4]:


print type(df.iloc[1,0])


# In[5]:


df["A"] = df["A"].fillna("0")
df


# In[6]:


df["A"] = df["A"].astype(dtype=str)
df["A"] = df["A"].apply(lambda x: x.replace(" ",""))
df


# In[7]:


df["A"] = df["A"].astype(dtype=int)
df


# In[8]:


print type(df.iloc[0,0])

