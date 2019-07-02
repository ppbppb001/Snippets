
# coding: utf-8

# In[1]:


from fuzzywuzzy import fuzz
from fuzzywuzzy import process


# In[2]:


fuzz.ratio("this is a test", "this is a test!")


# In[3]:


fuzz.partial_ratio("this is a test", "this is a test!")


# In[4]:


fuzz.ratio("fuzzy wuzzy was a bear", "wuzzy fuzzy was a bear")


# In[5]:


choices = ["Atlanta Falcons", "New York Jets", "New York Giants", "Dallas Cowboys"]
process.extract("new york jets", choices, limit=2) 


# In[6]:


process.extractOne("cowboys", choices)

