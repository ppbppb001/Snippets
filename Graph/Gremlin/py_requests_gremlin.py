#!/usr/bin/env python
# coding: utf-8

# In[ ]:


import requests
import sys
#import os


# In[ ]:


#############################
# Check arguments
#############################

args = sys.argv
# print (type(args),len(args))
# print (args)

# args = ['py', 
#         '--auth', 'user1234:pass1234', 
#         '--url',  'http://192.168.1.52:8182',
#         '--gremlin', 'g.V().range(0,1)']
# print (args)

# Check count of arguments
vlen = len(args) - 1
if ( vlen < 1):
    print ("Terminate. Arguments required.")
    exit()
    
# Check '--url':
try:
    idx = args.index('--url')
except:
    idx = -1
if (idx >= 0) and (idx < vlen):
    vUrl = args[idx+1]
#     print ('--url',vUrl)
else:
    print ("Terminate. '--url' required.")
    exit()

# Check '--auth:
try:
    idx = args.index('--auth')
except:
    idx = -1
if (idx >= 0) and (idx < vlen):
    vAuth = args[idx+1]
#     print ('--auth',vAuth)
    s = vAuth.split(':')
    if len(s) < 2:
        print ("username or password required for '--auth'.")
        exit()
    vUser = s[0]
    vPass = s[1]
#     print ('--auth','user=',vUser,'pass=',vPass)
else:
    print ("Terminate. '--auth' required.")
    exit()

# Check '--gremlin':
try:
    idx = args.index('--gremlin')
except:
    idx = -1
if (idx >= 0) and (idx < vlen):
    vGremlin = args[idx+1]
#     print ('--gremlin',vGremlin)
else:
    print ("Terminate. '--gremlin' required.")
    exit()

# Check '--outfile':
try:
    idx = args.index('--outfile')
except:
    idx = -1
if (idx >= 0) and (idx < vlen):
    vOutFile = args[idx+1]
#     print ('--outfile',vOutFile)
else:
    vOutFile = ''
    


# In[ ]:


resp = requests.post(vUrl, auth=(vUser, vPass), json = {'gremlin':vGremlin})
print ('Response status =', resp.status_code)
if (resp.status_code != 200):
    print ("Terminate. Access failed!")
    exit()    


# In[ ]:


if len(vOutFile) < 1:
    print (resp.text)
else:
    print ('Save response to <',vOutFile,">")
    f = open(vOutFile, "wt")
    f.write(resp.text)
    f.close();


# In[ ]:




