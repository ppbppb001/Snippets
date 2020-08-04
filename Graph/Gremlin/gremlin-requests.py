#!/usr/bin/env python
# coding: utf-8

# In[1]:


import requests
import json


# In[2]:


url = "http://192.168.1.52:8182"    # URL of janusgraph/gremlin server
username = "user1234"           
password = "pass1234"
query = 'g.V().range(0,10).count()'   # gremlin query: count of the first 10 nodes stored in janusgraph database


# In[3]:


resp = requests.post(url, auth = (username, password), json = {'gremlin' : query})
print (resp.status_code)   # 200 = OK!
print (resp.ok)            # true = OK!


# In[4]:


resj = resp.json()   # get the response of server in JSON format
print ('#<resj>:\n', resj, '\n')
print ('#<resj.keys()>:\n', resj.keys(), '\n')
print ('#<resj.items()>:\n', resj.items(), '\n')


# In[5]:


value = resj['result']['data']['@value'][0]['@value']
print ('count =',value)

